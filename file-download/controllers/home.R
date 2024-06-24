box::use(
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
dataset_post <- \(req, res) {
  body <- parse_multipart(req)
  print(body)

  html <- card(
    id = "dataset",
    tags$p(
      "hello, world!",
      tags$span(
        class = "fw-lighter",
        format(Sys.time(), "%c")
      )
    )
  )

  res$send(html)
}
