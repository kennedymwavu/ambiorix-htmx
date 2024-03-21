box::use(
  stringr[str_to_title]
)

#' Movie collection
#'
#' @export
movie_collection <- list(
  Title = str_to_title(
    c(
      "Back to the Future", "Who Framed Roger Rabbit",
      "Phantom of the Paradise", "Back to the Future 2"
    )
  ),
  Year = c(1985, 1988, 1974, 1989),
  Rating = c(5, 2, 4, 4)
)
