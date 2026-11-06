## ----message=FALSE------------------------------------------------------------
library(drasR)

## -----------------------------------------------------------------------------
raw_data <- data.frame(
  lot_id = paste0("L", 1:12),
  date = as.Date("2026-01-01") + 0:11,
  supplier = c(rep("Supplier_A", 6), rep("Supplier_B", 6)),
  lot_size = rep(1000, 12),
  sample_size = rep(100, 12),
  defects_found = c(1, 0, 1, 2, 1, 2, 4, 5, 6, 4, 7, 8)
)

raw_data

## -----------------------------------------------------------------------------
prepared <- prepare_lot_data(
  raw_data,
  lot_id = "lot_id",
  sample_size = "sample_size",
  defects = "defects_found",
  lot_size = "lot_size",
  date = "date",
  supplier = "supplier"
)

prepared

## -----------------------------------------------------------------------------
plan <- find_plan(
  aql = 0.01,
  ltpd = 0.05,
  alpha = 0.05,
  beta = 0.10
)

plan

## -----------------------------------------------------------------------------
monitored <- dras_monitor(
  prepared,
  baseline_sample_size = plan$n,
  acceptance_number = plan$c,
  lambda = 0.40,
  warning_threshold = 0.02,
  tighten_factor = 2.00
)

monitored

## -----------------------------------------------------------------------------
summarise_dras_monitor(monitored)

## -----------------------------------------------------------------------------
summarise_dras_monitor(monitored, by_supplier = TRUE)

## -----------------------------------------------------------------------------
temp_dir <- tempfile("dras_report_")
files <- write_dras_report(monitored, output_dir = temp_dir)
files

