box::use(
  . / create_button[create_button]
)

#' Create modal trigger btn
#'
#' @param modal_id Modal id.
#' @param btn_label Button label.
#' @export
create_modal_trigger_btn <- \(modal_id, btn_label) {
  create_button(
    class = "btn btn-primary mb-2",
    `data-bs-toggle` = "modal",
    `data-bs-target` = paste0("#", modal_id),
    btn_label
  )
}
