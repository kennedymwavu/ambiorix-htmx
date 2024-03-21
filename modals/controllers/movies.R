box::use(
  htmltools[tags],
  lubridate[year, now],
  stringr[str_to_title],
  ambiorix[parse_multipart],
  .. / store / movies[movies],
  .. / store / text_input[text_input],
  .. / store / select_input[select_input],
  .. / store / movie_collection[movie_collection],
  .. / helpers / operators[`%||%`],
  .. / templates / template_path[template_path]
)
#' Handle GET at '/movies'
#'
#' @export
home_get <- \(req, res) {
  res$render(
    template_path("page.html"),
    list(
      title = "Movies",
      content = movies()
    )
  )
}

#' Handle POST at '/movies/validate/name'
#'
#' @export
validate_name <- \(req, res) {
  body <- parse_multipart(req)
  movie_name <- (body$movie_name %||% "") |>
    trimws() |>
    str_to_title()

  msg <- "Looks good!"
  input_class <- "is-valid"
  feedback_class <- "valid-feedback"

  has_few_chars <- nchar(movie_name) <= 1
  movie_exists <- movie_name %in% movie_collection$Title

  if (has_few_chars || movie_exists) {
    if (has_few_chars) {
      msg <- "Name must be a string of more than one character."
    }

    if (movie_exists) {
      msg <- "Movie already exists!"
    }

    input_class <- "is-invalid"
    feedback_class <- "invalid-feedback"
  }

  html <- text_input(
    id = "movie_name",
    label = "Name",
    value = movie_name,
    hx_post = "/movies/validate/name",
    input_class = input_class,
    tags$div(
      class = feedback_class,
      msg
    )
  )

  res$send(html)
}

#' Handle POST at '/movies/validate/year'
#'
#' @export
validate_year <- \(req, res) {
  body <- parse_multipart(req)
  year <- as.integer(body$release_year %||% 0)

  valid_years <- 1888:year(now())
  is_valid <- year %in% valid_years

  msg <- "Looks good!"
  input_class <- "is-valid"
  feedback_class <- "valid-feedback"

  if (!is_valid) {
    msg <- "Invalid release year!"
    input_class <- "is-invalid"
    feedback_class <- "invalid-feedback"
  }

  html <- select_input(
    id = "release_year",
    label = "Year",
    choices = 1888:year(now()),
    selected = year,
    hx_post = "/movies/validate/year",
    input_class = input_class,
    tags$div(
      class = feedback_class,
      msg
    )
  )

  res$send(html)
}

#' Handle POST at '/movies/validate/rating'
#'
#' @export
validate_rating <- \(req, res) {
  res
}
