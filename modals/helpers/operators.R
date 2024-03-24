#' Coalescing operator to specify a default value
#'
#' This operator is used to specify a default value for a variable if the
#' original value is \code{NULL}.
#'
#' @param x a variable to check for \code{NULL}
#' @param y the default value to return if \code{x} is \code{NULL}
#' @return the first non-\code{NULL} value
#' @name op-null-default
#' @examples
#' my_var <- NULL
#' default_value <- "hello"
#' result <- my_var %||% default_value
#' result # "hello"
#'
#' my_var <- "world"
#' default_value <- "hello"
#' result <- my_var %||% default_value
#' result # "world"
#'
#' @export
"%||%" <- \(x, y) {
  if (is.null(x)) y else x
}

#' Not-in operator
#'
#' This operator of the opposite of the `%in%` operator
#' @param x The vector to be checked for.
#' @param y The vector to check in.
#' @examples
#' "a" %!in% letters # FALSE, 'a' is in letters
#' "aa" %!in% letters # TRUE, 'aa' is NOT in letters
#' @return Logical.
#' @export
"%!in%" <- Negate(`%in%`)
