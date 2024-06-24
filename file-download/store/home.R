box::use(
  htmltools[tags, tagList],
  . / components / card[card],
  . / components / button[button],
  . / components / select_input[select_input],
)

#' Home page
#'
#' @export
home_page <- \() {
  tags$div(
    class = "container",
    card(
      title = "Downloading data",
      class = "my-3",
      select_input(
        id = "selector",
        label = "Pick a dataset:",
        label_class = "fw-bold",
        choices = c("iris", "rock", "pressure", "cars"),
        selected = "rock",
        hx_post = "/dataset",
        hx_trigger = "load, change, submit",
        hx_target = "#dataset",
        hx_swap = "outerHTML"
      ),
      button(
        id = "download",
        class = "btn-primary",
        type = "submit",
        tags$i(class = "bi bi-download"),
        "Download"
      )
    ),
    tags$div(id = "dataset")
  )
}
