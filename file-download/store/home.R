box::use(
  htmltools[tags, tagList],
  . / components / card[card],
  . / components / button[button],
  . / components / spinner[spinner],
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
        id = "dataset_name",
        label = "Pick a dataset:",
        label_class = "fw-bold",
        choices = c("iris", "rock", "pressure", "cars"),
        selected = "rock",
        `hx-get` = "/dataset",
        `hx-trigger` = "load, change",
        `hx-target` = "#dataset",
        `hx-swap` = "outerHTML",
        `hx-indicator` = "#dataset-spinner"
      )
    ),
    tags$div(
      id = "dataset-spinner",
      class = "htmx-indicator",
      spinner()
    ),
    tags$div(id = "dataset")
  )
}
