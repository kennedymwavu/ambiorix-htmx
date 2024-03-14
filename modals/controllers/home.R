box::use(
  .. / store / home[home],
  .. / templates / template_path[template_path]
)

#' Handle GET at '/'
#'
#' @export
home_get <- \(req, res) {
  res$render(
    template_path("page.html"),
    list(
      title = "Modal Types",
      content = home()
    )
  )
}
