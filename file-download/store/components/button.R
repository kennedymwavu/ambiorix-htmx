box::use(
  htmltools[tags]
)

#' Button
#'
#' @param ... Tags or attributes to include in [htmltools::tags$button()].
#' @param id String. Button id.
#' @param type String. Type of the button. Default is "button".
#' See [mdn web docs](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button)
#' for possible values.
#' @param class Classes to apply to the button.
#' @return [htmltools::tags()]
#' @export
button <- \(
  ...,
  id = NULL,
  type = "button",
  class = NULL
) {
  tags$button(
    id = id,
    type = type,
    class = paste("btn", class),
    ...
  )
}
