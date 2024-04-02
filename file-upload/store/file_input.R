box::use(
  htmltools[tags],
  . / progress_bar[progress_bar]
)

#' File input
#'
#' @param id String. The id of the file input.
#' @param label The label to use for the input. Defaults to
#' "Choose file & click upload:"
#' @param accept Character vector. The file types that the file input should
#' accept. eg. c(".csv", ".txt", ".jpg", ".pdf", ".doc").
#' The default is ".csv".
#' To accept all file types set it to `NULL`.
#' @return An object of class `shiny.tag`.
#' @export
file_input <- \(
  id,
  label = "Choose file & click upload:",
  accept = ".csv"
) {
  progress_id <- paste0(id, "_progress")
  progress_script <- sprintf("update_upload_progress('%s')", progress_id)
  accept <- if (is.character(accept)) paste(accept, collapse = ",") else NULL
  tags$div(
    class = "mb-3",
    tags$label(
      class = "form-label",
      `for` = id,
      label
    ),
    tags$input(
      class = "form-control rounded-bottom-0",
      type = "file",
      id = id,
      name = id,
      accept = accept
    ),
    progress_bar(id = progress_id),
    tags$script(progress_script)
  )
}
