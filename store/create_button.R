box::use(
  htmltools[tags]
)

#' Create button
#'
#' @param ... Passed to `tags$button()`.
#' @export
create_button <- \(...) tags$button(type = "button", ...)
