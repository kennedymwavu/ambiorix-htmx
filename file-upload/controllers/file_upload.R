box::use(
  rlang[inject],
  htmltools[tags],
  data.table[fread],
  uuid[UUIDgenerate],
  webutils[parse_http],
  .. / templates / template_path[template_path],
  .. / store / datatable[
    datatable,
    default_datatable_options
  ],
  .. / store / create_card[create_card],
  .. / store / file_upload[file_upload_page = page]
)

#' Handle GET at '/'
#'
#' @param req Request object.
#' @param res Response object.
#' @export
home_get <- \(req, res) {
  res$render(
    template_path("page.html"),
    list(
      title = "File Upload",
      content = file_upload_page()
    )
  )
}

#' Handle POST on '/upload'
#'
#' @param req Request object.
#' @param res Response object.
#' @export
file_upload <- \(req, res) {
  content_type <- req$CONTENT_TYPE
  body <- req$rook.input$read()
  postdata <- parse_http(body, content_type)

  file_name <- paste(
    UUIDgenerate(),
    basename(postdata[["file"]][["filename"]]),
    sep = "-"
  )

  file_path <- file.path(getwd(), file_name)
  writeBin(object = postdata$file$value, con = file_path)

  # determine the colnames:
  col_names <- data.table::fread(file = file_path, nrows = 3L) |> colnames()

  html <- inject(
    create_card(
      class = "my-3",
      datatable(
        col_names = col_names,
        table_id = "uploaded_data",
        # send a GET request (the default for ajax) to "/data/:file_name"
        ajax = paste0("/data/", file_name),
        !!!default_datatable_options()
      )
    )
  )

  res$send(html)
}

#' Handle GET at '/data/:file_name'
#'
#' @param req Request object.
#' @param res Response object.
#' @export
get_uploaded <- \(req, res) {
  draw <- req$query$draw
  start_row <- as.integer(req$query$start) + 1L # datatables use 0-based indexing (JS)
  num_of_rows <- as.integer(req$query$length) - 1L
  end_row <- start_row + num_of_rows

  file_name <- req$params$file_name
  uploaded <- data.table::fread(file = file_name)
  search_res <- uploaded

  # perform search:
  search_value <- req$query$`search[value]`
  if (!is.null(search_value)) {
    found <- lapply(uploaded, \(cl) {
      grepl(pattern = search_value, x = cl, ignore.case = TRUE)
    }) |>
      as.data.frame() |>
      rowSums(na.rm = TRUE)
    found <- which(found > 0)
    search_res <- uploaded[found]
  }

  records_filtered <- nrow(search_res)
  end_row <- if (end_row > records_filtered) records_filtered else end_row

  # filter out the requested rows:
  row_inds <- seq(from = start_row, to = end_row, by = 1L)
  filtered <- search_res[row_inds]

  # datatable expects json:
  response <- list(
    draw = draw,
    recordsTotal = nrow(uploaded),
    recordsFiltered = records_filtered,
    data = filtered
  )
  res$json(response)
}
