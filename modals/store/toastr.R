box::use(
  htmltools[tags],
  .. / helpers / operators[`%||%`, `%!in%`]
)
#' Toastr
#'
#' @param type String. Type of the toast. Valid options are:
#' - info
#' - warning
#' - success
#' - error
#' @param title String. Title of the toast. Defaults to `NULL`.
#' @param msg String. Message to show in the toast. Defaults to `NULL`.
#' @return An object of class `shiny.tag`.
#' @export
toastr <- \(type, title = NULL, msg = NULL) {
  valid_types <- c("info", "warning", "success", "error")
  if (type %!in% valid_types) {
    e <- "'type' must be one of 'info', 'warning', 'success' or 'error'."
    stop(e, call. = FALSE)
  }

  title <- title %||% ""
  msg <- msg %||% ""

  tags$script(
    sprintf(
      'toastr["%s"]("%s", "%s");',
      type,
      msg,
      title
    )
  )
}

#' Info toastr
#'
#' @inheritParams toastr
#' @inherit toastr return
#' @export
toastr_info <- \(title = "Info", msg = NULL) {
  toastr(type = "info", title = title, msg = msg)
}

#' Warning toastr
#'
#' @inheritParams toastr
#' @inherit toastr return
#' @export
toastr_warning <- \(title = "Warning!", msg = NULL) {
  toastr(type = "warning", title = title, msg = msg)
}

#' Success toastr
#'
#' @inheritParams toastr
#' @inherit toastr return
#' @export
toastr_success <- \(title = "Success!", msg = NULL) {
  toastr(type = "success", title = title, msg = msg)
}

#' Error toastr
#'
#' @inheritParams toastr
#' @inherit toastr return
#' @export
toastr_error <- \(title = "Error!", msg = NULL) {
  toastr(type = "error", title = title, msg = msg)
}
