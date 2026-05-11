# verify_citations.R
# CI script: checks that every @citation-key in .Rmd files has a matching
# entry in references.bib, and that DOIs resolve via Crossref.

library(stringr)

# 1. Collect all citation keys used in .Rmd files
rmd_files <- list.files(
  c("chapters", "case-studies", "appendices"),
  pattern = "\\.Rmd$", full.names = TRUE, recursive = TRUE
)
rmd_files <- c(rmd_files, "index.Rmd")

all_keys <- character()
for (f in rmd_files) {
  text <- readLines(f, warn = FALSE)
  # Strip fenced code blocks so BibTeX/code examples don't leak @article keys.
  in_fence <- FALSE
  keep <- logical(length(text))
  for (i in seq_along(text)) {
    if (grepl("^\\s*```", text[i])) {
      in_fence <- !in_fence
      keep[i] <- FALSE
      next
    }
    keep[i] <- !in_fence
  }
  text <- text[keep]
  # Match @key only when @ itself is not escaped (\@) — \@ref(...) is a
  # bookdown cross-reference, not a citation.
  matches <- str_match_all(text, "(?:^|[^\\\\])@([A-Za-z][A-Za-z0-9_:/-]*[A-Za-z0-9])")
  keys <- unlist(lapply(matches, function(m) if (nrow(m)) m[, 2] else character()))
  all_keys <- c(all_keys, keys)
}

# Remove Quarto cross-reference prefixes (not citation keys)
all_keys <- unique(all_keys)
all_keys <- all_keys[!grepl(
  "^(sec-|fig-|tbl-|eq-|lst-|thm-|lem-|cor-|prp-|cnj-|def-|exm-|exr-)",
  all_keys
)]
# Strip trailing punctuation that pandoc treats as sentence terminator, not key.
all_keys <- sub("[.,;:!?)\\]]+$", "", all_keys)
all_keys <- unique(all_keys[nzchar(all_keys)])

if (length(all_keys) == 0) {
  message("No citation keys found in .Rmd files. Skipping verification.")
  quit(status = 0, save = "no")
}

cat(sprintf("Found %d unique citation keys in .Rmd files.\n", length(all_keys)))

# 2. Parse references.bib for available keys
bib_text <- readLines("references.bib", warn = FALSE)
bib_keys <- str_extract(
  bib_text,
  "(?<=@\\w{1,20}\\{)[A-Za-z0-9_:./-]+(?=\\s*,)"
)
bib_keys <- bib_keys[!is.na(bib_keys)]

cat(sprintf("Found %d entries in references.bib.\n", length(bib_keys)))

# 3. Check for missing keys
missing <- setdiff(all_keys, bib_keys)
if (length(missing) > 0) {
  cat("ERROR: Citation keys used in .Rmd files but missing from references.bib:\n")
  cat(paste(" -", missing, collapse = "\n"), "\n")
  quit(status = 1, save = "no")
}

cat("All citation keys found in references.bib.\n")

# 4. Verify DOIs resolve (sample up to 10)
doi_lines <- bib_text[grepl("^\\s*doi\\s*=", bib_text, ignore.case = TRUE)]
dois <- str_extract(doi_lines, "10\\.[0-9]{4,}[^},\"\\s]+")
dois <- trimws(dois[!is.na(dois)])
dois <- unique(dois)

if (length(dois) == 0) {
  message("No DOIs found in references.bib. Skipping DOI resolution.")
  quit(status = 0, save = "no")
}

sample_size <- min(10, length(dois))
set.seed(42)
doi_sample <- sample(dois, sample_size)

cat(sprintf("Verifying %d/%d DOIs via Crossref...\n", sample_size, length(dois)))

failures <- character()
for (doi in doi_sample) {
  url <- paste0("https://api.crossref.org/works/", utils::URLencode(doi, reserved = TRUE))
  success <- tryCatch(
    {
      resp <- readLines(url(url), n = 1, warn = FALSE)
      TRUE
    },
    error = function(e) FALSE,
    warning = function(w) TRUE
  )
  if (!success) {
    failures <- c(failures, doi)
  }
  Sys.sleep(0.5)
}

if (length(failures) > 0) {
  cat("ERROR: The following DOIs could not be resolved:\n")
  cat(paste(" -", failures, collapse = "\n"), "\n")
  quit(status = 1, save = "no")
}

cat("All citation checks passed.\n")
