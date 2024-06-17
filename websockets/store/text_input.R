box::use(
  htmltools[tags],
  .. / helpers / operators[`%||%`]
)

#' Text input
#'
#' @param value Value of the input.
#' @param ... Tags to append to end of div.
#' @param id Input id.
#' @param class Classes to apply to the container div.
#' @param label Input label.
#' @param input_class Additional classes to apply to the input. Mostly
#' used for validation.
#' @param hx_post `hx-post` attribute of the input.
#' @param aria_label `aria-label` attribute of the input.
#' @param aria_described_by `aria-described-by` attribute of the input.
#' @return An object of class `shiny.tag`.
#' @export
text_input <- \(
  ...,
  id,
  class = "mb-3",
  label = NULL,
  value = "",
  input_class = NULL,
  hx_post = NULL,
  aria_label = NULL,
  aria_described_by = NULL
) {
  tags$div(
    class = class,
    `hx-target` = "this",
    `hx-swap` = "outerHTML",
    if (!is.null(label)) {
      tags$label(
        `for` = id,
        class = "form-label",
        label
      )
    },
    tags$input(
      type = "text",
      name = id,
      id = id,
      class = paste("form-control", input_class),
      required = NA,
      value = value,
      `hx-post` = hx_post,
      `aria-label` = aria_label %||% NULL,
      `aria-describedby` = aria_described_by %||% NULL
    ),
    ...
  )
}
