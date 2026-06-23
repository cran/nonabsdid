## ----include = FALSE----------------------------------------------------------
has_haven <- requireNamespace("haven", quietly = TRUE)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

## ----setup--------------------------------------------------------------------
library(nonabsdid)

## ----eval = has_haven---------------------------------------------------------
# For this vignette we fabricate a .dta file; in real life you already
# have one.
tmp <- tempfile(fileext = ".dta")
panel <- expand.grid(id = 1:60, t = 1:10)
panel$d <- with(panel, as.integer(
  (id %% 4 == 1 & t %in% 4:7) |
  (id %% 4 == 2 & t %in% 5:8) |
  (id %% 4 == 3 & t %in% 6:9)
))
panel$y <- 0.2 * panel$t + 0.5 * panel$d + rnorm(nrow(panel))
haven::write_dta(panel, tmp)

mydata <- nabs_read_dta(tmp)
head(mydata)

## ----eval = FALSE-------------------------------------------------------------
# mydata <- nabs_read_dta("mypanel.dta", labelled = "numeric")

## ----eval = FALSE-------------------------------------------------------------
# res <- nabs_event_study_simple(
#   "mypanel.dta",
#   outcome = "y", treatment = "d", unit = "id", time = "t"
# )

## ----eval = FALSE-------------------------------------------------------------
# res <- nabs_event_study(
#   mydata,
#   outcome   = "y",
#   treatment = "d",
#   unit      = "id",     # Stata: group()
#   time      = "t",
#   method    = "DCDH",
#   leads     = 7,        # Stata: effects(8)  -> leads = 8 - 1
#   lags      = 6,        # Stata: placebo(6)
#   cluster   = "state",
#   controls  = c("x1", "x2")
# )

## ----eval = FALSE-------------------------------------------------------------
# # These two calls are identical:
# nabs_event_study(mydata, outcome = "y", treatment = "d", time = "t",
#                  method = "DCDH",
#                  group = "id", effects = 8, placebo = 6)
# #> Translated Stata-style arguments:
# #> * `group` -> `unit`
# #> * `placebo` = 6 -> `lags` = 6
# #> * `effects` = 8 -> `leads` = 7
# #> i nonabsdid puts treatment onset at relative time 0, so `effects`
# #>   post-period estimates correspond to `leads = effects - 1`. ...
# 
# nabs_event_study(mydata, outcome = "y", treatment = "d", time = "t",
#                  method = "DCDH",
#                  unit = "id", leads = 7, lags = 6)

## ----eval = FALSE-------------------------------------------------------------
# res <- nabs_event_study_simple(mydata, outcome = "y", treatment = "d",
#                                unit = "id", time = "t")
# nabs_write_dta(res$tidy, "event_study_results.dta")

## ----include = FALSE, eval = has_haven----------------------------------------
unlink(tmp)

