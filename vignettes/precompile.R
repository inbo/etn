# Run the following code before a new release to pre-compile vignettes that
# depend credentials for the OpenCPU API.
# Inspired by https://ropensci.org/blog/2019/12/08/precompute-vignettes/
options(pillar.width = 80)

knitr::knit("vignettes/etn_fields.Rmd.orig", output = "vignettes/etn_fields.Rmd")
knitr::knit("vignettes/acoustic_telemetry.Rmd.orig", output = "vignettes/acoustic_telemetry.Rmd")

