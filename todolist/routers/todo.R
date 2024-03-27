box::use(
  ambiorix[Router],
  .. / controllers / todo[
    home_get,
    add_todo
  ]
)

#' Todo router
#'
#' @export
router <- Router$
  new("/")$
  get("/", home_get)$
  post("/add_todo", add_todo)
