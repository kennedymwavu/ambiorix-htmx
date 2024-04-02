box::use(
  htmltools[tags],
  . / file_input[file_input],
  . / create_card[create_card],
  . / create_button[create_button]
)

#' File upload page
#'
#' @export
page <- \() {
  tags$div(
    class = "container",
    create_card(
      class = "my-3",
      title = "File Upload",
      file_upload_form()
    ),
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
    file_input(
      id = "file",
      label = "Choose csv file & click upload:"
    ),
    create_button(
      type = "submit",
      class = "btn btn-primary rounded-1",
      tags$i(class = "bi bi-upload"),
      "Upload"
    )
  )
}
