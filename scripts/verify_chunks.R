# verify_chunks.R
# CI script: checks that no chapter has eval: false without justification.
# Chapters with API-credential-gated chunks must mark them explicitly.

library(stringr)

rmd_files <- list.files(
  c("chapters", "case-studies", "appendices"),
  pattern = "\\.Rmd$", full.names = TRUE, recursive = TRUE
)

issues <- character()

for (f in rmd_files) {
  lines <- readLines(f, warn = FALSE)
  # Allow a file-level opt-out for files that are entirely reference/solution
  # code, where every chunk is intentionally unevaluated.
  if (any(grepl("verify_chunks:\\s*skip-file", lines))) next
  eval_false <- grep("#\\|\\s*eval:\\s*false", lines)
  for (ln in eval_false) {
    context_start <- max(1, ln - 5)
    context_end <- min(length(lines), ln + 5)
    context <- lines[context_start:context_end]
    has_justification <- any(grepl(
      paste(
        "requires credentials", "API key", "long-running", "cached output",
        "network access", "illustrative", "example only", "Shiny",
        "interactive", "deployment", "pipeline definition",
        "solutions appendix", "reference code",
        "Requires", "not bundled", "not executable", "not R code",
        "Example", "Recommended", "Render for multiple",
        "Initialise renv", "tar_make", "scanned PDF",
        sep = "|"
      ),
      context, ignore.case = TRUE
    ))
    if (!has_justification) {
      issues <- c(issues, sprintf(
        "  %s:%d — eval: false without justification", f, ln
      ))
    }
  }
}

if (length(issues) > 0) {
  cat("WARNING: Chunks with eval: false missing justification:\n")
  cat(paste(issues, collapse = "\n"), "\n")
  cat("Add a comment explaining why eval: false is needed.\n")
  quit(status = 1)
}

cat("All chunks verified.\n")
