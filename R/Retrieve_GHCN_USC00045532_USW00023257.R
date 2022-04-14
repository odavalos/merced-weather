library(readr)
library(dplyr)
library(tidyr)

# station readme
#   https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/by_station/readme-by_station.txt

# data readme
#   https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt


# Station #1 (USC00045532) ------------------------------------------------

# download the zipped file
temp_merced1 <- tempfile()
download.file("https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/by_station/USC00045532.csv.gz", temp_merced1)

# unzip and read Merced station USC00045532 (older records)
ghcn_merced1 <- read_csv(temp_merced1,
                 col_names = c("id", "yearmoda", "element", "value",
                               "mflag", "qflag", "sflag", "obs_time"),
                 col_types = "cccncccc")

# delete the zipped file
unlink(temp_merced1)

# subset and format
ghcn_merced1.wide <- ghcn_merced1 %>%
  select(yearmoda, element, value) %>%
  filter(element %in% c("PRCP", "SNOW", "SNWD", "TMAX", "TMIN")) %>%
  separate(col = yearmoda, sep = c(4,6), into = c("year", "month", "day")) %>%
  pivot_wider(names_from = element, values_from = value) %>%
  # convert from tenths of mm to inches
  mutate(PRCP_MM = PRCP,
         PRCP = PRCP * 0.00393701,
         SNOW = SNOW * 0.00393701,
         SNWD = SNWD * 0.00393701) %>%
  # convert from tenths of degrees C to F
  mutate(TMAX = ((TMAX / 10) * (9/5)) + 32,
         TMIN = ((TMIN / 10) * (9/5)) + 32) %>%
  mutate(date = as.Date(paste(year, month, day, sep = "-")),
         day_of_year = lubridate::yday(date)) %>%
  select(year, month, day, date, day_of_year, PRCP_MM,PRCP, SNOW, SNWD,
         TMAX, TMIN)

rm(ghcn_merced1)
gc()

# Station #2 (USW00023257) ------------------------------------------------

# download the zipped file
temp_merced2 <- tempfile()
download.file("https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/by_station/USW00023257.csv.gz", temp_merced2)

# unzip and read Merced station USC00045532 (older records)
ghcn_merced2 <- read_csv(temp_merced2,
                         col_names = c("id", "yearmoda", "element", "value",
                                       "mflag", "qflag", "sflag", "obs_time"),
                         col_types = "cccncccc")

# delete the zipped file
unlink(temp_merced2)

ghcn_merced2.wide <- ghcn_merced2 %>%
  select(yearmoda, element, value) %>%
  filter(element %in% c("PRCP", "SNOW", "SNWD", "TMAX", "TMIN")) %>%
  separate(col = yearmoda, sep = c(4,6), into = c("year", "month", "day")) %>%
  pivot_wider(names_from = element, values_from = value) %>%
  # convert from tenths of mm to inches
  mutate(PRCP_MM = PRCP,
         PRCP = PRCP * 0.00393701,
         SNOW = SNOW * 0.00393701,
         SNWD = SNWD * 0.00393701) %>%
  # convert from tenths of degrees C to F
  mutate(TMAX = ((TMAX / 10) * (9/5)) + 32,
         TMIN = ((TMIN / 10) * (9/5)) + 32) %>%
  mutate(date = as.Date(paste(year, month, day, sep = "-")),
         day_of_year = lubridate::yday(date)) %>%
  select(year, month, day, date, day_of_year, PRCP_MM,PRCP, SNOW, SNWD,
         TMAX, TMIN)

rm(ghcn_merced2)
gc()

# appending the station #1 historical data to station #2
firstdate_merced2 <- ghcn_merced2.wide$date %>% min()

ghcn_merced1.wide <- ghcn_merced1.wide %>% 
  filter(date <= firstdate_merced2)

merged_merced <- bind_rows(ghcn_merced1.wide, ghcn_merced2.wide)
rm(ghcn_merced1.wide, ghcn_merced2.wide)

write_csv(merged_merced, "data/GHCN_USC00045532_USW00023257.csv")
