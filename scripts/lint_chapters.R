# lint_chapters.R
# Style checks for chapter QMD files.

library(stringr)

qmd_files <- list.files(
  c("chapters", "case-studies", "appendices"),
  pattern = "\\.qmd$", full.names = TRUE, recursive = TRUE
)

issues <- character()

for (f in qmd_files) {
  lines <- readLines(f, warn = FALSE)
  text <- paste(lines, collapse = "\n")

  # Skip placeholder chapters

if (grepl("under development", text, fixed = TRUE)) next

  # Check for required sections
  required <- c("Learning objectives", "Setup", "Session info")
  for (sec in required) {
    if (!grepl(sec, text, ignore.case = TRUE)) {
      issues <- c(issues, sprintf("  %s — missing section: %s", f, sec))
    }
  }

  # Check for fig-alt on figure chunks
  fig_chunks <- grep("fig-cap:", lines)
  for (ln in fig_chunks) {
    context <- lines[max(1, ln - 2):min(length(lines), ln + 5)]
    if (!any(grepl("fig-alt:", context))) {
      issues <- c(issues, sprintf(
        "  %s:%d — fig-cap without fig-alt (accessibility)", f, ln
      ))
    }
  }
}

if (length(issues) > 0) {
  cat("Chapter lint issues found:\n")
  cat(paste(issues, collapse = "\n"), "\n")
  quit(status = 1)
}

cat("All chapters pass lint checks.\n")
