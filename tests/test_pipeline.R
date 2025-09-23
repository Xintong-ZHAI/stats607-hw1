#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(testthat)
  library(readr)
  library(here)
})

# Test 1: Data validation (age >= 0)
test_that("all ages are non-negative", {
  dat <- readr::read_csv(
    here::here("data","raw","BIOSTAT651_mammography_data.csv"),
    show_col_types = FALSE
  )

  expect_true("age" %in% colnames(dat))
  expect_true(all(dat$age >= 0, na.rm = TRUE))
})

# Test 2: Pipeline integrity (expected output files exist)
test_that("pipeline produces expected output files", {
  expected_files <- c(
    here::here("results","tables","logistic_or.csv"),
    here::here("results","tables","polr_or.csv"),
    here::here("results","figures","stage_by_treatment.png")
  )

  for (f in expected_files) {
    expect_true(file.exists(f), info = paste("Missing file:", f))
  }
})
