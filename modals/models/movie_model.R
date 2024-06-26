box::use(
  glue[glue],
  R6[R6Class],
  lubridate[year, now],
  stringr[str_to_title],
  data.table[data.table, as.data.table, setnames],
  .. / config / db[modals_conn],
  .. / helpers / operators[`%||%`],
  .. / helpers / mongo_query[mongo_query]
)

#' Movie schema
#'
#' @examples
#' \dontrun{
#' # create a Movie instance:
#' movies <- Movie$new()
#'
#' # add x-men:
#' movies$add(name = "x-men", year = 2000L, rating = 5L)
#' # update the name:
#' movies$update(name = "x-men", new_name = "x-men (the last stand)")
#'
#' # delete lotr:
#' movies$delete(name = "lotr")
#' }
#' @export
Movie <- R6Class(
  classname = "Movie",
  public = list(
    #' Get/read all movies from the database
    #'
    #' @param rename Logical. Whether to rename the columns of the resulting
    #' data.frame in this format:
    #' name -> Title
    #' year -> Year
    #' rating -> Rating
    #' Defaults to `TRUE`.
    #' @return A data.table object with 3 columns. If `rename = TRUE`:
    #' - name
    #' - year
    #' - rating
    #' Otherwise, the column names are:
    #' - Title
    #' - Year
    #' - Rating
    read = \(rename = TRUE) {
      collection <- modals_conn$find() |> as.data.table()

      if (nrow(collection) == 0L) {
        name <- year <- rating <- character()
        collection <- data.table(name, year, rating)
      }

      if (rename) {
        setnames(
          x = collection,
          old = c("name", "year", "rating"),
          new = c("Title", "Year", "Rating")
        )
      }

      collection
    },
    #' Add movie to database
    #'
    #' @param name Movie name.
    #' @param year Year of release.
    #' @param rating Movie rating.
    #' @return self (invisibly)
    add = \(name, year, rating) {
      self$check_name(name)
      self$check_year(year)
      self$check_rating(rating)

      name <- str_to_title(name)
      self$check_exists(name)

      details <- data.frame(name, year, rating)
      modals_conn$insert(data = details)

      invisible(self)
    },

    #' Update movie details
    #'
    #' @param name Name of the movie to update.
    #' @param new_name New name of the movie.
    #' @param new_year New release year of the movie.
    #' @param new_rating New rating of the movie.
    #' @return self (invisibly)
    update = \(
      name,
      new_name = NULL,
      new_year = NULL,
      new_rating = NULL
    ) {
      self$check_name(name)
      name <- str_to_title(name)

      updates <- list()

      if (!is.null(new_name)) {
        new_name <- str_to_title(new_name)
        self$check_name(new_name)
        if (!identical(name, new_name)) {
          # check if 'new_name' already exists:
          self$check_exists(new_name)
        }
        updates$name <- new_name
      }

      if (!is.null(new_year)) {
        self$check_year(new_year)
        updates$year <- new_year
      }

      if (!is.null(new_rating)) {
        self$check_rating(new_rating)
        updates$rating <- new_rating
      }

      # if no updates to make, return self:
      if (identical(length(updates), 0L)) {
        return(invisible(self))
      }

      modals_conn$update(
        query = mongo_query(
          name = name
        ),
        update = mongo_query(
          "$set" = updates
        )
      )

      invisible(self)
    },

    #' Delete movie
    #'
    #' @param name Movie name to delete.
    #' @return self (invisibly)
    delete = \(name) {
      self$check_name(name)
      name <- str_to_title(name)

      modals_conn$remove(
        query = mongo_query(
          name = name
        )
      )

      invisible(self)
    },

    #' Does movie already exist in the database?
    #'
    #' @param name String. Movie name.
    #' @return Logical. `TRUE` if movie already exists, `FALSE` otherwise.
    movie_exists = \(name) {
      self$check_name(name)
      name <- str_to_title(name)

      n <- modals_conn$count(
        query = mongo_query(name = name)
      )

      n > 0L
    },

    #' Check if movie already exists in the database
    #'
    #' @param name Movie name.
    #' @return `FALSE` (invisibly) if movie does not exist.
    #' Throws an error otherwise.
    check_exists = \(name) {
      if (self$movie_exists(name)) {
        msg <- glue("The movie '{name}' already exists!")
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
      is_valid <- is.character(name) &&
        identical(length(name), 1L) &&
        nchar(name) > 1
      if (!is_valid) {
        msg <- "Movie name must be a string with at least 2 characters."
        stop(msg, call. = FALSE)
      }

      invalid_chars <- c("{", "}")
      has_invalid_chars <- any(
        invalid_chars %in% strsplit(name, split = "")[[1]]
      )
      if (has_invalid_chars) {
        msg <- "Invalid movie name!"
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
