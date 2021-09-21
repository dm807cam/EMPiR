EMPiR
================

### Electron MicroProbe in R

<img src="man/figures/logo.png" align="right"  height="200" />

[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![](https://img.shields.io/github/last-commit/dm807cam/EMPiR.svg)](https://github.com/dm807cam/EMPiR/commits/main)
[![CodeFactor](https://www.codefactor.io/repository/github/dm807cam/EMPiR/badge)](https://www.codefactor.io/repository/github/dm807cam/EMPiR)
[![R build
status](https://github.com/dm807cam/EMPiR/workflows/R-CMD-check/badge.svg)](https://github.com/dm807cam/EMPiR/actions)

**Author:** [Dennis Mayk](https://www.dmayk.de/)<br/> **License:**
[AGPL-3](https://opensource.org/licenses/AGPL-3.0)<br/>

This package provides a pipe-friendly framework to work with EMP data in
the R language. So far, this package provides functions to import,
calibrate, smooth and subset EMP data. It also provides custom plot
options based on the ggplot plotting framework. <br/> **To report a bug
or submit a feature request please open a ticket or contact me by
mail.**

## Install

As of now, EMPiR is experimental and not available through CRAN. I plan
to release this package through CRAN once it reaches the first stable
version. In the meanwhile, EMPiR can be installed for experimental usage
directly from this Github repository using ‘devtools’.<br/>

``` r
devtools::install_github('dm807cam/EMPiR')
```

Please expect many substantial changes in the next weeks. The first
release of a stable version is expected for the start of November,
2021.</br>

## Usage examples

**(1) Specify path to sample data set.**

``` r
path_to_sample_data <- system.file('extdata', package = 'EMPiR')
```

**(2) Import data using get\_prob() and pipe data to plot function
image\_prob().**

``` r
# Import samplw data
get_prob(data_path = path_to_sample_data,
         data_name = 'Sample_mg.txt') %>%

# Plot sample data         
image_prob(legend_name = 'counts',
           scale_position = 'bottom_left',
           beam_size = 6) 
```

![](README_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

    ## # A tibble: 16,900 × 3
    ##        x     y     z
    ##    <dbl> <dbl> <dbl>
    ##  1     1     1    71
    ##  2     2     1    56
    ##  3     3     1    54
    ##  4     4     1    48
    ##  5     5     1    53
    ##  6     6     1    47
    ##  7     7     1    70
    ##  8     8     1    48
    ##  9     9     1    64
    ## 10    10     1    60
    ## # … with 16,890 more rows

**(3) Now, let’s try to chain multiple operations together.**

``` r
# Import sample data
get_prob(data_path = path_to_sample_data,
         data_name = 'Sample_mg.txt') %>%
         
# Remove data points below threshold
cut_prob('quant', 0.05) %>% 

# Apply smoothing filter
smooth_prob() %>% 

# Plot sample data         
image_prob(legend_name = 'counts',
           scale_position = 'bottom_left',
           beam_size = 6) 
```

![](README_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

    ## # A tibble: 152,100 × 4
    ##        x     y     z smooth
    ##    <dbl> <dbl> <dbl>  <dbl>
    ##  1     1     1    NA      3
    ##  2     2     1    NA      3
    ##  3     3     1    NA      3
    ##  4     4     1    NA      3
    ##  5     5     1    NA      3
    ##  6     6     1    NA      3
    ##  7     7     1    NA      3
    ##  8     8     1    NA      3
    ##  9     9     1    NA      3
    ## 10    10     1    NA      3
    ## # … with 152,090 more rows

**(4) And last but not least, let’s look at a full calibration
example.**

``` r
# Import background data
B <- get_bg(data_path = path_to_sample_data,
            data_string = "Bg")

# Import standards
cal <- get_std(data_path = path_to_sample_data,
               data_string = c("VG-2", "Dolomite")) %>% 
               
# Calculate calibration value from standard data               
cal_std(cal = c("VG-2" = 4.05, 
                "Dolomite" = 13.29),
        B = B,
        current = 0.1004,
        dwell_time = 20,
        accumulations = 8)

# Import sample data
get_prob(data_path = path_to_sample_data,
         data_name = "Sample_Mg.txt") %>%
         
# Calibrate sample data         
cal_prob(cal) %>% 

# Plot sample data
image_prob(legend_name = 'Sr [wt %]',
           scale_position = 'bottom_left',
           beam_size = 6) 
```

![](README_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

    ## # A tibble: 16,900 × 3
    ##        x     y     z
    ##    <dbl> <dbl> <dbl>
    ##  1     1     1  318.
    ##  2     2     1  256.
    ##  3     3     1  248.
    ##  4     4     1  223.
    ##  5     5     1  243.
    ##  6     6     1  218.
    ##  7     7     1  314.
    ##  8     8     1  223.
    ##  9     9     1  289.
    ## 10    10     1  273.
    ## # … with 16,890 more rows
