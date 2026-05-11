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

## 2026-05-11 — Harrer-style landing page refinement

- Restructured index.Rmd: cover image chunk at top (280px, left-aligned), one-line pitch, "About this book", "How to use this book", "License", "Citing this Guide" pointer.
- Added 9 part files (part-foundations, part-data-acquisition, part-core-bibliometrics, part-networks-mapping, part-text-topic, part-advanced-topics, part-production, part-case-studies, part-appendix). part-appendix uses (APPENDIX) for letter-keyed appendices; others use (PART) for sidebar group headers.
- Switched _bookdown.yml rmd_files to explicit ordering interleaving part-*.Rmd files between chapter groups.
- Added 98-citing-this-guide.Rmd with prose block-quote citation + BibTeX and RIS download links.
- Created citation.ris alongside the existing citation.bib.
- Added style/footer.html with the "Built by bookdown" attribution; combined with the per-chapter PDF button into style/after-body.html and wired into _output.yml under bs4_book.includes.after_body.
- _common.R: added a copy hook so citation.bib and citation.ris land in docs/citation-files/ on every render.
- No changes to design tokens, _common.R knitr opts, color palette, style/style.css, fonts, chapter prose, code, numbering, references.bib, or renv.lock.
- Commit: 336cb6c - Manual: importing the generated citation.ris into Zotero needs spot-checking after the first deploy.

## 2026-05-11 — Harrer-style layout adoption (Coder palette)

- 00-acknowledgments.Rmd: added "Inspiration" subsection crediting Harrer, Cuijpers, Furukawa, Ebert and linking the meta-analysis book + repository.
- style/style.css rebuilt with the same component system Harrer uses (callout topology, mode tokens, code-chunk gradient, sticky toggle button) but retokenized to Hugo Coder colors (#fafafa/#212121 light, #212121/#dadada dark, #1565c0/#42a5f5 link) and fonts (Inter / JetBrains Mono).
- Vendored Font Awesome 6 Free locally: style/font-awesome.min.css + style/webfonts/{fa-solid-900,fa-regular-400,fa-brands-400}.woff2. No CDN at render. Rewrote ../webfonts/ paths to webfonts/ so the relative URL resolves from style/.
- Dark/light toggle: vanilla JS (no jQuery), data-theme attribute on <html>, localStorage persistence keyed "themeMode", defaults to OS prefers-color-scheme. Icon: fa-solid fa-circle-half-stroke (not the 🌓 emoji).
- Callout block classes: boxinfo (lightbulb), boximportant (exclamation-circle), boxreport (file-medical), boxdmetar (box-open), boxquestion (circle-question), boxempty (no icon, used for the citation block). Glyphs come from FA6 unicode codepoints.
- index.Rmd landing page restructured to the Harrer pattern: Welcome → cover right-floated → pitch → Open Source Repository → How To Use The Guide → Contributing → Citing this Guide (boxempty card).
- 98-citing-this-guide.Rmd citation block switched to boxempty.
- _output.yml css list: [style/style.css, style/font-awesome.min.css].
- Also: fix-labels.py / fix-refs.py prefixed every chunk label with its file token (01-setup, 02-fetch-…) so bookdown's single-doc merge does not error on duplicate labels; cross-refs updated to match. Chapter 22/25 + cs05 quanteda::convert() namespacing (tidygraph::convert was shadowing). Mermaid engine registered in _common.R; mermaid.js loaded from jsDelivr in header.html. _bookdown.yml switched to new_session: no (subdir Rmd files are incompatible with new_session: yes); _common.R is sourced once from index.Rmd. No content/numbering changes; bs4_book kept (gitbook is optional per project per the brief).
