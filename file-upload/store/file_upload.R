box::use(
  htmltools[tags],
  . / file_input[file_input],
  . / create_button[create_button]
)

#' File upload page
#'
#' @export
page <- \() {
  tags$div(
    class = "container",
    tags$h1("File Upload"),
    file_upload_form(),
    tags$div(id = "content")
  )
}

#' File upload form
#'
#' @export
file_upload_form <- \() {
  tags$form(
    id = "form",
    `hx-post` = "/upload",
    `hx-target` = "#content",
    `hx-swap` = "innerHTML",
    file_input(id = "file"),
    create_button(
      type = "submit",
      class = "btn btn-primary rounded-1",
      tags$i(class = "bi bi-upload"),
      "Upload"
    )
  )
}
