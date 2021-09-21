EMPiR
================

### Electron MicroProbe in R

<img src="man/figures/logo.png" align="right"  height="200" /> This
package provides pipe-friendly framework to import, calibrate and
evaluate EMP data in the R language.

[![License:
AGPL-v3](https://img.shields.io/badge/license-AGPL--v3-blue.svg)](https://cran.r-project.org/web/licenses/AGPL-v3)
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![](https://img.shields.io/github/last-commit/dm807cam/EMPiR.svg)](https://github.com/dm807cam/EMPiR/commits/main)
[![CodeFactor](https://www.codefactor.io/repository/github/dm807cam/EMPiR/badge)](https://www.codefactor.io/repository/github/dm807cam/EMPiR)
[![R build
status](https://github.com/dm807cam/EMPiR/workflows/R-CMD-check/badge.svg)](https://github.com/dm807cam/EMPiR/actions)

## Usage

    get_prob(data_path = "path/to/file",
             data_name = "file.txt") %>%
      image_prob(legend_unit = 'Sample [counts]',
                 scale_location = 'bottom_left',
                 beam_size = 6) 

## Install

As of now, EMPiR is experimental and not available through CRAN. </br>
In the meanwhile, EMPiR can be installed directly from this Github
repository using ‘devtools’.</br>
`devtools::install_github('dm807cam/EMPiR')`</br> Please expect many
substantial changes in the next weeks. The first release of a stable
version is expected for the start of November, 2021.</br></br> To report
a bug or submit a feature request please open a ticket or contact me by
mail.
