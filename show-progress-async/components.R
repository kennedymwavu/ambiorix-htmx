box::use(
  htmltools[tags, tagList],
)

#' Home page'
#'
#' @export
home_page <- \() {
  tags$div(
    tags$h3("Show progress bar when using async"),
    computation_div()
  )
}

#' Computation div'
#'
#' @param show_loading_spinner Logical. Should loading spinner
#' on button be visible? Defaults to `FALSE`.
#' @param loading_spinner_label String. Loading spinner label.
#' @param show_progress_bar Logical. Should progress bar be shown?
#' Defaults to `FALSE`.
#' @param ... Named arguments passed to [progress_bar()].
#' @export
computation_div <- \(
  show_loading_spinner = FALSE,
  loading_spinner_label = "Just a sec...",
  show_progress_bar = FALSE,
  ...
) {
  spinner <- tagList(
    tags$span(
      class = "spinner-border spinner-border-sm",
      `aria-hidden` = "true"
    ),
    tags$span(
      role = "status",
      loading_spinner_label
    )
  )

  btn_id <- "computation-btn"
  onclick <- sprintf(
    "add_loading_spinner('%s', '%s')",
    btn_id,
    loading_spinner_label
  )
  btn <- tags$button(
    id = btn_id,
    type = "button",
    class = "btn btn-primary mb-1",
    onclick = if (!show_loading_spinner) onclick,
    `hx-post` = if (!show_loading_spinner) "/compute",
    `hx-target` = "#computation-div",
    `hx-swap` = "outerHTML",
    if (show_loading_spinner) spinner else "Start computation"
  )

  pb <- if (show_progress_bar) progress_bar(...)

  tags$div(
    id = "computation-div",
    btn,
    pb
  )
}

#' Create a progress bar
#'
#' @param progress_id String. Record ID. Defaults to `NULL`.
#' @param progress_value Integer. Progress value. Must be between
#' 0 and 100. Default is 0.
#' @param is_striped Logical. Should the progress bar be striped?
#' Default is `TRUE`.
#' @return [htmltools::tags]
#' @export
progress_bar <- \(
  progress_id = NULL,
  progress_value = 0L,
  is_striped = TRUE
) {
  hx_get <- if (!is.null(progress_id)) paste0("/progress/", progress_id)
  class <- paste("progress-bar", if (is_striped) "progress-bar-striped progress-bar-animated")

  tags$div(
    class = "progress",
    role = "progressbar",
    `aria-label` = "Computation progress",
    `aria-valuenow` = progress_value,
    `aria-valuemin` = "0",
    `aria-valuemax` = "100",
    `hx-get` = hx_get,
    `hx-trigger` = "every 3s",
    `hx-target` = "#computation-div",
    `hx-swap` = "outerHTML",
    tags$div(
      id = "progress-bar",
      class = class,
      style = sprintf("width: %s%%", progress_value),
      paste0(progress_value, "%")
    )
  )
}
