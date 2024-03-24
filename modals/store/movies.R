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
  . / create_movie_table[create_movie_table],
  . / create_rating_stars[create_rating_stars],
  . / create_modal_trigger_btn[create_modal_trigger_btn]
)

#' The movies page
#'
#' @param movie_collection The movie collection. A data.table object with
#' 3 columns:
#' - Title
#' - Year
#' - Rating
#' @return An object of class `shiny.tag`
#' @export
page <- \(movie_collection) {
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
        create_movie_table(movie_collection),
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
      body = new_movie_form()
    )
  )
}

#' New movie form
#'
#' @export
new_movie_form <- \(
  name_value = "",
  year_value = 2000L,
  rating_value = 5L
) {
  tags$form(
    `hx-target` = "#movie_table",
    `hx-swap` = "outerHTML",
    `hx-post` = "/movies/add_movie",
    text_input(
      id = "movie_name",
      label = "Name",
      value = name_value,
      hx_post = "/movies/validate/name"
    ),
    select_input(
      id = "release_year",
      label = "Year",
      choices = 1888:year(now()),
      selected = year_value,
      hx_post = "/movies/validate/year"
    ),
    select_input(
      id = "rating",
      label = "Rating",
      choices = 5:1,
      selected = rating_value,
      hx_post = "/movies/validate/rating"
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
}
