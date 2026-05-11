# lint_chapters.R
# Style checks for chapter QMD files.

library(stringr)

rmd_files <- list.files(
  c("chapters", "case-studies", "appendices"),
  pattern = "\\.Rmd$", full.names = TRUE, recursive = TRUE
)

issues <- character()

for (f in rmd_files) {
  lines <- readLines(f, warn = FALSE)
  text <- paste(lines, collapse = "\n")

  # Skip placeholder chapters
  if (grepl("under development", text, fixed = TRUE)) next

  # Numbered method chapters follow the full scaffold from _template.Rmd.
  # Appendices, case studies, the navigator chapter (00-find-your-method.Rmd),
  # and the chapter template itself are intentional exceptions.
  is_method_chapter <- grepl("^chapters/[0-9]{2}-", f) &&
    !grepl("^chapters/00-", f) &&
    !grepl("/_template\\.Rmd$", f)

  if (is_method_chapter) {
    required <- c("Learning objectives", "Setup", "Session info")
    for (sec in required) {
      if (!grepl(sec, text, ignore.case = TRUE)) {
        issues <- c(issues, sprintf("  %s — missing section: %s", f, sec))
      }
    }
  }

  # Accessibility: fig-cap on an R/Python chunk should be paired with fig-alt.
  # Mermaid/Graphviz `%%|` blocks are excluded — they don't accept fig-alt.
  fig_chunks <- grep("^\\s*#\\|\\s*fig-cap:", lines)
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
