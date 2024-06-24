box::use(
  htmltools[tags],
  .. / .. / helpers / operators[`%||%`]
)

#' Select input
#'
#' @param ... Tags or attributes to add to [htmltools::tags$select()].
#' @param id String. Input id.
#' @param label Label.
#' @param label_class Character vector. Classes to apply to the label.
#' @param choices List or character vector. The select input choices. If the
#' named:
#' - names are used as the choices that the user sees
#' - values are the ones sent back to the server when a choice is picked
#' @param selected String (preferably). The default selected choice.
#' @param class Character vector. Classes to apply to the container div.
#' Defaults to "mb-3".
#' @return [htmltools::tags()]
#' @export
select_input <- \(
  ...,
  id = NULL,
  label = NULL,
  choices = NULL,
  selected = NULL,
  label_class = NULL,
  class = "mb-3"
) {
  label_class <- c("form-label", label_class)

  select_options <- Map(
    f = \(value, name) {
      tags$option(
        value = value,
        selected = if (identical(value, selected)) NA,
        name
      )
    },
    choices,
    names(choices) %||% choices
  )

  input <- tags$select(
    id = id,
    name = id,
    class = "form-select",
    `aria-label` = label,
    required = NA,
    ...,
    select_options
  )

  label <- tags$label(
    `for` = id,
    class = label_class,
    label
  )

  tags$div(
    class = class,
    label,
    input
  )
}
