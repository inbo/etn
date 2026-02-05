# Run the following code before a new release to pre-compile vignettes that
# depend on online services.
# Inspired by https://ropensci.org/blog/2019/12/08/precompute-vignettes/
options(pillar.width = 80)
knitr::knit("vignettes/acoustic-telemetry.Rmd.orig", "vignettes/acoustic-telemetry.Rmd")
