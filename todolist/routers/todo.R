box::use(
  ambiorix[Router],
  .. / controllers / todo[
    home_get
  ]
)

#' Todo router
#'
#' @export
router <- Router$
  new("/")$
  get("/", home_get)
