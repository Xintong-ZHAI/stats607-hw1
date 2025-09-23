#!/usr/bin/env Rscript

#install.packages("renv", repos = "https://cran.rstudio.com")
renv::activate()

#install.packages(c(
#  "tidyverse","MASS","car","ResourceSelection","broom","here"
#), repos = "https://cran.rstudio.com")

renv::snapshot()


suppressPackageStartupMessages({
  library(tidyverse)
  library(MASS)              # polr
  library(car)               # VIF
  library(ResourceSelection) # HL test
  library(broom)             # tidy outputs
  library(here)
})

cat("=== Mammography Compliance Study: Run Analysis ===\n")

# 1. Load and preprocess data
cat("Loading data...\n")
dat_raw <- readr::read_csv(
  here::here("data","raw","BIOSTAT651_mammography_data.csv"),
  show_col_types = FALSE
)

dat <- dat_raw %>%
  filter(!is.na(inclt15k)) %>%
  mutate(
    age_center = age - 50,
    treatment  = factor(treatment, levels = c(0,1,2,3),
                        labels = c("Control","Phone","Print","Phone+Print")),
    stagefwup  = factor(stagefwup, levels = c(1,2,3),
                        labels = c("precontemplation","contemplation","action"),
                        ordered = TRUE),
    stagebase  = factor(stagebase, levels = c(1,2),
                        labels = c("precontemplation","contemplation"),
                        ordered = TRUE),
    inclt15k   = factor(inclt15k, levels = c(0,1), labels = c("No","Yes")),
    workpay    = factor(workpay, levels = c(0,1), labels = c("No","Yes")),
    married    = factor(married, levels = c(0,1), labels = c("No","Yes")),
    fdrhistory = factor(fdrhistory, levels = c(0,1), labels = c("No","Yes")),
    resp6      = as.integer(resp6)
  )

cat("Data ready. N =", nrow(dat), "\n")

# 2. Logistic regression (Resp6)
cat("Fitting logistic regression...\n")
fit_logit <- glm(
  resp6 ~ treatment + age_center + inclt15k + workpay + married + stagebase + fdrhistory,
  data = dat,
  family = binomial(link = "logit")
)

or_tbl <- broom::tidy(fit_logit, conf.int = TRUE, conf.level = 0.95, exponentiate = TRUE) %>%
  arrange(term)

# Diagnostics
hl <- ResourceSelection::hoslem.test(fit_logit$y, fitted(fit_logit), g = 10)
vif_vals <- car::vif(fit_logit)

# Save logistic outputs
dir.create(here::here("results","tables"), recursive = TRUE, showWarnings = FALSE)
readr::write_csv(or_tbl, here::here("results","tables","logistic_or.csv"))
saveRDS(list(model = fit_logit, hl = hl, vif = vif_vals),
        here::here("results","tables","logistic_model.rds"))

cat("Logistic regression results saved to results/tables/\n")

# 3. Proportional odds model (Stagefwup ~ Treatment)
cat("Fitting proportional odds model...\n")
fit_polr <- MASS::polr(
  stagefwup ~ treatment,
  data = dat,
  Hess = TRUE
)

# Get the coefficient names for predictors (exclude thresholds)
beta_names <- names(coef(fit_polr))          # e.g., treatmentPhone, treatmentPrint, treatmentPhone+Print

# Summary table (predictors only)
coefs      <- coef(summary(fit_polr))
coefs_beta <- coefs[rownames(coefs) %in% beta_names, , drop = FALSE]

# Profiled CIs ONLY for predictor coefficients (matches length 3)
ci <- confint(fit_polr, parm = beta_names)   # may take a moment (profiling)

# Build OR table
or_polr <- tibble::tibble(
  term     = rownames(coefs_beta),
  estimate = coefs_beta[, "Value"],
  std_error= coefs_beta[, "Std. Error"],
  z        = coefs_beta[, "t value"],
  OR       = exp(estimate),
  OR_low   = exp(ci[, 1]),
  OR_high  = exp(ci[, 2]),
  p_value  = 2 * pnorm(abs(z), lower.tail = FALSE)
)

readr::write_csv(or_polr, here::here("results","tables","polr_or.csv"))


# Save polr outputs
readr::write_csv(or_polr, here::here("results","tables","polr_or.csv"))
saveRDS(fit_polr, here::here("results","tables","polr_model.rds"))

cat("Proportional odds model results saved to results/tables/\n")

# 4. Simple figure: distribution of Stagefwup by Treatment
cat("Generating figure...\n")
p <- dat %>%
  count(Treatment = treatment, Stagefwup = stagefwup) %>%
  group_by(Treatment) %>%
  mutate(p = n/sum(n)) %>%
  ggplot(aes(Stagefwup, p, fill = Treatment)) +
  geom_col(position = "dodge") +
  labs(y = "Proportion",
       title = "Follow-up stage distribution by treatment") +
  theme(legend.position = "bottom")

dir.create(here::here("results","figures"), recursive = TRUE, showWarnings = FALSE)
ggsave(filename = here::here("results","figures","stage_by_treatment.png"),
       plot = p, width = 7, height = 4, dpi = 300)

cat("Figure saved to results/figures/\n")

# 5. Done
cat("Analysis complete. See results/tables/ and results/figures/\n")
