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
#' @param ... Passed to [create_table()]
#' @param movie_collection A named list, a data.frame or a data.table object
#' with 3 columns:
#' - `Title` : Character vector.
#' - `Year` : Integer vector.
#' - `Rating` : Numeric vector.
#' @return An object of class `shiny.tag`
#' @export
create_movie_table <- \(..., movie_collection) {
  dt <- as.data.table(movie_collection)
  dt[, Rating := create_rating_stars(num_of_filled_stars = Rating)]
  dt[, Action := create_movie_table_buttons(Title)]

  create_table(
    ...,
    data = dt,
    id = "movie_table",
    add_row_numbers = TRUE,
    wrap = FALSE
  )
}

#' Create table buttons (edit & delete)
#'
#' @param name Character vector. Movie name/title.
#' @examples
#' movie_names <- c("LOTR", "Blacklist", "Avatar")
#' create_movie_table_buttons(movie_names)
#' @return A list containing objects of class `shiny.tag`.
#' @export
create_movie_table_buttons <- \(name) {
  lapply(
    X = name,
    FUN = \(movie_name) {
      hx_vals <- sprintf('{"movie_name": "%s"}', movie_name)

      tags$div(
        create_button(
          class = "btn btn-outline-primary btn-sm",
          `hx-post` = "/movies/edit_movie",
          `hx-vals` = hx_vals,
          tags$i(class = "bi bi-pencil-square"),
          "Edit"
        ),
        create_button(
          class = "btn btn-outline-danger btn-sm",
          `hx-delete` = "/movies/delete_movie",
          `hx-target` = "#movie_table",
          `hx-vals` = hx_vals,
          `hx-swap` = "outerHTML",
          tags$i(class = "bi bi-trash"),
          "Delete"
        )
      )
    }
  )
}
