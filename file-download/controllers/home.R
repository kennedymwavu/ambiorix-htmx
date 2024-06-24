box::use(
  datasets,
  htmltools[tags],
  ambiorix[parse_multipart],
  .. / store / home[home_page],
  .. / store / components / card[card],
  .. / templates / template_path[template_path]
)

#' Handle GET at '/'
#'
#' @export
home_get <- \(req, res) {
  res$render(
    template_path("page.html"),
    list(
      title = "File Upload",
      content = home_page()
    )
  )
}

#' Handle GET at '/dataset'
#'
#' @export
show_dataset <- \(req, res) {
  dataset_name <- req$query$dataset_name

  html <- card(
    id = "dataset",
    `hx-swap` = "this", # for htmx transitions & animations
    tags$p(
      dataset_name,
      tags$span(
        class = "fw-lighter",
        format(Sys.time(), "%c")
      )
    ),
    tags$a(
      href = paste0("/download/", dataset_name),
      class = "btn btn-dark btn-sm rounded-1",
      tags$i(class = "bi bi-download"),
      "Download"
    )
  )

  res$send(html)
}

#' Handle GET at '/download/:name'
#'
#' @export
download_dataset <- \(req, res) {
  name <- req$params$name
  dataset <- get(x = name, envir = asNamespace(ns = "datasets"))

  res$csv(dataset, name)
}
