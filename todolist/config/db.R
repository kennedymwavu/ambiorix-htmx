box::use(
  mongolite[mongo]
)

#' Todo db connection
#'
#' @export
todos_conn <- mongo(
  collection = Sys.getenv("TODO_COLLECTION"),
  db = Sys.getenv("MONGO_DB")
)
