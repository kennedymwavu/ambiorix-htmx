box::use(
  htmltools[tags]
)

#' Create a progress bar
#'
#' @param id The id of the progress bar.
#' @return An object of class `shiny.tag`.
#' @export
progress_bar <- \(id) {
  tags$div(
    id = id,
    class = "progress rounded-top-0",
    role = "progressbar",
    `aria-label` = "File upload progress",
    `aria-valuenow` = 0,
    `aria-valuemin` = 0,
    `aria-valuemax` = 100,
    tags$div(
      class = "progress-bar",
      style = "width: 0%",
      "0%"
    )
  )
}
