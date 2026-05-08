#' Deduplicate records by DOI
#'
#' Removes duplicate rows based on the `doi` column, keeping the first
#' occurrence. Rows with missing DOIs are always kept.
#'
#' @param df A data frame with a `doi` column.
#' @return A deduplicated tibble.
#' @export
dedupe_by_doi <- function(df) {
  stopifnot("doi" %in% names(df))
  has_doi <- !is.na(df$doi) & nzchar(df$doi)
  deduped <- df[has_doi, ]
  deduped <- deduped[!duplicated(deduped$doi), ]
  no_doi <- df[!has_doi, ]
  dplyr::bind_rows(deduped, no_doi)
}

#' Compute the h-index from a citation vector
#'
#' @param citations An integer vector of citation counts.
#' @return A single integer: the h-index.
#' @export
compute_h_index <- function(citations) {
  stopifnot(is.numeric(citations))
  citations <- sort(citations, decreasing = TRUE)
  n <- length(citations)
  if (n == 0L) return(0L)
  h <- sum(citations >= seq_along(citations))
  as.integer(h)
}

#' Field-normalize citation counts (MNCS)
#'
#' Computes the Mean Normalized Citation Score by dividing each paper's
#' citation count by the field mean for its publication year.
#'
#' @param citations Numeric vector of citation counts.
#' @param field_means Numeric vector of field mean citation counts
#'   (same length as `citations`).
#' @return A numeric vector of normalized citation scores.
#' @export
field_normalize <- function(citations, field_means) {
  stopifnot(
    is.numeric(citations),
    is.numeric(field_means),
    length(citations) == length(field_means)
  )
  ifelse(field_means == 0, NA_real_, citations / field_means)
}
