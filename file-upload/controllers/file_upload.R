box::use(
  htmltools[tags],
  data.table[fread],
  uuid[UUIDgenerate],
  webutils[parse_http],
  .. / templates / template_path[template_path],
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

  file_name <- paste0(
    UUIDgenerate(),
    basename(postdata[["file"]][["filename"]])
  )

  # file_path <- file.path(getwd(), file_name)
  # on.exit(unlink(file_path))

  # writeBin(object = postdata$file$value, con = file_path)
  # uploaded <- fread(file = file_path)
  # print(uploaded)

  html <- tags$p(
    class = "text-success",
    "File uploaded successfully!"
  )
  res$send(html)
}
