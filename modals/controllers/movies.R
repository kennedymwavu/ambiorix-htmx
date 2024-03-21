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
  movie_name <- body$movie_name %||% ""

  validity <- check_movie_name(movie_name)

  res$send(validity$html)
}

#' Handle POST at '/movies/validate/year'
#'
#' @export
validate_year <- \(req, res) {
  body <- parse_multipart(req)
  year <- as.integer(body$release_year %||% 0)

  validity <- check_release_year(year)

  res$send(validity$html)
}

#' Handle POST at '/movies/validate/rating'
#'
#' @export
validate_rating <- \(req, res) {
  body <- parse_multipart(req)
  rating <- as.integer(body$rating %||% 0)

  validity <- check_rating(rating)

  res$send(validity$html)
}

#' Check if a rating value is valid
#'
#' @param rating Integer. The rating.
#' @param valid_ratings An integer vector. Valid ratings.
#' @return Named list with the following elements:
#' - `is_valid`: Whether the rating is valid.
#' - `msg`: Message.
#' - `input_class`: Input class.
#' - `feedback_class`: Feedback class.
#' - `html`: Validated HTML fragment.
#' @export
check_rating <- \(rating, valid_ratings = 1:5) {
  is_valid <- rating %in% valid_ratings

  msg <- "Looks good!"
  input_class <- "is-valid"
  feedback_class <- "valid-feedback"

  if (!is_valid) {
    msg <- "Invalid rating!"
    input_class <- "is-invalid"
    feedback_class <- "invalid-feedback"
  }

  html <- select_input(
    id = "rating",
    label = "Rating",
    choices = 5:1,
    selected = rating,
    hx_post = "/movies/validate/rating",
    input_class = input_class,
    tags$div(
      class = feedback_class,
      msg
    )
  )

  list(
    is_valid = is_valid,
    msg = msg,
    input_class = input_class,
    feedback_class = feedback_class,
    html = html
  )
}

#' Check if release year value is valid
#'
#' @param year Integer. The release year.
#' @param valid_years An integer vector. Valid years.
#' @return Named list with the following elements:
#' - `is_valid`: Whether the given year is valid.
#' - `msg`: Message.
#' - `input_class`: Input class.
#' - `feedback_class`: Feedback class.
#' - `html`: Validated HTML fragment.
#' @export
check_release_year <- \(year, valid_years = 1888:year(now())) {
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

  list(
    is_valid = is_valid,
    msg = msg,
    input_class = input_class,
    feedback_class = feedback_class,
    html = html
  )
}

#' Check if movie name is valid
#'
#' @param name String. The movie name.
#' @return Named list with the following elements:
#' - `is_valid`: Whether the given movie name is valid.
#' - `msg`: Message.
#' - `input_class`: Input class.
#' - `feedback_class`: Feedback class.
#' - `html`: Validated HTML fragment.
#' @export
check_movie_name <- \(name) {
  movie_name <- name |>
    trimws() |>
    str_to_title()

  msg <- "Looks good!"
  input_class <- "is-valid"
  feedback_class <- "valid-feedback"

  has_few_chars <- nchar(movie_name) <= 1
  movie_exists <- movie_name %in% movie_collection$Title

  is_invalid <- has_few_chars || movie_exists
  is_valid <- !is_invalid

  if (is_invalid) {
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
    value = name,
    hx_post = "/movies/validate/name",
    input_class = input_class,
    tags$div(
      class = feedback_class,
      msg
    )
  )

  list(
    is_valid = is_valid,
    msg = msg,
    input_class = input_class,
    feedback_class = feedback_class,
    html = html
  )
}
