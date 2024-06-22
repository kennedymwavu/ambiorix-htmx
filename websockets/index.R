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
ws_clients <- list()

#' Add a new websocket client
#'
#' @param ws A websocket connection.
#' @export
add_ws_client <- \(ws) {
  ws_clients <<- append(x = ws_clients, values = ws)
}

#' Remove a websocket client
#'
#' @param ws A websocket connection.
#' @export
remove_ws_client <- \(ws) {
  ws_clients <<- Filter(
    f = \(client) {
      !identical(client, ws)
    },
    x = ws_clients
  )
}

#' Broadcast a message to websocket clients
#'
#' @param msg Message to broadcast.
#' @export
broadcast_message <- \(msg) {
  for (client in ws_clients) {
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
  add_ws_client(ws)

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

  # on close, remove the client:
  ws$onClose(\() {
    remove_ws_client(ws)
  })
}

app <- Ambiorix$
  new(host = get_host(), port = get_port())$
  set_error(error_handler)$
  static("public", "static")$
  get("/", home_get)

app$websocket <- ws_handler

app$start()
