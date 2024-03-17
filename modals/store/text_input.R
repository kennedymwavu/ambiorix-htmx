box::use(
  htmltools[tags]
)

#' Text input
#'
#' @param value Value of the input.
#' @param ... Tags to append to end of div.
#' @param id Input id.
#' @param label Input label.
#' @param input_class Additional classes to apply to the input. Mostly
#' used for validation.
#' @param hx_post `hx-post` attribute of the input.
#' @return An object of class `shiny.tag`.
#' @export
text_input <- \(
  ...,
  id,
  label = NULL,
  value = "",
  input_class = NULL,
  hx_post = NULL
) {
  tags$div(
    class = "mb-3",
    `hx-target` = "this",
    `hx-swap` = "outerHTML",
    tags$label(
      `for` = id,
      class = "form-label",
      label
    ),
    tags$input(
      type = "text",
      name = id,
      id = id,
      class = paste("form-control", input_class),
      required = NA,
      value = value,
      `hx-post` = hx_post
    ),
    ...
  )
}
