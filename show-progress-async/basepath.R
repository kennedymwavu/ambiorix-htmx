#' Create path to a file or folder
#'
#' Creates path to a file or folder starting from the
#' root dir of this project.
#'
#' @details It is safe to assume the root dir is marked by
#' the location of this file.
#' @param ... Passed to [file.path()].
#' @return String. Path.
#' @export
basepath <- \(...) {
  box::file(...)
}
