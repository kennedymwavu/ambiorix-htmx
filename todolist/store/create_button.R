box::use(
  htmltools[tags]
)

#' Create button
#'
#' @param ... Passed to `tags$button()`.
#' @param class Classes to apply to the button.
#' @param type Type of the button. Either "button" (default) or "submit".
#' @export
create_button <- \(..., class = NULL, type = "button") {
  tags$button(
    type = type,
    class = paste("rounded-1", class),
    ...
  )
}
