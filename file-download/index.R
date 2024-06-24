box::use(
  ambiorix[Ambiorix],
  . / middleware / error[error_handler],
  . / routers / home[home_router = router],
  . / helpers / get_env_vars[get_host, get_port],
)

Ambiorix$
  new(host = get_host(), port = get_port())$
  static("public", "static")$
  set_error(error_handler)$
  use(home_router)$
  start()
