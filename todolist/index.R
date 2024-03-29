box::use(
  ambiorix[Ambiorix],
  . / routers / todo[todo_router = router],
  . / middleware / error_middleware[error_handler]
)

host <- Sys.getenv("HOST")
port <- as.integer(Sys.getenv("PORT"))

Ambiorix$
  new(host = host, port = port)$
  set_error(error_handler)$
  static("public", "static")$
  use(todo_router)$
  start()
