# Contaminants integration docs

This document gathers all processing efforts in order to integrate data and generate the final database.

## Requirements

``` r
# install.packages("devtools")
devtools::install_github("ECCC-lavoie-ecotox/toxbox")
install.packages("quarto")
```

## Generate the website

```r
# Build
quarto::quarto_render()
# Serve the website in your browser
quarto::quarto_preview()
```
