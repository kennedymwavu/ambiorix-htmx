box::use(
  glue[glue],
  htmltools[tags],
  lubridate[year, now],
  stringr[str_to_title],
  data.table[rbindlist],
  ambiorix[parse_multipart],
  .. / store / movies[
    movie_page = page,
    new_movie_form
  ],
  .. / store / toastr[
    toastr_info,
    toastr_warning,
    toastr_success,
    toastr_error
  ],
  .. / store / text_input[text_input],
  .. / store / select_input[select_input],
  .. / store / create_movie_table[create_movie_table],
  .. / helpers / operators[`%||%`],
  .. / models / movie_model[Movie],
  .. / templates / template_path[template_path]
)

#' Handle GET at '/movies'
#'
#' @export
home_get <- \(req, res) {
  movie_collection <- Movie$new()$read()
  res$render(
    template_path("page.html"),
    list(
      title = "Movies",
      content = movie_page(movie_collection)
    )
  )
}

#' Handle POST at '/movies/add_movie'
#'
#' @export
add_movie <- \(req, res) {
  body <- parse_multipart(req)
  movie_name <- check_movie_name(body$movie_name)
  release_year <- check_release_year(body$release_year)
  rating <- check_rating(body$rating)

  name <- movie_name$sanitized_value
  year <- release_year$sanitized_value
  rating <- rating$sanitized_value

  movies <- Movie$new()

  toast <- tryCatch(
    expr = {
      movies$add(name = name, year = year, rating = rating)
      toastr_success(msg = glue("'{name}' added."))
    },
    error = \(e) {
      msg <- conditionMessage(e)
      print(msg)
      toastr_error(msg = msg)
    }
  )

  html <- create_movie_table(
    movie_collection = movies$read(),
    toast
  )

  res$send(html)
}

#' Handle POST at '/movies/edit_movie'
#'
#' @export
edit_movie <- \(req, res) {
  body <- parse_multipart(req)

  # old movie name:
  name <- check_movie_name(body$name)$sanitized_value

  # updated values:
  movie_name <- check_movie_name(body$movie_name)$sanitized_value
  release_year <- check_release_year(body$release_year)$sanitized_value
  rating <- check_rating(body$rating)$sanitized_value

  movies <- Movie$new()

  toast <- tryCatch(
    expr = {
      movies$update(
        name = name,
        new_name = movie_name,
        new_year = release_year,
        new_rating = rating
      )
      toastr_success(msg = glue("'{name}' updated."))
    },
    error = \(e) {
      msg <- conditionMessage(e)
      print(msg)
      toastr_error(msg = msg)
    }
  )

  html <- create_movie_table(
    movie_collection = movies$read(),
    toast
  )

  res$send(html)
}

#' Handle DELETE at '/movies/delete_movie'
#'
#' @export
delete_movie <- \(req, res) {
  body <- parse_multipart(req)
  movie_name <- check_movie_name(body$movie_name)
  name <- movie_name$sanitized_value

  movies <- Movie$new()

  toast <- tryCatch(
    expr = {
      movies$delete(name = name)
      toastr_success(msg = glue("'{name}' deleted."))
    },
    error = \(e) {
      msg <- conditionMessage(e)
      print(msg)
      toastr_error(msg = msg)
    }
  )

  html <- create_movie_table(
    movie_collection = movies$read(),
    toast
  )

  res$send(html)
}

#' Handle GET at '/movies/new_movie_form'
#'
#' @export
get_new_movie_form <- \(req, res) {
  res$send(new_movie_form())
}

#' Handle POST at '/movies/edit_movie_form'
#'
#' @export
edit_movie_form <- \(req, res) {
  body <- parse_multipart(req)
  movie_name <- check_movie_name(body$movie_name)
  release_year <- check_release_year(body$movie_year)
  rating <- check_rating(body$movie_rating)

  name <- movie_name$sanitized_value
  year <- release_year$sanitized_value
  rating <- rating$sanitized_value

  html <- new_movie_form(
    name_value = name,
    year_value = year,
    rating_value = rating,
    type = "edit"
  )
  res$send(html)
}


#' Handle POST at '/movies/validate/name'
#'
#' @export
validate_name <- \(req, res) {
  body <- parse_multipart(req)
  movie_name <- body$movie_name

  validity <- check_movie_name(movie_name)

  res$send(validity$html)
}

#' Handle POST at '/movies/validate/year'
#'
#' @export
validate_year <- \(req, res) {
  body <- parse_multipart(req)
  year <- body$release_year

  validity <- check_release_year(year)

  res$send(validity$html)
}

#' Handle POST at '/movies/validate/rating'
#'
#' @export
validate_rating <- \(req, res) {
  body <- parse_multipart(req)
  rating <- body$rating

  validity <- check_rating(rating)

  res$send(validity$html)
}

#' Check if a rating value is valid
#'
#' @param rating Integer. The rating.
#' @param valid_ratings An integer vector. Valid ratings.
#' @return Named list with the following elements:
#' - `value`: The given rating.
#' - `sanitized_value`: The sanitized rating.
#' - `is_valid`: Whether the rating is valid.
#' - `msg`: Message.
#' - `input_class`: Input class.
#' - `feedback_class`: Feedback class.
#' - `html`: Validated HTML fragment.
#' @export
check_rating <- \(rating, valid_ratings = 1:5) {
  sanitized_rating <- as.integer(rating %||% 0)
  is_valid <- sanitized_rating %in% valid_ratings

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
    selected = sanitized_rating,
    hx_post = "/movies/validate/rating",
    input_class = input_class,
    tags$div(
      class = feedback_class,
      msg
    )
  )

  list(
    value = rating,
    sanitized_value = sanitized_rating,
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
#' - `value`: The given release year.
#' - `sanitized_value`: The sanitized release year.
#' - `is_valid`: Whether the given year is valid.
#' - `msg`: Message.
#' - `input_class`: Input class.
#' - `feedback_class`: Feedback class.
#' - `html`: Validated HTML fragment.
#' @export
check_release_year <- \(year, valid_years = 1888:year(now())) {
  sanitized_year <- as.integer(year %||% 0)
  is_valid <- sanitized_year %in% valid_years

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
    selected = sanitized_year,
    hx_post = "/movies/validate/year",
    input_class = input_class,
    tags$div(
      class = feedback_class,
      msg
    )
  )

  list(
    value = year,
    sanitized_value = sanitized_year,
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
#' - `value`: The given movie name.
#' - `sanitized_value`: Sanitized movie name.
#' - `is_valid`: Whether the given movie name is valid.
#' - `msg`: Message.
#' - `input_class`: Input class.
#' - `feedback_class`: Feedback class.
#' - `html`: Validated HTML fragment.
#' @export
check_movie_name <- \(name) {
  movie_name <- (name %||% "") |>
    trimws() |>
    str_to_title()

  msg <- "Looks good!"
  input_class <- "is-valid"
  feedback_class <- "valid-feedback"

  has_few_chars <- nchar(movie_name) <= 1
  movie_exists <- tryCatch(
    expr = Movie$new()$check_exists(name),
    error = \(e) {
      # if the expression above throws an error, it implies the movie exists:
      TRUE
    }
  )

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
    value = name,
    sanitized_value = movie_name,
    is_valid = is_valid,
    msg = msg,
    input_class = input_class,
    feedback_class = feedback_class,
    html = html
  )
}
