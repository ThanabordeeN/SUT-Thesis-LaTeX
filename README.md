# SUT Thesis LaTeX

Unofficial, code-first LaTeX thesis template for **Suranaree University of Technology (SUT / มทส.)**.

> **Status:** early implementation aligned to the public SUT thesis-writing manual and the current official template links visible on 14 Sep 2026. It is not an official university template. Before final submission, compare the generated cover, approval, abstract, and other front-matter pages against the current Word template supplied by SUT.

## Why this repository exists

SUT publicly distributes Word thesis templates. This project separates **content** from **formatting** so a thesis can be maintained with Git, edited in VS Code/Overleaf-like workflows, and built reproducibly with XeLaTeX.

## Official sources used

- SUT Thesis Forms / Template page: https://das-af.sut.ac.th/web_details/form_thesis.php
- SUT Thesis Writing Guide (compiled edition): https://das-af.sut.ac.th/web_details/resource/pdf/thesis/ThesisWritingGuide_CompiledEdition_10-02-65.pdf
- Current Thai Word template linked by SUT: `Template TH_Update11-08-2026.docx`
- Current English Word template linked by SUT: `Template EN_Update11-08-2026.docx`

The SUT page currently links Word templates whose filenames indicate an update date of **11-08-2026**.

## Confirmed rules encoded in `sutthesis.cls`

The following are stated in the public SUT thesis-writing guide:

| Rule | Implemented value |
| --- | --- |
| Paper | A4, 80 gsm for printed copy |
| Printing | Double-sided |
| Main font | TH SarabunPSK |
| Body | 16 pt regular |
| Chapter title | 20 pt bold |
| Major heading | 18 pt bold |
| Secondary heading | 16 pt bold |
| Tertiary heading | 16 pt bold |
| Normal top margin | 1.5 in |
| Chapter/front heading top | 2 in |
| Bottom margin | 1 in |
| Left margin | 1.5 in |
| Right margin | 1 in |
| Secondary heading indent | 6 characters |
| Tertiary heading indent | 12 characters |
| Page number | upper-right, 1 in from top/right |
| Reference continuation indent | 8 characters |
| Multiple appendices (Thai thesis) | ภาคผนวก ก, ภาคผนวก ข, ... |

The guide also states that a single appendix is labeled simply `ภาคผนวก`, while multiple appendices use Thai letters (`ภาคผนวก ก`, `ภาคผนวก ข`, ...). The current class automates the multi-appendix form; if your thesis has exactly one appendix, adjust its displayed label to the unlettered form before submission.

The guide also states that the first page of each chapter and first pages of specified front/back-matter sections are counted but do not display their page number. Thai front matter uses Thai letters; English/foreign-language theses use uppercase Roman numerals.

## Implementation defaults that are **not claimed as confirmed SUT rules**

The public excerpts used for this first implementation did not provide a single numeric value for every typographic detail. Therefore:

- body leading defaults to `20pt` and can be changed with `\SUTSetBodyLeading{...}`;
- normal paragraph indent defaults to `2em` and can be changed with `\SUTSetParagraphIndent{...}`;
- the Thai front-matter alphabet sequence is configurable with `\SUTSetThaiPageSequence{...}`;
- cover and approval-page vertical spacing must still be visually checked against the official 2026 Word template;
- the sample BibLaTeX citation style is a starter configuration, not a claim that `authoryear` alone reproduces every SUT bibliography rule.

## Requirements

- XeLaTeX
- `latexmk`
- Biber
- a reasonably complete TeX Live / MiKTeX installation
- **TH SarabunPSK** for submission-compliant typography

XeTeX is intentional: its ICU line-breaking support accepts the `th_TH` locale, which provides Thai-specific line-break rules.

### Font behavior

By default the example uses the `fallbackfont` class option so the repository can compile on a machine that does not have TH SarabunPSK. The class emits a warning and uses `FreeSerif` if available.

For final output, switch to:

```tex
\documentclass[thai,master,strictfont]{sutthesis}
```

If `TH SarabunPSK` is missing, compilation will stop instead of silently creating a non-compliant PDF.

## Build

```bash
latexmk -xelatex main.tex
```

Clean generated files:

```bash
latexmk -C
```

## Project structure

```text
.
├── sutthesis.cls
├── main.tex
├── metadata.tex
├── references.bib
├── latexmkrc
├── frontmatter/
│   ├── approval.tex
│   ├── abstract-th.tex
│   ├── abstract-en.tex
│   └── acknowledgements.tex
└── chapters/
    ├── chapter01.tex
    ├── chapter02.tex
    ├── chapter03.tex
    ├── chapter04.tex
    ├── chapter05.tex
    └── appendix-a.tex
```

## Typical workflow

Edit `metadata.tex`, write each chapter in `chapters/`, keep citations in `references.bib`, and avoid manual formatting inside chapter files. Formatting changes belong in `sutthesis.cls`.

## Compliance boundary

### Confirmed by published SUT material

The page/paper/font/heading/page-number/reference-indent rules listed above, plus the existence of the current SUT Word template links.

### Not stated publicly / not yet reproduced exactly

The public material reviewed for this first version does not establish every exact Word-template measurement such as all cover-page vertical coordinates, all signature-block dimensions, or one mandatory numeric body leading value.

### Needs SUT confirmation

This repository does **not** claim that SUT officially accepts LaTeX source files. The university publishes Word templates and defines thesis presentation/submission rules; whether a specific program or staff workflow requires `.docx` should be confirmed with SUT. The intended final artifact from this repository is a PDF whose visual formatting follows the university requirements.

## License / contributions

This repository contains an independent implementation only. It does not redistribute the university's Word template or font files. Contributions that improve parity with the current official SUT template are welcome, but changes should cite the relevant SUT rule in the commit/PR description.
