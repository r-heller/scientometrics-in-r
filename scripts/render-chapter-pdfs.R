library(rmarkdown)
library(fs)

chapters <- c(
  dir_ls("chapters", glob = "*.Rmd"),
  dir_ls("case-studies", glob = "*.Rmd"),
  dir_ls("appendices", glob = "*.Rmd")
)

out_dir <- "docs/pdf-chapters"
dir_create(out_dir)

for (ch in chapters) {
  out <- path_ext_set(path_file(ch), "pdf")
  rmarkdown::render(
    input         = ch,
    output_format = "pdf_document",
    output_file   = out,
    output_dir    = out_dir,
    envir         = new.env(),
    quiet         = TRUE
  )
}
