box::use(
  htmltools[tags],
  ambiorix[Ambiorix],
  jsonlite[fromJSON],
  . / helpers / get_env_vars[
    get_host,
    get_port
  ],
  . / controllers / home[home_get],
  . / middleware / error_middleware[error_handler]
)

#' A list of websocket connections.
#'
clients <- list()

#' Broadcast a message to websocket clients
#'
#' @param msg Message to broadcast.
#' @export
broadcast_message <- \(msg) {
  for (client in clients) {
    client$send(msg)
  }
}

#' Handle websocket messages named 'hello'
#'
#' @param msg List. Message received from the websocket.
#' @export
hello_ws <- \(msg) {
  date_time <- paste0(
    " [",
    format(Sys.time(), "%c"),
    "]"
  )

  response <- tags$div(
    `hx-swap-oob` = "beforeend:#chat_room",
    tags$li(
      msg$message,
      tags$span(
        class = "fw-lighter",
        date_time
      )
    )
  )

  broadcast_message(response)
}

#' Custom websockets handler
#'
#' @param ws The websocket.
#' See [docs](https://ambiorix.dev/docs/ambiorix/websocket#bypass-ambiorix).
#' @return `NULL`
#'
#'
#' @export
ws_handler <- \(ws) {
  # add new client:
  clients <<- append(x = clients, values = ws)

  # list websocket endpoints for our app. we'll listen for messages from them:
  ws_endpoints <- c("hello")

  # when a message is received:
  # 1. check if it's from a valid endpoint
  # 2. pass it to the appropriate handler
  ws$onMessage(\(binary, message) {
    msg <- fromJSON(message)
    name <- msg$name

    if (!name %in% ws_endpoints) {
      return()
    }

    switch(
      EXPR = name,
      hello = hello_ws(msg),
      NULL
    )
  })
}

app <- Ambiorix$
  new(host = get_host(), port = get_port())$
  set_error(error_handler)$
  static("public", "static")$
  get("/", home_get)

app$websocket <- ws_handler

app$start()
