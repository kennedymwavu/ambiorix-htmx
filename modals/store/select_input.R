box::use(
  htmltools[tags]
)

#' Select input
#'
#' @param ... Tags to append to end of div.
#' @param id Input id.
#' @param label Input label.
#' @param choices Input choices.
#' @param selected Default selected value of the input.
#' @param input_class Additional classes to apply to the input. Mostly
#' used for validation.
#' @param hx_post `hx-post` attribute of the input.
#' @return An object of class `shiny.tag`.
#' @export
select_input <- \(
  ...,
  id,
  label = NULL,
  choices,
  selected = "",
  input_class = NULL,
  hx_post = NULL
) {
  choices <- lapply(choices, \(choice) {
    tags$option(
      selected = if (identical(choice, selected)) NA else NULL,
      value = choice,
      choice
    )
  })

  tags$div(
    class = "mb-3",
    `hx-target` = "this",
    `hx-swap` = "outerHTML",
    tags$label(
      `for` = id,
      class = "form-label",
      label
    ),
    tags$select(
      name = id,
      id = id,
      class = paste("form-select", input_class),
      required = NA,
      `hx-post` = hx_post,
      choices
    ),
    ...
  )
}
