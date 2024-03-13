box::use(
  htmltools[tags],
  data.table[as.data.table, setcolorder]
)

#' Create table
#'
#' @param data An object of class data.frame, data.table or a named list, from
#' which to create the table.
#' @param id Table id.
#' @param add_row_numbers Logical. Whether to add row numbers. Defaults
#' to `FALSE`.
#' @export
create_table <- \(
  data,
  id = NULL,
  add_row_numbers = FALSE
) {
  tbl <- as.data.table(data)

  if (add_row_numbers) {
    tbl[, "#" := seq_len(.N)]
    setcolorder(tbl, neworder = "#")
    tbl[
      ,
      "#" := lapply(
        .SD,
        \(column) {
          lapply(column, \(item) tags$th(scope = "row", item))
        }
      ),
      .SDcols = "#"
    ]
  }

  n <- nrow(tbl)
  nms <- names(tbl)

  thead <- tags$thead(
    tags$tr(
      lapply(nms, \(name) tags$th(scope = "col", name))
    )
  )

  non_id_cols <- nms[nms != "#"]
  tbl[
    ,
    c(non_id_cols) := lapply(
      X = .SD,
      FUN = \(column) {
        lapply(column, \(item) tags$td(item))
      }
    ),
    .SDcols = non_id_cols
  ]

  tbody <- tags$tbody(
    lapply(
      X = seq_len(n),
      FUN = \(row_index) {
        tags$tr(tbl[row_index, ])
      }
    )
  )

  tags$div(
    class = "table-responsive",
    tags$table(
      id = id,
      class = "table table-hover",
      thead,
      tbody
    )
  )
}
