box::use(
  .. / store / movies[movies],
  .. / templates / template_path[template_path]
)
#' Handle GET at '/'
#'
#' @export
home_get <- \(req, res) {
  res$render(
    template_path("page.html"),
    list(
      title = "Movies",
      content = movies()
    )
  )
}
