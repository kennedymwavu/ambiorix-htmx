box::use(
  cli[cli_alert_danger],
  .. / helpers / operators[`%||%`]
)

#' Error handler
#'
#' @export
error_handler <- \(req, res, error = NULL) {
  if (!is.null(error)) {
    error_msg <- conditionMessage(error)
    cli_alert_danger("Error: {error_msg}")
  }
  res$
    set_status(500L)$
    send("A server error occurred!")
}
