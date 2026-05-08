#' Fetch works from OpenAlex with caching
#'
#' Wraps [openalexR::oa_fetch()] with local file caching so repeated
#' builds do not re-query the API.
#'
#' @param ... Arguments passed to [openalexR::oa_fetch()].
#' @param cache_dir Directory for cached results.
#' @param cache_days Number of days before cache expires.
#' @return A tibble of OpenAlex works.
#' @export
fetch_openalex <- function(..., cache_dir = "_freeze/openalex_cache",
                           cache_days = 7) {
  if (!dir.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE)

  args <- list(...)
  cache_key <- rlang::hash(args)
  cache_file <- file.path(cache_dir, paste0(cache_key, ".rds"))

  if (file.exists(cache_file)) {
    age <- difftime(Sys.time(), file.mtime(cache_file), units = "days")
    if (as.numeric(age) < cache_days) {
      return(readRDS(cache_file))
    }
  }

  result <- openalexR::oa_fetch(...)
  saveRDS(result, cache_file)
  result
}
