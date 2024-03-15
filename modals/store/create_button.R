box::use(
  htmltools[tags]
)

#' Create button
#'
#' @param ... Passed to `tags$button()`.
#' @param class Classes to apply to the button.
#' @export
create_button <- \(..., class = NULL) {
  tags$button(
    type = "button",
    class = paste("rounded-1", class),
    ...
  )
}
