# Generation Log

Append-only log of chapter and case study generation.

| Date | Chapter | Words | Chunks | Citations | DOI check | HTML render | PDF render | Deviations | TODOs |
|:-----|:--------|------:|-------:|----------:|:----------|:------------|:-----------|:-----------|:------|
| 2026-05-09 | Ch. 05 — APIs and Packages | ~2,100 | 11 | 4 (priem2022, hicks2015, aria2017, garfield1955) | Pending CI | Pending CI | Pending CI | Crossref example uses eval:false (network dependency) | None |
| 2026-05-09 | Ch. 10 — Productivity & Impact Indicators | ~2,800 | 12 | 7 (hirsch2005, egghe2006, waltman2016, waltman2012mncs, hicks2015, dora2012) | Pending CI | Pending CI | Pending CI | g_index defined inline (not yet in R/utils.R) | Move g_index to package |
| 2026-05-09 | Ch. 15 — Co-authorship Networks | ~2,500 | 13 | 7 (newman2001, barabasi2002, blondel2008, traag2019, fortunato2010, glanzel2004, hicks2015) | Pending CI | Pending CI | Pending CI | None | None |
## 2026-05-11 — Book cover wired (9029876)

- Added `images/cover.png` (1600×2400) to HTML landing page, EPUB `cover-image`, README thumbnail, and `book.cover-image` (Open Graph).
- Copied to `.github/social-preview.png`. The image is portrait (1600×2400); GitHub social previews prefer 1280×640 landscape, so Raban may want to upload a cropped/landscape version manually via repo Settings → Social preview.

## 2026-05-11 — Added LLM-use acknowledgment

- index.qmd Acknowledgments: added "Use of LLM tools" subsection
  (self-hosted Mistral Le Chat via Ollama/ollamar + Copilot in RStudio).
- Commit: 5994c8f
- This Quarto project has no 95-colophon.qmd; the pointer line from the
  brief is therefore omitted. If a colophon file is added later, copy
  the one-liner from the brief into it.

## 2026-05-11 — Comprehensive checkup: Quarto → bookdown conversion

- Engine: was Quarto, converted to bookdown (Phase 1 of brief).
- Renamed 51 .qmd → .Rmd with git mv (history preserved).
- Rewrote cross-refs, callouts, anchors; added H1 from YAML title.
- New config: index.Rmd YAML, _bookdown.yml (full chapter order incl. front/back matter), _output.yml (bs4_book + pdf_book + epub_book), _common.R per CLAUDE.md §A3, style/{style.css,header.html,preamble.tex,per-chapter-pdf-button.html} per §A6.
- Added front matter: 00-impressum, 00-acknowledgments (incl. LLM-use subsection — self-hosted Mistral Le Chat via Ollama/ollamar + Copilot in RStudio), 00-how-to-use, 00-notation, 00-about-the-author.
- Added back matter: 90-glossary (relocated from appendices/C-glossary), 95-colophon (with packages.bib auto-write and one-line LLM pointer), 99-references.
- Added scripts/render-chapter-pdfs.R; renamed scripts/verify_citations.R → verify-citations.R; updated all verifiers to .Rmd and to ignore bookdown's \@ref(...).
- Rewrote .github/workflows/render.yml: setup-r + manual renv bootstrap (Posit mirror) + setup-tinytex, then bookdown::render_book("…", output_format="all"), per-chapter PDFs, then JamesIves/github-pages-deploy-action → gh-pages branch.
- README rewritten: plain prose, no badges, download links, BibTeX block.
- Local verifiers green (citations, chunks, lint). Render to be validated by CI.
