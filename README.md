# Mammography Compliance Study

This repository reports a randomized trial on **interventions to improve mammography screening compliance** among women aged 50+ who were initially non-adherent. We evaluate the effectiveness of **Phone**, **Print**, and **Phone+Print** interventions versus **Control**.

## Study Objectives
- Evaluate whether interventions increase **6-month screening compliance** (`resp6`).
- Evaluate whether interventions increase the odds of moving up the **cognitive screening stages** (`stagefwup`: precontemplation → contemplation → action).

## Methods

### Model 1 — Logistic regression (binary `resp6`)
Outcome: completed screening at 6 months (0/1).  
Predictors: `treatment` (Control, Phone, Print, Phone+Print) + covariates:
`age_center` (age−50), `inclt15k`, `workpay`, `married`, `stagebase`, `fdrhistory`.  
Diagnostics: Hosmer–Lemeshow GOF, residual/influence checks, VIF.

### Model 2 — Proportional Odds (ordinal `stagefwup`)
Ordered categories: precontemplation < contemplation < action.  
Predictor of interest: `treatment`.  
We report odds ratios (OR) with CIs and check proportional-odds via likelihood-based comparisons.

## Main Findings (brief)
- All three interventions improved **6-month compliance** over control in the logistic model.
- Interventions increased the odds of being in higher cognitive stages; **Phone+Print** showed the strongest effect.
- Diagnostics supported the adequacy of both final specifications.

> Exact ORs and CIs are exported under `results/tables/`.

## Environment & Dependencies

Dependencies are pinned by **`renv`** (see `renv.lock`). Core packages:
`tidyverse`, `readr`, `dplyr`, `ggplot2`, `MASS`, `car`, `ResourceSelection`, `broom`, `here`, `testthat`.

Restore the environment on a fresh system (run in R):

```r
install.packages("renv", repos = "https://cran.rstudio.com")
renv::restore()
```