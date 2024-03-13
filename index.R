box::use(
  ambiorix[Ambiorix],
  . / controllers / home[home_get],
  . / middleware / error_middleware[error_handler]
)

Ambiorix$
  new(host = "127.0.0.1", port = 8000)$
  set_error(error_handler)$
  static("public", "static")$
  get("/", home_get)$
  start()
