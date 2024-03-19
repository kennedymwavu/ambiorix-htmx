box::use(
  datasets[iris],
  htmltools[tags, tagList],
  lubridate[year, now],
  . / text_input[text_input],
  . / select_input[select_input],
  . / create_nav[create_nav],
  . / create_card[create_card],
  . / create_modal[create_modal],
  . / create_table[create_table],
  . / create_button[create_button],
  . / create_rating_stars[create_rating_stars],
  . / create_modal_trigger_btn[create_modal_trigger_btn],
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
        title_icon = tags$i(class = "bi bi-camera-reels"),
        title_class = "text-primary",
        tags$p(
          "A sample project that shows how to support modal",
          "forms with ambiorix + htmx"
        ),
        create_table(
          data = movie_collection,
          id = "movie_table",
          add_row_numbers = TRUE,
          wrap = FALSE
        ),
        create_modal_trigger_btn(
          modal_id = "add_movie_modal",
          class = "btn btn-outline-primary my-3",
          tags$i(class = "bi bi-plus-lg"),
          "Add a movie"
        )
      )
    ),
    create_modal(
      id = "add_movie_modal",
      title = "Add a movie",
      body = tags$form(
        `hx-target` = "#movie_table",
        `hx-swap` = "outerHTML",
        `hx-post` = "/movies/add_movie",
        text_input(
          id = "movie_name",
          label = "Name",
          hx_post = "/movies/validation/name"
        ),
        select_input(
          id = "release_year",
          label = "Year",
          choices = 1888:year(now()),
          selected = 2000L,
          hx_post = "/movies/validation/year"
        ),
        select_input(
          id = "rating",
          label = "Rating",
          choices = 5:1,
          hx_post = "/movies/validation/rating"
        ),
        tags$div(
          class = "w-100 d-flex justify-content-between",
          create_button(
            class = "btn btn-danger btn-sm",
            `data-bs-dismiss` = "modal",
            tags$i(class = "bi bi-x-lg"),
            "Close"
          ),
          create_button(
            type = "submit",
            class = "btn btn-success btn-sm",
            tags$i(class = "bi bi-check-lg"),
            "Add movie"
          )
        )
      )
    )
  )
}
