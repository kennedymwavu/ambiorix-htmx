box::use(
  htmltools[tags],
  data.table[as.data.table],
  . / create_table[create_table],
  . / create_button[create_button],
  . / create_rating_stars[create_rating_stars]
)

#' Create movie table
#'
#' The movie table has these columns:
#' - `#` : Row numbers
#' - `Title` : Movie title
#' - `Year` : Year of release
#' - `Rating` : Movie rating
#' - `Action` : Edit buttons
#' @param movie_collection A named list, a data.frame or a data.table object
#' with 3 columns:
#' - `Title` : Character vector.
#' - `Year` : Integer vector.
#' - `Rating` : Numeric vector.
#' @return An object of class `shiny.tag`
#' @export
create_movie_table <- \(movie_collection) {
  dt <- as.data.table(movie_collection)
  dt[, Rating := create_rating_stars(num_of_filled_stars = Rating)]
  dt[
    ,
    Action := replicate(
      n = .N,
      expr = create_button(
        class = "btn btn-primary btn-sm",
        tags$i(class = "bi bi-pencil-square"),
        "Edit"
      ),
      simplify = FALSE
    )
  ]

  create_table(
    data = dt,
    id = "movie_table",
    add_row_numbers = TRUE,
    wrap = FALSE
  )
}
