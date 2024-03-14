box::use(
  htmltools[tags]
)

#' Create rating stars
#'
#' @param n Number of stars.
#' @param rating Rating to show.
#' @export
create_rating_stars <- \(n = 5, rating = 4) {
  lapply(
    X = seq_len(n),
    FUN = \(index) {
      tags$i(
        class = paste(
          "text-success",
          if (index <= rating) "bi bi-star-fill" else "bi bi-star"
        )
      )
    }
  )
}
