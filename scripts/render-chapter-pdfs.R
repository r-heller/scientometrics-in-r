suppressPackageStartupMessages({
  library(rmarkdown)
  library(fs)
})

chapters <- c(
  dir_ls("chapters",     glob = "*.Rmd"),
  dir_ls("case-studies", glob = "*.Rmd"),
  dir_ls("appendices",   glob = "*.Rmd")
)

out_dir <- "docs/pdf-chapters"
dir_create(out_dir)

# Use xelatex so Unicode glyphs (en/em dashes, curly quotes, accented
# characters in author names) compile. pdf_document defaults to
# pdflatex, which rejects them. Reuse style/preamble.tex for the same
# tcolorbox/hyperref/fontspec setup as the full-book PDF.
pdf_fmt <- rmarkdown::pdf_document(
  latex_engine = "xelatex",
  includes     = rmarkdown::includes(in_header = "style/preamble.tex")
)

failed <- character()
for (ch in chapters) {
  out_file <- path_ext_set(path_file(ch), "pdf")
  message("Rendering: ", ch, " -> ", out_file)
  result <- tryCatch(
    {
      rmarkdown::render(
        input         = ch,
        output_format = pdf_fmt,
        output_file   = out_file,
        output_dir    = out_dir,
        envir         = new.env(),
        quiet         = TRUE
      )
      TRUE
    },
    error = function(e) {
      message("FAILED: ", ch, " — ", conditionMessage(e))
      FALSE
    }
  )
  if (!isTRUE(result)) failed <- c(failed, ch)
}

if (length(failed)) {
  message("\n", length(failed), " chapter PDF(s) failed; continuing.")
  # Don't fail the workflow — per-chapter PDFs are a nice-to-have and
  # the full-book PDF / HTML / EPUB are already rendered upstream.
}
