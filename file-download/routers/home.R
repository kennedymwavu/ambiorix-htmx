box::use(
  ambiorix[Router],
  .. / controllers / home[home_get, dataset_post]
)

#' Router for "/"
#'
#' @export
router <- Router$
  new("/")$
  get("/", home_get)$
  post("/dataset", dataset_post)
