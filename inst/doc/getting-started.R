## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

## ----setup--------------------------------------------------------------------
library(nonabsdid)

## ----hero, echo = FALSE, out.width = "100%", fig.alt = "Comparison of heterogeneity-robust estimators vs naive TWFE"----
knitr::include_graphics("figures/README_example2_plot_method_shape.png")

## ----quick, eval = FALSE------------------------------------------------------
# res <- nabs_event_study_simple(sim,
#                                outcome = "y", treatment = "d",
#                                unit = "id", time = "t")
# res$plot

## ----sim, eval = FALSE--------------------------------------------------------
# set.seed(2026)
# N <- 80; TT <- 24
# sim <- expand.grid(id = seq_len(N), t = seq_len(TT))
# 
# # Treatment switches on at t=10 for ids <= N/2, and off at t=16 for ids <= N/4.
# sim$d <- with(sim, as.integer(
#   (id <= N/2 & t >= 10 & !(id <= N/4 & t >= 16))
# ))
# 
# # Heterogeneous, time-varying effect: 1 for early, 0.5 for late.
# sim$tau <- with(sim, ifelse(id <= N/4, 1.0, 0.5))
# sim$y <- with(sim, 0.05 * id + 0.03 * t + d * tau + rnorm(nrow(sim), sd = 0.3))

## ----run, eval = FALSE--------------------------------------------------------
# res_dcdh <- nabs_event_study(sim, outcome = "y", treatment = "d",
#                          unit = "id", time = "t",
#                          method = "DCDH", lags = 4, leads = 6)
# 
# res_pm   <- nabs_event_study(sim, outcome = "y", treatment = "d",
#                          unit = "id", time = "t",
#                          method = "PanelMatch", lags = 4, leads = 6)
# 
# res_ife  <- nabs_event_study(sim, outcome = "y", treatment = "d",
#                          unit = "id", time = "t",
#                          method = "IFE")

## ----direct, eval = FALSE-----------------------------------------------------
# fit <- DIDmultiplegtDYN::did_multiplegt_dyn(
#   df = sim, outcome = "y", group = "id", time = "t",
#   treatment = "d", effects = 6, placebo = 4,
#   cluster = "id"
# )
# tidy_dcdh <- as_nabs_event_study(fit, outcome = "y")

## ----pm-direct, eval = FALSE--------------------------------------------------
# panel <- PanelMatch::PanelData(sim, "id", "t", "d", "y")
# pm    <- PanelMatch::PanelMatch(panel.data = panel, lag = 4, lead = 0:6,
#                                 refinement.method = "ps.match",
#                                 size.match = 10, qoi = "att",
#                                 placebo.test = TRUE,
#                                 forbid.treatment.reversal = FALSE)
# pe    <- PanelMatch::PanelEstimate(pm, panel.data = panel)
# pl    <- PanelMatch::placebo_test(pm, panel.data = panel, plot = FALSE)
# 
# tidy_pm <- as_nabs_event_study(pe, pre_obj = pl)

## ----twfe, eval = FALSE-------------------------------------------------------
# ref <- naive_twfe(sim, outcome = "y", treatment = "d",
#                   unit = "id", time = "t",
#                   lags = 4, leads = 6)

## ----plot, eval = FALSE-------------------------------------------------------
# nabs_event_plot(
#   res_dcdh$tidy, res_pm$tidy, res_ife$tidy,
#   reference = ref,
#   xlim = c(-4, 6),
#   ylim = c(-1, 2),
#   ylab = "Effect on y"
# )

## ----plot-out, echo = FALSE, out.width = "100%", fig.alt = "Default prepost_color overlay of three estimators vs naive TWFE"----
knitr::include_graphics("figures/README_example_plot.png")

## ----style-shape, echo = FALSE, out.width = "100%", fig.alt = "method_shape style: color by method, shape by pre/post"----
knitr::include_graphics("figures/README_example_plot_method_shape.png")

## ----style-shape-code, eval = FALSE-------------------------------------------
# nabs_event_plot(res_dcdh$tidy, res_pm$tidy, res_ife$tidy, reference = ref,
#                 style = "method_shape")

## ----style-connect, echo = FALSE, out.width = "100%", fig.alt = "method_shape style with connected point estimates"----
knitr::include_graphics("figures/README_example_plot_method_shape_connect.png")

## ----style-connect-code, eval = FALSE-----------------------------------------
# nabs_event_plot(res_dcdh$tidy, res_pm$tidy, res_ife$tidy, reference = ref,
#                 style = "method_shape", connect = TRUE)

