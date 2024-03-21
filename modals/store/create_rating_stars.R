box::use(
  htmltools[tags]
)

#' Create rating stars
#'
#' @param total_stars Integer vector. Number of stars. Defaults to 5.
#' @param num_of_filled_stars Integer vector of same length as `total_stars`.
#' Rating to show. Defaults to 4.
#' @return List of same length as the `total_stars` vector.
#' @examples
#' create_rating_stars()
#' create_rating_stars(n = c(5, 10), rating = c(4, 8))
#' @export
create_rating_stars <- \(total_stars = 5, num_of_filled_stars = 4) {
  Map(
    f = \(n, rating) {
      lapply(
        X = seq_len(n),
        FUN = \(index) {
          fill <- index <= rating
          tags$i(
            class = paste(
              "text-success",
              if (fill) "bi bi-star-fill" else "bi bi-star"
            )
          )
        }
      )
    },
    total_stars,
    num_of_filled_stars
  )
}
