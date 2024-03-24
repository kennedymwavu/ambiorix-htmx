box::use(
  ambiorix[Router],
  .. / controllers / movies[
    home_get,
    add_movie,
    validate_name,
    validate_year,
    validate_rating,
    get_new_movie_form
  ]
)

#' Movies router
#'
#' @export
router <- Router$
  new("/movies")$
  get("/", home_get)$
  post("/add_movie", add_movie)$
  post("/validate/name", validate_name)$
  post("/validate/year", validate_year)$
  post("/validate/rating", validate_rating)$
  get("/new_movie_form", get_new_movie_form)
