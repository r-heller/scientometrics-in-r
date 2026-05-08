#' Scientometrics in R colour palette
#'
#' @param n Number of colours to return.
#' @return A character vector of hex colour codes.
#' @export
palette_sci <- function(n = 6) {
  viridis::viridis(n, option = "D")
}

#' Minimal ggplot2 theme for the book
#'
#' @param base_size Base font size (default 11).
#' @return A ggplot2 theme object.
#' @export
theme_sci <- function(base_size = 11) {
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold"),
      strip.text = ggplot2::element_text(face = "bold"),
      legend.position = "bottom"
    )
}
