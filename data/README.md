## Merced daily weather history bulk download

This file (`data/GHCN_USC00045532.csv`) contains daily weather reports from Merced Regional Airport (GHCN:USC00045532). The start date is June 1, 1899.

The data fields are:

* PRCP - precipitation (inches)
* SNOW - snowfall (inches)
* SNWD - snow depth (inches)
* TMAX - maximum temperature (degrees Fahrenheit)
* TMIN - minimum temperature

Detailed field definitions are in [this NOAA documentation file](ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt).

This file is created by running `R/Retrieve_GHCN_USW00014839.R`. That script downloads the latest data, unzips it, filters for the desired statistics, converts those values to the desired units, formats date columns, and converts the data from long to wide format.
