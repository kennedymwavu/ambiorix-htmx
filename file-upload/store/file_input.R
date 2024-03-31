box::use(
  htmltools[tags],
  . / progress_bar[progress_bar]
)

#' File input
#'
#' @param id The id of the file input.
#' @return An object of class `shiny.tag`.
#' @export
file_input <- \(id) {
  progress_id <- paste0(id, "_progress")
  progress_script <- sprintf("update_upload_progress('%s')", progress_id)
  tags$div(
    class = "mb-3",
    tags$label(
      class = "form-label",
      `for` = id,
      "Choose file & click upload:"
    ),
    tags$input(
      class = "form-control rounded-bottom-0",
      type = "file",
      id = id,
      name = id
    ),
    progress_bar(id = progress_id),
    tags$script(progress_script)
  )
}
