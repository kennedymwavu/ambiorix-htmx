box::use(
  ambiorix[Ambiorix],
  . / controllers / home[home_get],
  . / routers / movies[movies_router = router],
  . / middleware / error_middleware[error_handler]
)

host <- Sys.getenv("HOST")
port <- as.integer(Sys.getenv("PORT"))

Ambiorix$
  new(host = host, port = port)$
  set_error(error_handler)$
  static("public", "static")$
  get("/", home_get)$
  use(movies_router)$
  start()
