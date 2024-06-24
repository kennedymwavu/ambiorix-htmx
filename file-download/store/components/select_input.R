box::use(
  htmltools[tags],
  .. / .. / helpers / operators[`%||%`]
)

#' Select input
#'
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
#' @param hx_post `hx-post` attribute of the input.
#' @param hx_get `hx-get` attribute of the input. You can't have both `hx_get`
#' and `hx_post`. `hx_post` will take precedence.
#' @param hx_target `hx-target` attribute of the container div.
#' @param hx_trigger `hx-trigger` attribute of the input.
#' @param hx_swap `hx-swap` attribute of the container div.
#' @return [htmltools::tags()]
#' @export
select_input <- \(
  id = NULL,
  label = NULL,
  choices = NULL,
  selected = NULL,
  label_class = NULL,
  class = "mb-3",
  hx_post = NULL,
  hx_get = NULL,
  hx_target = NULL,
  hx_trigger = NULL,
  hx_swap = NULL
) {
  label_class <- c("form-label", label_class)
  hx_get <- if (is.null(hx_post)) hx_get

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
    `hx-get` = hx_get,
    `hx-post` = hx_post,
    `hx-trigger` = hx_trigger,
    select_options
  )

  label <- tags$label(
    `for` = id,
    class = label_class,
    label
  )

  tags$div(
    class = class,
    `hx-target` = hx_target,
    `hx-swap` = hx_swap,
    label,
    input
  )
}
