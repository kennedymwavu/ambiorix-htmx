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
    #' @return A data.table object with 1 column:
    #' - item
    read = \() {
      todos <- todos_conn$find() |> as.data.table()

      if (nrow(todos) == 0L) {
        todos <- data.table(item = character())
      }

      todos
    },

    #' Add a todo to the database
    #'
    #' @param item String. The todo item.
    #' @return self (invisibly)
    add = \(item) {
      todos_conn$insert(data = data.table(item))
      invisible(self)
    },

    #' Update a todo item
    #'
    #' @param item String. The todo item to update.
    #' @param new_description String. The new description of the todo item.
    #' @return self (invisibly)
    update = \(item, new_description) {
      updates <- list(item = new_description)

      todos_conn$update(
        query = mongo_query(
          item = item
        ),
        update = mongo_query(
          "$set" = updates
        )
      )

      invisible(self)
    },

    #' Delete a todo item
    #'
    #' @param item String. The todo item to delete.
    #' @return self (invisibly)
    delete = \(item) {
      todos_conn$remove(
        query = mongo_query(
          item = item
        )
      )

      invisible(self)
    }
  )
)
