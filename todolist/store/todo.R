box::use(
  htmltools[tags, tagList],
  . / text_input[text_input],
  . / create_card[create_card],
  . / create_button[create_button],
  . / create_todo_list[create_todo_list]
)

#' The todo page
#'
#' @param items The todo items. A data.table object with
#' these columns:
#' - _id
#' - item
#' - status
#' @return An object of class `shiny.tag`.
#' @export
page <- \(items) {
  tagList(
    tags$div(
      class = "container",
      create_card(
        class = "shadow-lg my-3",
        title = "Get Things Done!",
        title_icon = tags$i(class = "bi bi-journal-text"),
        title_class = "text-primary text-center",
        todo_form()
      ),
      create_card(
        class = "shadow-lg my-3",
        tags$div(
          id = "todo_items",
          `hx-target` = "this",
          `hx-swap` = "innerHTML",
          create_todo_list(items)
        )
      )
    )
  )
}

#' Create a todo form
#'
#' @param item_id String. Item id.
#' @param item_value String. Item description.
#' @param type String. Type of form. Either "add" (default) or "edit".
#' @return An object of class `shiny.tag`.
#' @export
todo_form <- \(item_id = NULL, item_value = "", type = "add") {
  add <- identical(type, "add")

  tags$form(
    `hx-target` = "#todo_items",
    `hx-swap` = "innerHTML",
    `hx-post` = if (add) "/add_todo" else paste0("/edit_todo/", item_id),
    `hx-on::after-request` = "this.reset()",
    tags$div(
      class = "input-group mb-3 d-flex",
      text_input(
        id = "name",
        class = "flex-grow-1",
        input_class = "rounded-end-0",
        value = item_value,
        aria_label = "Todo item"
      ),
      create_button(
        type = "submit",
        id = "add_btn",
        class = "btn btn-success btn-sm",
        tags$i(
          class = if (add) "bi bi-plus-lg" else "bi bi-check-lg"
        )
      )
    )
  )
}
