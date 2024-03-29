box::use(
  ambiorix[Router],
  .. / controllers / todo[
    home_get,
    add_todo,
    check_todo,
    edit_todo,
    delete_todo
  ]
)

#' Todo router
#'
#' @export
router <- Router$
  new("/")$
  get("/", home_get)$
  post("/add_todo", add_todo)$
  post("/edit_todo", edit_todo)$
  put("/check_todo/:id", check_todo)$
  delete("/delete_todo/:id", delete_todo)
