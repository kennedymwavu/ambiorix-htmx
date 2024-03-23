box::use(
  mongolite[mongo]
)

#' Modals db connection
#'
#' @export
modals_conn <- mongo(
  collection = Sys.getenv("MODALS_COLLECTION"),
  db = Sys.getenv("MONGO_DB")
)
