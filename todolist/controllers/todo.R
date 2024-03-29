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

#' Handle PUT at '/check_todo/:id'
#'
#' @export
check_todo <- \(req, res) {
  item_id <- req$params$id %||% ""
  is_valid <- !identical(item_id, "")

  todos <- Todo$new()

  if (is_valid) {
    todos$toggle_status(item_id)
  }

  html <- create_todo_list(todos$read())

  res$send(html)
}

#' Handle POST at '/edit_todo'
#'
#' @param req The request object.
#' @param res The response object.
#' @export
edit_todo <- \(req, res) {
  body <- parse_multipart(req)
  item_id <- body$item_id %||% ""
  item_value <- body$item_value %||% ""

  todos <- Todo$new()

  is_valid <- !identical(item_id, "") && !identical(item_value, "")
  if (is_valid) {
    todos$update(item_id = item_id, new_description = item_value)
  }

  html <- create_todo_list(todos$read())

  res$send(html)
}

#' Handle DELETE at '/delete_todo/:id'
#'
#' @param req The request object.
#' @param res The response object.
#' @export
delete_todo <- \(req, res) {
  item_id <- req$params$id %||% ""
  is_valid <- !identical(item_id, "")

  todos <- Todo$new()

  if (is_valid) {
    todos$delete(item_id)
  }

  html <- create_todo_list(todos$read())

  res$send(html)
}
