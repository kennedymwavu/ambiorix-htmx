box::use(
  htmltools[tags],
  uuid[UUIDgenerate],
  data.table[as.data.table, setcolorder]
)

#' Create table
#'
#' @param ... Additional tags appended before the end of the table container.
#' @param data An object of class data.frame, data.table or a named list, from
#' which to create the table.
#' @param id id of the table container div.
#' @param add_row_numbers Logical. Whether to add row numbers. Defaults
#' to `FALSE`.
#' @param wrap Logical. Should long text be wrapped? Defaults to `TRUE`.
#' @export
create_table <- \(
  ...,
  data,
  id,
  add_row_numbers = FALSE,
  wrap = TRUE
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
    style = if (!wrap) "white-space: nowrap;",
    lapply(
      X = seq_len(n),
      FUN = \(row_index) {
        tags$tr(
          id = paste(id, "row", UUIDgenerate(), sep = "-"),
          tbl[row_index, ]
        )
      }
    )
  )

  tags$div(
    class = "table-responsive",
    id = id,
    tags$table(
      class = "table table-hover",
      thead,
      tbody
    ),
    ...
  )
}
