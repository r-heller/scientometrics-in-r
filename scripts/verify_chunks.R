# verify_chunks.R
# CI script: checks that no chapter has eval: false without justification.
# Chapters with API-credential-gated chunks must mark them explicitly.

library(stringr)

qmd_files <- list.files(
  c("chapters", "case-studies", "appendices"),
  pattern = "\\.qmd$", full.names = TRUE, recursive = TRUE
)

issues <- character()

for (f in qmd_files) {
  lines <- readLines(f, warn = FALSE)
  eval_false <- grep("#\\|\\s*eval:\\s*false", lines)
  for (ln in eval_false) {
    context_start <- max(1, ln - 5)
    context <- lines[context_start:ln]
    has_justification <- any(grepl(
      "(requires credentials|API key|long-running|cached output)",
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
