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

  sci_rate_limit()
  result <- openalexR::oa_fetch(...)
  saveRDS(result, cache_file)
  result
}

# Rate-limiting state shared across calls within a session
.sci_rate_env <- new.env(parent = emptyenv())
.sci_rate_env$last_request <- NULL

#' Enforce rate limiting between API requests
#'
#' Sleeps if the last request was made less than `min_interval` seconds ago.
#' Called internally by [fetch_openalex()].
#'
#' @param min_interval Minimum seconds between requests (default 0.2).
#' @return Invisible NULL.
#' @keywords internal
sci_rate_limit <- function(min_interval = 0.2) {
  now <- proc.time()[["elapsed"]]
  if (!is.null(.sci_rate_env$last_request)) {
    elapsed <- now - .sci_rate_env$last_request
    if (elapsed < min_interval) {
      Sys.sleep(min_interval - elapsed)
    }
  }
  .sci_rate_env$last_request <- proc.time()[["elapsed"]]
  invisible(NULL)
}
