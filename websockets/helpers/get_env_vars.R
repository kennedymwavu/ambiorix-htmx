#' Get host to run app on
#'
#' Checks for the env var `HOST` from `.Renviron`.
#' @param default String. Defaults to "127.0.0.1".
#' @return String.
#' @export
get_host <- \(default = "127.0.0.1") {
  host <- Sys.getenv("HOST")
  if (identical(host, "")) {
    return(default)
  }
  host
}

#' Get port to run app on
#'
#' Checks for the env var `PORT` from `.Renviron`.
#' @param default Integer. Defaults to 8000.
#' @return Integer.
#' @export
get_port <- \(default = 8000L) {
  port <- Sys.getenv("PORT")
  if (identical(port, "")) {
    return(default)
  }
  as.integer(port)
}
