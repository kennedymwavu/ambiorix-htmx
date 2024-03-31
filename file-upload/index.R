box::use(
  ambiorix[Ambiorix],
  . / controllers / file_upload[
    home_get,
    file_upload
  ],
  . / middleware / error_middleware[error_handler]
)

host <- Sys.getenv("HOST")
port <- as.integer(Sys.getenv("PORT"))

Ambiorix$
  new(host = host, port = port)$
  set_error(error_handler)$
  static("public", "static")$
  get("/", home_get)$
  post("/upload", file_upload)$
  start()
