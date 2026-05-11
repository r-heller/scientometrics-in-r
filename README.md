<p align="center"><a href="https://r-heller.github.io/scientometrics-in-r/"><img src="images/cover.png" alt="Scientometrics in R cover" width="280"></a></p>

# Scientometrics in R

*Bibliometrics, Network Science, and Research Evaluation*

A free, open-source book by **Raban Heller**.

## Read it online

📖 **<https://r-heller.github.io/scientometrics-in-r/>**

## Download

- 📄 [Whole book (PDF)](https://r-heller.github.io/scientometrics-in-r/scientometrics-in-r.pdf)
- 📚 [EPUB](https://r-heller.github.io/scientometrics-in-r/scientometrics-in-r.epub)
- 📑 Per-chapter PDFs: every chapter page has a download button at the top right.

## What this book covers

The book is a hands-on guide to scientometrics in R. It covers the
full workflow from data acquisition (OpenAlex, Crossref, PubMed)
through core bibliometric indicators, network analysis, text mining,
and production reporting. All examples are fully reproducible using
free, open data sources — no Web of Science or Scopus subscription is
required.

It is written for researchers, librarians, research administrators,
and data scientists who already know R at a tidyverse level and want
to add bibliometric methods to their toolkit. The book is unusually
explicit about *limitations and responsible use*: every quantitative
chapter ends with a callout grounded in the Leiden Manifesto and DORA.

What it does *not* cover: proprietary platforms (InCites, SciVal),
manual screening workflows for systematic reviews, and qualitative
sociology of science.

## Table of contents

The book has eight parts plus appendices:

- **Part I — Foundations** (Ch. 1–4): what scientometrics is, its
  theoretical roots, ethics, and data sources compared.
- **Part II — Data Acquisition** (Ch. 5–8): APIs, native exports,
  reproducible corpora, full-text.
- **Part III — Core Bibliometrics** (Ch. 9–14): descriptive metrics,
  productivity & impact, journal metrics, author/institution/temporal
  analysis.
- **Part IV — Network & Mapping** (Ch. 15–20): co-authorship,
  co-citation, co-word, community detection, science mapping,
  interoperability with Gephi/VOSviewer.
- **Part V — Text & Topic** (Ch. 21–25): text mining, topic models,
  keyword extraction, embeddings, emerging-topic detection.
- **Part VI — Advanced Topics** (Ch. 26–33): altmetrics, open-science
  indicators, gender, retractions, funding, patents, causal inference,
  reproducibility metadata.
- **Part VII — Production & Reporting** (Ch. 34–37): targets
  pipelines, dashboards, parameterised reports, Shiny apps.
- **Part VIII — Case Studies** (5 worked examples) and **5 appendices**
  (R setup, OpenAlex snapshot SQL, glossary, indicator crosswalk,
  cheatsheets, exercise solutions).

## How to cite

> Heller, R. (2026). *Scientometrics in R: Bibliometrics, Network
> Science, and Research Evaluation*.
> <https://r-heller.github.io/scientometrics-in-r/>

```bibtex
@book{heller2026scientometrics,
  author    = {Heller, Raban},
  title     = {Scientometrics in {R}: Bibliometrics, Network Science, and Research Evaluation},
  year      = {2026},
  url       = {https://r-heller.github.io/scientometrics-in-r/},
  publisher = {Self-published}
}
```

## Reproducibility

Built with [bookdown](https://bookdown.org/), R, and `renv`. To
rebuild locally:

```bash
git clone https://github.com/r-heller/scientometrics-in-r.git
cd scientometrics-in-r
R -e 'renv::restore()'
R -e 'bookdown::render_book("index.Rmd", output_format = "all")'
```

A Docker image (`Dockerfile`) is provided for fully reproducible
builds.

## License

Content: [CC BY-SA 4.0](LICENSE) · Source code: [MIT](LICENSE-CODE)

## Contributing

Issues and PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).
