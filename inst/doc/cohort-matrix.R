## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4
)
has_fect <- requireNamespace("fect", quietly = TRUE)
has_dcdh <- requireNamespace("DIDmultiplegtDYN", quietly = TRUE) &&
  requireNamespace("polars", quietly = TRUE)

## ----setup--------------------------------------------------------------------
library(nonabsdid)

## ----toy----------------------------------------------------------------------
set.seed(1)
N <- 120; TT <- 14
panel <- expand.grid(id = 1:N, t = 1:TT)
grp   <- panel$id %% 4                         # group 0 = never treated
onset <- c(`1` = 4L, `2` = 6L, `3` = 8L)[as.character(grp)]
# a quarter of switchers turn OFF again 3 periods later (non-absorbing)
off   <- (panel$id %% 8 == 1) & !is.na(onset) & panel$t >= onset + 3L
panel$d <- as.integer(!is.na(onset) & panel$t >= onset & !off)
panel$y <- rnorm(N, sd = .5)[panel$id] + 0.15 * panel$t +
  ifelse(panel$d == 1, 0.4, 0) + rnorm(nrow(panel))

## ----fect-fit, eval = has_fect------------------------------------------------
res_ife <- nabs_effect_cells(
  panel, outcome = "y", treatment = "d", unit = "id", time = "t",
  method = "IFE", lags = 4, leads = 6, nboots = 100
)
res_ife$cells

## ----fect-plot, eval = has_fect-----------------------------------------------
plot_effect_matrix(res_ife$cells, show_estimates = TRUE, show_se = TRUE)

## ----dcdh-fit, eval = has_dcdh------------------------------------------------
res_dcdh <- nabs_effect_cells(
  panel, outcome = "y", treatment = "d", unit = "id", time = "t",
  method = "DCDH", lags = 3, leads = 5, dcdh_strategy = "loop"
)
plot_effect_matrix(res_dcdh$cells, show_estimates = TRUE, show_se = TRUE)

## ----side-by-side, eval = has_fect && has_dcdh--------------------------------
plot_effect_matrix(res_dcdh$cells, res_ife$cells)

## ----from-existing, eval = FALSE----------------------------------------------
# fit <- fect::fect(y ~ d, data = panel, index = c("id", "t"),
#                   method = "fe", force = "two-way",
#                   se = TRUE, nboots = 100, keep.sims = TRUE)
# cells <- as_nabs_effect_cells(fit, method = "FE", outcome = "y")

## ----escape-hatch-------------------------------------------------------------
raw <- expand.grid(cohort = c(4L, 6L, 8L), event_time = -2:5)
raw$estimate  <- with(raw, ifelse(event_time < 0, 0, 0.4 + 0.05 * event_time))
raw$std.error <- 0.07
cells <- as_nabs_effect_cells(raw, method = "FE", outcome = "y")
plot_effect_matrix(cells, show_estimates = TRUE, show_se = TRUE)

## ----aggregate, eval = has_fect-----------------------------------------------
agg <- aggregate_effects(res_ife$cells, by = "event_time")
nabs_event_plot(agg, xlim = c(0, 6))

