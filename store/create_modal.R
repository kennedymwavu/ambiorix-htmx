box::use(
  stats[runif],
  htmltools[tags],
  uuid[UUIDgenerate],
  . / create_button[create_button]
)

#' Create a bootstrap 5 modal
#'
#' @param id Modal id.
#' @param title Modal title.
#' @param title_class Class of the modal title.
#' @param body Main content of the modal.
#' @param footer The modal's footer content.
#' @param easy_close Logical. Can the modal be dismissed by clicking outside of
#' it? Defaults to `TRUE`.
#' @param scrollable Logical. Should inner scrolling be enabled when content 
#' exceeds the predefined max-height of the modal? Defaults to `FALSE.`
#' @param vertically_centered Logical. Should the modal be vertically centered?
#' Defaults to `FALSE`.
#' @return An object of class `shiny.tag`.
#' @export
create_modal <- \(
  id,
  title = NULL,
  title_class = "fs-5",
  body = NULL,
  footer = NULL,
  easy_close = TRUE,
  scrollable = FALSE,
  vertically_centered = FALSE
) {
  aria_labelled_by <- paste(id, UUIDgenerate(), sep = "-")
  data_bs_backdrop <- if (!easy_close) "static"
  data_bs_keyboard <- if (!easy_close) "false"

  title <- if (!is.null(title)) {
    tags$h1(
      id = aria_labelled_by,
      class = paste("modal-title", title_class),
      title
    )
  }

  header <- tags$div(
    class = "modal-header",
    title,
    create_button(
      class = "btn-close",
      `data-bs-dismiss` = "modal",
      `aria-label` = "Close"
    )
  )

  body <- if (!is.null(body)) {
    tags$div(
      class = "modal-body",
      body
    )
  }

  footer <- if (!is.null(footer)) {
    tags$div(
      class = "modal-footer",
      footer
    )
  }

  modal <- tags$div(
    id = id,
    class = "modal fade",
    `data-bs-backdrop` = data_bs_backdrop,
    `data-bs-keyboard` = data_bs_keyboard,
    tabindex = "-1",
    `aria-labelledby` = aria_labelled_by,
    `aria-hidden` = "true",
    tags$div(
      class = paste(
        "modal-dialog",
        if (scrollable) "modal-dialog-scrollable",
        if (vertically_centered) "modal-dialog-centered"
      ),
      tags$div(
        class = "modal-content",
        header,
        body,
        footer
      )
    )
  )

  modal
}
