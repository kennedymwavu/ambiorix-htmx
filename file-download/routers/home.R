box::use(
  ambiorix[Router],
  .. / controllers / home[
    get_data,
    home_get,
    show_dataset,
    download_dataset,
  ]
)

#' Router for "/"
#'
#' @export
router <- Router$
  new("/")$
  get("/", home_get)$
  get("/data/:name", get_data)$
  get("/dataset", show_dataset)$
  get("/download/:name", download_dataset)
