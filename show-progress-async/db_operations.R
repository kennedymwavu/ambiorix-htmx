box::use(
  DBI[
    dbBind,
    dbFetch,
    dbConnect,
    dbExecute,
    dbSendQuery,
    dbDisconnect,
    dbWriteTable,
    dbClearResult,
  ],
  RSQLite[SQLite],
  uuid[UUIDgenerate],
  . / basepath[basepath],
)

#' Initialize a temp sqlite db on the root dir of
#' this project when app starts
#'
#' @export
make_conn <- \() {
  dbConnect(
    SQLite(),
    basepath("cache.sqlite")
  )
}

#' Delete the db
#'
#' @export
delete_cache_db <- \() {
  unlink(x = basepath("cache.sqlite"))
}

#' Create new progress record
#'
#' @param conn The database connection object.
#' @return data.frame with these columns:
#' - progress_id
#' - value
#' @export
create_progress_record <- \(conn) {
  progress_id <- UUIDgenerate(n = 1L)
  db_record <- data.frame(
    progress_id = progress_id,
    progress_value = 0
  )

  dbWriteTable(
    conn = conn,
    name = "progress",
    value = db_record,
    overwrite = FALSE,
    append = TRUE
  )

  read_progress_record(conn = conn, progress_id = progress_id)
}

#' Read progress record
#'
#' @param conn The database connection object.
#' @param progress_id String. ID of the progress record.
#' @return data.frame
#' @export
read_progress_record <- \(conn, progress_id) {
  query <- "SELECT * FROM progress WHERE progress_id = ?"
  params <- list(progress_id)
  res <- dbSendQuery(conn = conn, statement = query)
  dbBind(res, params = params)
  found <- dbFetch(res)
  dbClearResult(res)

  found
}

#' Update progress value
#'
#' @param conn The db connection object.
#' @param progress_id String. ID of the progress record.
#' @param progress_value Integer. Value of the progress.
#' @export
update_progress_record <- \(conn, progress_id, progress_value) {
  query <- "UPDATE progress SET progress_value = ? WHERE progress_id = ?"
  params <- list(
    progress_value,
    progress_id
  )
  dbExecute(conn = conn, statement = query, params = params)
}

#' Delete record
#'
#' @param conn The db connection object.
#' @param progress_id String. ID of the progress record.
#' @export
delete_progress_record <- \(conn, progress_id) {
  query <- "DELETE FROM progress WHERE progress_id = ?"
  params <- list(progress_id)
  dbExecute(conn = conn, statement = query, params = params)
}
