box::use(
  htmltools[tags, tagList],
  . / text_input[text_input],
  . / create_card[create_card],
  . / create_button[create_button]
)

#' The home page
#'
#' @return An object of class `shiny.tag`.
#' @export
page <- \() {
  tagList(
    tags$div(
      class = "container small-container",
      create_card(
        class = "my-3",
        title = "Chatroom",
        title_class = "text-center",
        chat_form()
      )
    )
  )
}

#' Create chat room form
#'
#' @export
chat_form <- \() {
  tags$div(
    `hx-ext` = "ws",
    `ws-connect` = "/hello",
    tags$div(id = "notifications"),
    tags$ul(id = "chat_room"),
    tags$form(
      `ws-send` = NA,
      `hx-target` = "#chat_room",
      `hx-swap` = "beforeend",
      `hx-on::ws-after-send` = "this.reset()",
      `hx-vals` = '{"name": "hello"}',
      tags$div(
        class = "input-group d-flex",
        text_input(
          id = "message",
          name = "message",
          class = "flex-grow-1",
          input_class = "rounded-end-0",
          aria_label = "Todo item"
        ),
        create_button(
          type = "submit",
          id = "sendmsg",
          class = "btn btn-success btn-sm",
          tags$i(
            class = "bi bi-plus-lg"
          )
        )
      )
    )
  )
}
