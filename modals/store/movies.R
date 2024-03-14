box::use(
  htmltools[tags, tagList],
  datasets[iris],
  . / create_nav[create_nav],
  . / create_card[create_card],
  . / create_modal[create_modal],
  . / create_table[create_table],
  . / create_button[create_button],
  . / movie_collection[movie_collection]
)

#' The movies page
#'
#' @return An object of class `shiny.tag`
#' @export
movies <- \() {
  tagList(
    create_nav(active = "Movies"),
    tags$div(
      class = "container",
      create_card(
        class = "shadow-sm mb-3",
        title = "My Movie Collection",
        title_icon = tags$i(class = "bi bi-caret-right-square"),
        title_class = "text-primary",
        tags$p(
          "A sample project that shows how to support modal",
          "forms with ambiorix + htmx"
        ),
        create_table(
          data = movie_collection,
          add_row_numbers = TRUE
        )
      )
    )
  )
}
