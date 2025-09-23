# Mammography Compliance Study

This repository contains the reproducible analysis pipeline for **Unit 1 Project – Frictionless Reproducibility** in BIOS 607. The project revisits a randomized trial dataset on interventions to improve mammography screening compliance among women aged 50 and older. The analysis evaluates whether phone, print, or combined interventions significantly increase (1) compliance at 6 months and (2) advancement in cognitive stages of screening behavior.

## Project Objectives
- Transform a prior data analysis project into a **clean, structured, and reproducible** workflow.  
- Apply logistic regression and proportional odds models to address research questions.  
- Ensure that the entire pipeline, from raw data to results, can be reproduced on a fresh system with a single command.  

## Installation & Environment Setup
This project uses [`renv`](https://rstudio.github.io/renv/) to manage R dependencies.

1. Clone the repository:
   ```bash
   git clone git@github.com:Xintong-ZHAI/stats607-hw1.git
   cd stats607-hw1
   ```

2. Open R in the project root and run:
   ```r
   install.packages("renv", repos = "https://cran.rstudio.com")
   renv::restore()
   ```

This will recreate the exact package environment recorded in `renv.lock`.

## Usage
To reproduce the full analysis pipeline:

```bash
Rscript run_analysis.R
```

This command will:
- Load and clean the raw dataset (`data/raw/BIOSTAT651_mammography_data.csv`)  
- Run regression analyses from `src/analysis/`  
- Generate tables and figures under `results/`  

## Expected Outputs
- **Tables**: Logistic regression and proportional odds regression summaries in `results/tables/`  
- **Figures**: Diagnostic plots (residuals, influence, etc.) in `results/figures/`  
- **Report**: A compiled project report in `results/report/`  

## Testing
Unit tests are provided under `tests/`. Run with:
```bash
Rscript tests/run_tests.R
```
Tests cover:
- Data validation (expected columns, missing values)  
- Function correctness (calculation accuracy and expected formats)  

## Directory Structure
```
stats607-hw1/
├── data/              # raw and processed data
├── src/               # pipeline and analysis scripts
├── artifacts/         # intermediate outputs
├── results/           # tables, figures, report
├── tests/             # testthat scripts
├── docs/              # documentation
├── run_analysis.R     # single entry point
├── renv.lock          # environment lockfile
└── README.md
```

---

**Author**: Xintong Zhai  
**Course**: STATS 607 – Large-Scale Inference & Reproducibility  
