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
    progress_bar,
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

  future({
    # NOTE: it's not possible to share database connections btwn
    # multiple R processes due to a limitation in {DBI}.
    # reference: https://github.com/rstudio/pool/issues/83#issuecomment-812602134
    # therefore, we must make a new connection for each
    # {future} session & close it on exit.
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
  progress_value <- record$progress_value
  hx_trigger <- "every 3s"

  is_done <- progress_value >= 100
  if (is_done) {
    progress_id <- NULL
    progress_value <- 100L
    hx_trigger <- "load"
  }

  html <- progress_bar(
    progress_id = progress_id,
    progress_value = progress_value,
    is_striped = TRUE,
    hx_trigger = hx_trigger
  )
  res$send(html)
}

#' Handle GET at '/computation-div/complete'
#'
#' @export
get_computation_complete_div <- \(req, res) {
  html <- computation_div(
    btn_label = "Restart computation",
    show_loading_spinner = FALSE,
    show_progress_bar = TRUE,
    progress_value = 100L,
    is_striped = FALSE,
    progress_hx_trigger = NULL
  )
  res$send(html)
}

#' Handler for 500 server errors
#'
#' @param error The error object. See [stop()].
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
  get("/progress/:id", get_progress)$
  get("/computation-div/complete", get_computation_complete_div)

app$error <- error_handler

app$on_stop <- \() {
  dbDisconnect(conn = conn)
  delete_cache_db()
}

app$start()
