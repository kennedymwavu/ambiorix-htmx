box::use(
  htmltools[tags],
  . / create_button[create_button],
  . / create_rating_stars[create_rating_stars]
)

#' Movie collection
#'
#' @export
movie_collection <- list(
  Title = c(
    "Back to the Future", "Who Framed Roger Rabbit",
    "Phantom of the Paradise", "Back to the Future 2"
  ),
  Year = c(1985, 1988, 1974, 1989),
  Rating = lapply(
    X = c(5, 2, 4, 4),
    FUN = \(rating) create_rating_stars(rating = rating)
  ),
  Action = lapply(
    X = 1:4,
    FUN = \(index) {
      create_button(
        class = "btn btn-primary btn-sm",
        tags$i(class = "bi bi-pencil-square"),
        "Edit"
      )
    }
  )
)
