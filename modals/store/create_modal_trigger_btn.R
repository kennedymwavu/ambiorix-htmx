box::use(
  . / create_button[create_button]
)

#' Create modal trigger btn
#'
#' @param ... Passed to [create_button()].
#' @param modal_id Modal id.
#' @param class Classes to apply to the button.
#' Defaults to "btn btn-primary mb-2".
#' @export
create_modal_trigger_btn <- \(
  ...,
  modal_id,
  class = "btn btn-primary mb-2"
) {
  create_button(
    class = class,
    `data-bs-toggle` = "modal",
    `data-bs-target` = paste0("#", modal_id),
    ...
  )
}
