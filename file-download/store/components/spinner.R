box::use(
  htmltools[tags]
)

#' Bootstrap spinner
#'
#' @param class Character vector. Spinner classes.
#' See [bootstrap docs](https://getbootstrap.com/docs/5.3/components/spinners/#about).
#' @export
spinner <- \(
  class = "text-primary"
) {
  class <- c("spinner-border", class)

  tags$div(
    class = "d-flex justify-content-center",
    tags$div(
      class = class,
      role = "status",
      tags$span(
        class = "visually-hidden",
        "Loading..."
      )
    )
  )
}
