box::use(
  htmltools[tags],
  ambiorix[parse_multipart],
  .. / models / todo[Todo],
  .. / store / todo[
    todo_page = page,
    todo_form
  ],
  .. / helpers / operators[`%||%`],
  .. / templates / template_path[template_path]
)

#' Handle GET at '/'
#'
#' @export
home_get <- \(req, res) {
  todos <- Todo$new()$read()

  res$render(
    template_path("page.html"),
    list(
      title = "Todo List",
      content = todo_page(items = todos)
    )
  )
}
