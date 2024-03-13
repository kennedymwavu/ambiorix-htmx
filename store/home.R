box::use(
  htmltools[tags, tagList],
  . / create_nav[create_nav],
  . / create_card[create_card],
  . / create_button[create_button],
  . / create_modal[create_modal]
)

#' Create modal trigger btn
#'
#' @param modal_id Modal id.
#' @param btn_label Button label.
#' @export
create_modal_trigger_btn <- \(modal_id, btn_label) {
  create_button(
    class = "btn btn-primary mb-2",
    `data-bs-toggle` = "modal",
    `data-bs-target` = paste0("#", modal_id),
    btn_label
  )
}

#' The home page
#'
#' @return An object of class `shiny.tag`
#' @export
home <- \() {
  hello <- create_card(
    class = "shadow-sm mb-3",
    title = "Hello, Modals!",
    title_icon = tags$i(class = "bi bi-fullscreen"),
    title_class = "text-primary",
    tags$p("Let's first explore different 'types' of modals."),
    tags$p("Toggle them below:")
  )

  modal_ids <- c(
    "example_modal", "static_backdrop_modal", "outer_scrollable_modal",
    "inner_scrollable_modal", "vertically_centered_modal",
    "extra_large_modal", "large_modal", "small_modal"
  )
  btn_labels <- paste(
    "Launch",
    c(
      "demo modal", "static backdrop modal", "outer-scrollable modal",
      "inner-scrollable modal", "vertically centered modal",
      "extra large modal", "large modal", "small modal"
    )
  )

  trigger_btns <- create_card(
    class = "shadow-sm mb-3",
    Map(f = create_modal_trigger_btn, modal_ids, btn_labels)
  )

  example_modal <- create_modal(
    id = "example_modal",
    title = "Modal Title",
    body = tags$p("Woohoo, you're reading this text in a modal!"),
    footer = tags$div(
      create_button(
        class = "btn btn-secondary",
        `data-bs-dismiss` = "modal",
        "Close"
      ),
      create_button(
        class = "btn btn-primary",
        "Save Changes"
      )
    )
  )

  static_backdrop_modal <- create_modal(
    id = "static_backdrop_modal",
    easy_close = FALSE,
    title = "Static Backdrop Modal",
    body = tagList(
      tags$p("I will not close if you click outside of me."),
      tags$p("Don't even try to press escape key!")
    ),
    footer = tags$div(
      create_button(
        class = "btn btn-secondary",
        `data-bs-dismiss` = "modal",
        "Close"
      ),
      create_button(
        class = "btn btn-primary",
        "Understood"
      )
    )
  )

  inner_scrollable_modal <- create_modal(
    id = "inner_scrollable_modal",
    title = "Modal With Inner Scrolling",
    scrollable = TRUE,
    body = tagList(
      tags$p(
        paste(
          "This is some placeholder content to show the scrolling",
          "behaviour for modals. We used repeated line breaks to",
          "demonstrate how content can exceed minimum inner height,",
          "thereby showing inner scrolling. When content becomes longer",
          "than the predefined max-height of modal, content will be",
          "cropped and scrollable within the modal."
        )
      ),
      lapply(1:100, \(i) tags$br()),
      tags$p(
        "This content should appear at the bottom after you scroll."
      )
    ),
    footer = tags$div(
      create_button(
        class = "btn btn-secondary",
        `data-bs-dismiss` = "modal",
        "Close"
      ),
      create_button(
        class = "btn btn-primary",
        "Save changes"
      )
    )
  )

  outer_scrollable_modal <- create_modal(
    id = "outer_scrollable_modal",
    title = "Modal With Outer Scrolling",
    body = tagList(
      tags$p(
        paste(
          "This is some placeholder content to show the scrolling",
          "behaviour for modals. We used repeated line breaks to",
          "demonstrate how content can exceed minimum inner height,",
          "thereby showing inner scrolling. When content becomes longer",
          "than the height of the viewport, scrolling will move the",
          "modal as needed."
        )
      ),
      lapply(1:100, \(i) tags$br()),
      tags$p(
        "This content should appear at the bottom after you scroll."
      )
    ),
    footer = tags$div(
      create_button(
        class = "btn btn-secondary",
        `data-bs-dismiss` = "modal",
        "Close"
      ),
      create_button(
        class = "btn btn-primary",
        "Save changes"
      )
    )
  )

  vertically_centered_modal <- create_modal(
    id = "vertically_centered_modal",
    vertically_centered = TRUE,
    title = "Vertically Centered Modal",
    body = tags$p("This is a vertically centered modal."),
    footer = tags$div(
      create_button(
        class = "btn btn-secondary",
        `data-bs-dismiss` = "modal",
        "Close"
      ),
      create_button(
        class = "btn btn-primary",
        "Save Changes"
      )
    )
  )

  extra_large_modal <- create_modal(
    id = "extra_large_modal",
    title = "Extra Large Modal",
    size = "xl",
    body = tags$p("Geez, this is an extra large modal!"),
    footer = tags$div(
      create_button(
        class = "btn btn-secondary",
        `data-bs-dismiss` = "modal",
        "Close"
      ),
      create_button(
        class = "btn btn-primary",
        "Save Changes"
      )
    )
  )

  large_modal <- create_modal(
    id = "large_modal",
    title = "Large Modal",
    size = "lg",
    body = tags$p("This is a large modal."),
    footer = tags$div(
      create_button(
        class = "btn btn-secondary",
        `data-bs-dismiss` = "modal",
        "Close"
      ),
      create_button(
        class = "btn btn-primary",
        "Save Changes"
      )
    )
  )

  small_modal <- create_modal(
    id = "small_modal",
    title = "Small Modal",
    size = "sm",
    body = tags$p("I am smol modoo."),
    footer = tags$div(
      create_button(
        class = "btn btn-secondary",
        `data-bs-dismiss` = "modal",
        "Close"
      ),
      create_button(
        class = "btn btn-primary",
        "Save Changes"
      )
    )
  )

  tagList(
    create_nav(),
    tags$div(
      class = "container",
      hello,
      trigger_btns
    ),
    example_modal,
    static_backdrop_modal,
    inner_scrollable_modal,
    outer_scrollable_modal,
    vertically_centered_modal,
    extra_large_modal,
    large_modal,
    small_modal
  )
}
