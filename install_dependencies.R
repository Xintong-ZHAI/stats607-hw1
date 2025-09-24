if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv", repos="https://cran.rstudio.com")
renv::activate()
options(repos = c(CRAN = "https://cran.rstudio.com"))
pkgs <- c(
  "tidyverse","here","readr","dplyr","stringr","tidyr","purrr","tidyselect",
  "MASS","car","ResourceSelection","broom",
  "abind","cowplot","generics","numDeriv","pbapply","Rcpp","RcppEigen","cli"
)
need <- setdiff(pkgs, rownames(installed.packages()))
if (length(need)) install.packages(need, repos="https://cran.rstudio.com")
renv::snapshot()
