box::use(
  glue[glue],
  R6[R6Class],
  lubridate[year, now],
  stringr[str_to_title],
  .. / config / db[modals_conn],
  .. / helpers / operators[`%||%`],
  .. / helpers / mongo_query[mongo_query]
)

#' Movie schema
#'
#' @examples
#' xmen <- Movie$new(name = "X-men", year = 2000L, rating = 5L)
#'
#' xmen$add()
#'
#' xmen$update(
#'   new_name = "X-men (new mutants)",
#'   new_year = 2018L,
#'   new_rating = 4L
#' )
#'
#' lotr <- Movie$new(name = "LOTR", year = 2003L, rating = 5L)
#'
#' lotr$add()
#'
#' lotr$delete()
#'
#' lotr$check_exists() # should return FALSE (invisibly)
#'
#' @export
Movie <- R6Class(
  classname = "Movie",
  public = list(
    name = NULL,
    year = NULL,
    rating = NULL,

    #' Init method
    #'
    #' @param name Movie name.
    #' @param year Release year.
    #' @param rating Movie rating.
    initialize = \(name, year, rating) {
      self$check_name(name)
      self$check_year(year)
      self$check_rating(rating)

      self$name <- str_to_title(name)
      self$year <- year
      self$rating <- rating
    },

    #' Add movie to database
    #'
    #' @return self (invisibly)
    add = \() {
      details <- data.frame(
        name = self$name,
        year = self$year,
        rating = self$rating
      )

      self$check_exists()
      modals_conn$insert(data = details)
      invisible(self)
    },

    #' Update movie details
    #'
    #' @param new_name New name of the movie.
    #' @param new_year New release year of the movie.
    #' @param new_rating New rating of the movie.
    #' @return self (invisibly)
    update = \(new_name = NULL, new_year = NULL, new_rating = NULL) {
      new_name <- new_name %||% self$name
      new_year <- new_year %||% self$year
      new_rating <- new_rating %||% self$rating

      self$check_name(new_name)
      self$check_year(new_year)
      self$check_rating(new_rating)

      modals_conn$update(
        query = mongo_query(
          name = self$name
        ),
        update = mongo_query(
          "$set" = list(
            name = new_name,
            year = new_year,
            rating = new_rating
          )
        )
      )

      self$name <- new_name
      self$year <- new_year
      self$rating <- new_rating

      invisible(self)
    },

    #' Delete movie
    #'
    #' @return self (invisibly)
    delete = \() {
      modals_conn$remove(
        query = mongo_query(
          name = self$name
        )
      )

      invisible(self)
    },

    #' Check if movie already exists in the database
    #'
    #' @return `FALSE` (invisibly) if movie does not exist.
    #' Throws an error otherwise.
    check_exists = \() {
      n <- modals_conn$count(
        query = mongo_query(name = self$name)
      )
      movie_exists <- n > 0

      if (movie_exists) {
        msg <- glue("The movie '{self$name}' already exists!")
        stop(msg, call. = FALSE)
      }
      invisible(FALSE)
    },

    #' Check name value requirements
    #'
    #' @param name Movie name
    #' @return `TRUE` (invisibly) if all checks pass.
    #' Otherwise, an error is thrown.
    check_name = \(name) {
      is_valid <- is.character(name) && identical(length(name), 1L)
      if (!is_valid) {
        msg <- "Movie name must be a length 1 character vector."
        stop(msg, call. = FALSE)
      }
      invisible(TRUE)
    },

    #' Check release year value requirements
    #'
    #' @param year Release year
    #' @return `TRUE` (invisibly) if all checks pass.
    #' Otherwise, an error is thrown.
    check_year = \(year) {
      this_year <- year(now())
      valid_years <- 1888:this_year
      is_valid <- is.integer(year) && year %in% valid_years
      if (!is_valid) {
        msg <- glue(
          "Release year must be an integer between 1888 and ",
          "{this_year} (inclusive)."
        )
        stop(msg, call. = FALSE)
      }
      invisible(TRUE)
    },

    #' Check rating value requirements
    #'
    #' @param rating Rating
    #' @return `TRUE` (invisibly) if all checks pass.
    #' Otherwise, an error is thrown.
    check_rating = \(rating) {
      valid_ratings <- 1:5
      is_valid <- is.integer(rating) && rating %in% valid_ratings
      if (!is_valid) {
        msg <- "Rating must be an integer between 1 and 5 (inclusive)."
        stop(msg, call. = FALSE)
      }
      invisible(TRUE)
    }
  )
)
