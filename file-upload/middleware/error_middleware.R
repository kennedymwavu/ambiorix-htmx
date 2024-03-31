#' Error handler middleware
#' 
#' @export i
error_handler <- \(req, res, error = NULL) {
  if (!is.null(error)) {
    msg <- conditionMessage(error)
    message(msg)
  }

  res$set_status(500L)$send("A server error occurred!")
}
