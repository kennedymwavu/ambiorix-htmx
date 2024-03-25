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
        create_movie_table(movie_collection = movie_collection),
        create_modal_trigger_btn(
          `hx-get` = "/movies/new_movie_form",
          `hx-target` = "#new_movie_form",
          `hx-swap` = "innerHTML",
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
      body = tags$div(id = "new_movie_form")
    ),
    create_modal(
      id = "edit_movie_modal",
      title = "Edit movie details",
      body = tags$div(id = "edit_movie_form")
    )
  )
}

#' New movie form
#'
#' @param name_value String. Movie name.
#' @param year_value Integer. Year of release.
#' @param rating_value Integer. Movie rating.
#' @param type String. Type of form. Either "add" (default) or "edit".
#' @return An object of class `shiny.tag`.
#' @export
new_movie_form <- \(
  name_value = "",
  year_value = as.integer(year(now()) - 10L),
  rating_value = 4L,
  type = "add"
) {
  add <- identical(type, "add")

  tags$form(
    `hx-target` = "#movie_table",
    `hx-swap` = "outerHTML",
    `hx-post` = if (add) "/movies/add_movie" else "/movies/edit_movie",
    `hx-vals` = if (add) NULL else sprintf('{"name": "%s"}', name_value),
    `hx-on::after-request` = "this.reset()",
    text_input(
      id = "movie_name",
      label = "Name",
      value = name_value,
      hx_post = if (add) "/movies/validate/name" else NULL
    ),
    select_input(
      id = "release_year",
      label = "Year",
      choices = 1888:year(now()),
      selected = year_value,
      hx_post = if (add) "/movies/validate/year" else NULL
    ),
    select_input(
      id = "rating",
      label = "Rating",
      choices = 5:1,
      selected = rating_value,
      hx_post = if (add) "/movies/validate/rating" else NULL
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
        `data-bs-dismiss` = "modal",
        tags$i(class = "bi bi-check-lg"),
        if (add) "Add movie" else "Save changes"
      )
    )
  )
}
