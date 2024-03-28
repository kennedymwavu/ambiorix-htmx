box::use(
  htmltools[tags],
  data.table[as.data.table]
)

#' Create a todo list group
#'
#' @param items Todo items. A data.table object with 1 column:
#' - item
#' @return An object of class `shiny.tag`.
#' @export
create_todo_list <- \(items) {
  list_items <- as.data.table(items)[
    ,
    item := create_list_item(item, `_id`, status)
  ]

  tags$ul(
    class = "list-group",
    list_items[, item]
  )
}

#' Create a list item
#'
#' Creates an `li` tag.
#'
#' @param item Character vector. The todo items.
#' @param id Character vector. The ids of the checkbox inputs.
#' @param status Logical vector. The status of the todo items.
#' @return A list of `tags$li()` objects.
#' @export
create_list_item <- \(item, id, status) {
  Map(
    f = \(the_item, the_id, the_status) {
      tags$li(
        class = "list-group-item",
        tags$input(
          type = "checkbox",
          class = "form-check-input me-1",
          value = "",
          id = the_id,
          name = "item_id",
          value = the_id,
          checked = if (the_status) NA else NULL,
          `hx-post` = "/check_todo",
          `hx-vals` = sprintf('{"item_id2": "%s"}', the_id)
        ),
        tags$label(
          class = paste(
            "form-check-label",
            if (the_status) "text-decoration-line-through"
          ),
          `for` = the_id,
          the_item
        )
      )
    },
    item,
    id,
    status
  )
}
