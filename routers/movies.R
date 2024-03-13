box::use(
  ambiorix[Router],
  .. / controllers / movies[home_get]
)

#' Movies router
#'
#' @export
router <- Router$
  new("/movies")$
  get("/", home_get)
