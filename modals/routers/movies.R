box::use(
  ambiorix[Router],
  .. / controllers / movies[
    home_get,
    validate_name,
    validate_year,
    validate_rating
  ]
)

#' Movies router
#'
#' @export
router <- Router$
  new("/movies")$
  get("/", home_get)$
  post("/validate/name", validate_name)$
  post("/validate/year", validate_year)$
  post("/validate/rating", validate_rating)
