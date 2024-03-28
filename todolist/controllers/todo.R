box::use(
  htmltools[tags],
  ambiorix[parse_multipart],
  .. / models / todo[Todo],
  .. / store / todo[
    todo_page = page,
    todo_form
  ],
  .. / store / text_input[text_input],
  .. / store / create_todo_list[create_todo_list],
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

#' Handle POST at '/add_todo'
#'
#' @export
add_todo <- \(req, res) {
  body <- parse_multipart(req)
  item <- body$name %||% ""

  todos <- Todo$new()

  is_valid <- !identical(item, "")
  if (is_valid) {
    todos$add(item)
  }

  html <- create_todo_list(todos$read())

  res$send(html)
}

#' Handle POST at '/check_todo'
#'
#' PS: In case you're curious as to why I use `getElement(x, name)` in
#' this handler, check this tweet:
#' https://x.com/kennedymwavu/status/1773134676149817505?s=20
#' @export
check_todo <- \(req, res) {
  body <- parse_multipart(req)
  item_id <- trimws(getElement(body, "item_id") %||% "")
  item_id2 <- trimws(getElement(body, "item_id2") %||% "")

  todos <- Todo$new()

  is_valid_id <- !identical(item_id, "")
  is_valid_id2 <- !identical(item_id2, "")

  # if 'item_id' is valid => checked
  if (is_valid_id) {
    todos$update(item_id = item_id, new_status = TRUE)
  }

  # if 'item_id' is invalid => unchecked
  if (!is_valid_id && is_valid_id2) {
    todos$update(item_id = item_id2, new_status = FALSE)
  }

  html <- create_todo_list(todos$read())

  res$send(html)
}
