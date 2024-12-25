box::use(
  ambiorix[Ambiorix],
  htmltools[tags, tagList],
  future[
    plan,
    future,
    multisession,
  ],
  DBI[dbDisconnect],
  . / basepath[basepath],
  . / db_operations[
    make_conn,
    delete_cache_db,
    create_progress_record,
    read_progress_record,
    update_progress_record,
    delete_progress_record,
  ],
  . / components[
    home_page,
    computation_div,
  ],
)

plan(multisession)

#' Global conn
conn <- make_conn()

#' Handle GET at '/'
#'
#' @export
home_get <- \(req, res) {
  res$render(
    basepath("templates", "page.html"),
    list(
      title = "Async progress",
      content = home_page()
    )
  )
}

#' Handle POST at '/compute'
#'
#' @export
compute_post <- \(req, res) {
  record <- create_progress_record(conn = conn)
  x <- box::file("test.txt")

  future({
    conn <- make_conn()
    on.exit(dbDisconnect(conn = conn))

    n <- 20
    for (i in 1:n) {
      Sys.sleep(2)

      progress_value <- as.integer(i / n * 100)
      update_progress_record(
        conn = conn,
        progress_id = record$progress_id,
        progress_value = progress_value
      )
    }
  })

  html <- computation_div(
    show_loading_spinner = TRUE,
    show_progress_bar = TRUE,
    progress_id = record$progress_id,
    progress_value = record$progress_value
  )
  res$send(html)
}

#' Handle GET at '/progress/:id'
#'
#' @export
get_progress <- \(req, res) {
  progress_id <- req$params$id
  record <- read_progress_record(conn = conn, progress_id = progress_id)
  is_done <- record$progress_value >= 100

  html <- computation_div(
    show_loading_spinner = !is_done,
    show_progress_bar = TRUE,
    progress_id = if (!is_done) progress_id,
    progress_value = record$progress_value,
    is_striped = !is_done
  )
  res$send(html)
}

#' Handler for 500 server errors
#'
#' @param error The erro object. See [stop()].
#' @export
error_handler <- \(req, res, error = NULL) {
  if (!is.null(error)) {
    message("An error occurred:\n", error)
  }

  res$set_status(500L)$send("A server error occurred!")
}

app <- Ambiorix$
  new(port = 8000L)$
  static("public", "assets")$
  get("/", home_get)$
  post("/compute", compute_post)$
  get("/progress/:id", get_progress)

app$error <- error_handler

app$on_stop <- \() {
  dbDisconnect(conn = conn)
  delete_cache_db()
}

app$start()
