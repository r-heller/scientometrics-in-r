# verify_citations.R
# CI script: checks that every @citation-key in .qmd files has a matching
# entry in references.bib, and that DOIs resolve via Crossref.

library(stringr)

# 1. Collect all citation keys used in .qmd files
qmd_files <- list.files(
  c("chapters", "case-studies", "appendices"),
  pattern = "\\.qmd$", full.names = TRUE, recursive = TRUE
)
qmd_files <- c(qmd_files, "index.qmd")

all_keys <- character()
for (f in qmd_files) {
  text <- readLines(f, warn = FALSE)
  keys <- str_extract_all(text, "(?<=@)[A-Za-z][A-Za-z0-9_:./-]*")
  all_keys <- c(all_keys, unlist(keys))
}

# Remove common false positives (Quarto cross-ref prefixes)
all_keys <- unique(all_keys)
all_keys <- all_keys[!grepl("^(sec-|fig-|tbl-|eq-|lst-|thm-|lem-|cor-|prp-|cnj-|def-|exm-|exr-)", all_keys)]

if (length(all_keys) == 0) {
  message("No citation keys found in .qmd files. Skipping verification.")
  quit(status = 0)
}

# 2. Parse references.bib for available keys
bib_text <- readLines("references.bib", warn = FALSE)
bib_keys <- str_extract(bib_text, "(?<=@\\w{1,20}\\{)[A-Za-z0-9_:./-]+(?=\\s*,)")
bib_keys <- bib_keys[!is.na(bib_keys)]

# 3. Check for missing keys
missing <- setdiff(all_keys, bib_keys)
if (length(missing) > 0) {
  cat("ERROR: Citation keys used in .qmd files but missing from references.bib:\n")
  cat(paste(" -", missing, collapse = "\n"), "\n")
  quit(status = 1)
}

# 4. Verify DOIs resolve (sample up to 20)
doi_lines <- bib_text[grepl("^\\s*doi\\s*=", bib_text, ignore.case = TRUE)]
dois <- str_extract(doi_lines, "10\\.[0-9]{4,}[^}\"]+")
dois <- trimws(dois[!is.na(dois)])
dois <- unique(dois)

if (length(dois) == 0) {
  message("No DOIs found in references.bib. Skipping DOI resolution.")
  quit(status = 0)
}

sample_size <- min(20, length(dois))
doi_sample <- sample(dois, sample_size)

cat(sprintf("Verifying %d/%d DOIs via Crossref...\n", sample_size, length(dois)))

failures <- character()
for (doi in doi_sample) {
  url <- paste0("https://api.crossref.org/works/", doi)
  resp <- tryCatch(
    {
      con <- url(url)
      on.exit(close(con))
      readLines(con, n = 1, warn = FALSE)
      TRUE
    },
    error = function(e) FALSE
  )
  if (!resp) {
    failures <- c(failures, doi)
  }
}

if (length(failures) > 0) {
  cat("ERROR: The following DOIs could not be resolved:\n")
  cat(paste(" -", failures, collapse = "\n"), "\n")
  quit(status = 1)
}

cat("All citation checks passed.\n")
