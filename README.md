<p align="center"><a href="https://r-heller.github.io/scientometrics-in-r/"><img src="images/cover.png" alt="Scientometrics in R cover" width="280"></a></p>

# Scientometrics in R

**Bibliometrics, Network Science, and Research Evaluation — A Quarto Book**


---

**Read online:** <https://r-heller.github.io/scientometrics-in-r/>

**Download:** [PDF](https://github.com/r-heller/scientometrics-in-r/releases) ·
[EPUB](https://github.com/r-heller/scientometrics-in-r/releases)

---

## About

This book is a hands-on guide to scientometrics using R. It covers the full
workflow from data acquisition (OpenAlex, Crossref, PubMed) through core
bibliometric indicators, network analysis, text mining, and production
reporting. All examples are fully reproducible using free, open data sources.

**8 parts · 37 chapters · 5 case studies · 5 appendices**

## Quick start

### Read online

Visit <https://r-heller.github.io/scientometrics-in-r/>.

### Build locally

```bash
# Clone
git clone https://github.com/r-heller/scientometrics-in-r.git
cd scientometrics-in-r

# Restore R packages
Rscript -e 'renv::restore()'

# Preview
quarto preview
```

### Build with Docker

```bash
docker build -t scientometrics-in-r .
docker run --rm -v $(pwd)/_book:/book/_book scientometrics-in-r
```

## Sibling volumes

| Book | Repository |
|:-----|:-----------|
| Strategy in R | [r-heller/strategy-in-r](https://github.com/r-heller/strategy-in-r) |
| Methods in R | [r-heller/methods-in-r](https://github.com/r-heller/methods-in-r) |

## How to cite

> Heller, R. (2026). *Scientometrics in R: Bibliometrics, Network Science, and
> Research Evaluation*. <https://r-heller.github.io/scientometrics-in-r/>

```bibtex
@book{heller2026scientometrics,
  author    = {Heller, Raban},
  title     = {Scientometrics in {R}: Bibliometrics, Network Science, and Research Evaluation},
  year      = {2026},
  url       = {https://r-heller.github.io/scientometrics-in-r/},
  publisher = {Self-published}
}
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

- **Text and figures:** [CC-BY-SA 4.0](LICENSE)
- **Code:** [MIT](LICENSE-CODE)
