box::use(
  R6[R6Class],
  data.table[data.table, as.data.table, setnames],
  .. / config / db[todos_conn],
  .. / helpers / mongo_query[mongo_query]
)

#' Todo schema
#'
#' @export
Todo <- R6Class(
  classname = "Todo",
  public = list(
    #' Get/read all todos from the database
    #'
    #' @return A data.table object with 2 columns:
    #' - _id : The id of the todo item.
    #' - item : The todo item.
    read = \() {
      todos <- todos_conn$find(
        fields = mongo_query(
          `_id` = TRUE,
          item = TRUE,
          status = TRUE
        )
      ) |> as.data.table()

      if (nrow(todos) == 0L) {
        todos <- data.table(
          item = character(),
          `_id` = character(),
          status = logical()
        )
      }

      todos
    },

    #' Add a todo to the database
    #'
    #' @param item String. The todo item.
    #' @param status Logical. Status of the todo item.
    #' `FALSE` (default) indicates the todo item is still pending ie. not done.
    #' `TRUE` indicates that the todo item is done ie. completed.
    #' @return self (invisibly)
    add = \(item, status = FALSE) {
      todos_conn$insert(data = data.table(item, status))
      invisible(self)
    },

    #' Update a todo item
    #'
    #' @param item_id String. The id of the todo item to update.
    #' @param new_description String. The new description of the todo item.
    #' @param new_status Logical. The new status of the todo item.
    #' @return self (invisibly)
    update = \(item_id, new_description = NULL, new_status = NULL) {
      updates <- list()

      if (!is.null(new_description)) {
        updates$item <- new_description
      }

      if (!is.null(new_status)) {
        updates$status <- new_status
      }

      if (length(updates) > 0L) {
        todos_conn$update(
          query = mongo_query(
            "_id" = list("$oid" = item_id)
          ),
          update = mongo_query(
            "$set" = updates
          )
        )
      }

      invisible(self)
    },

    #' Toggle the status of a todo item
    #'
    #' @param item_id String. The id of the todo item.
    #' @return self (invisibly)
    toggle_status = \(item_id) {
      item <- todos_conn$find(
        query = mongo_query(
          "_id" = list("$oid" = item_id)
        ),
        fields = mongo_query(status = TRUE)
      )

      if (nrow(item) > 0L) {
        new_status <- !item$status
        self$update(item_id = item_id, new_status = new_status)
      }

      invisible(self)
    },

    #' Delete a todo item
    #'
    #' @param item_id String. The id of the todo item to delete.
    #' @return self (invisibly)
    delete = \(item_id) {
      todos_conn$remove(
        query = mongo_query(
          "_id" = list("$oid" = item_id)
        )
      )

      invisible(self)
    }
  )
)
