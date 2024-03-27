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
    item := lapply(
      X = item,
      FUN = \(list_item) {
        tags$li(class = "list-group-item", list_item)
      }
    )
  ]

  tags$ol(
    class = "list-group list-group-numbered",
    list_items[, item]
  )
}
