# bordercovid

Compare COVID-19 case and mortality rates between countries that used strict
border quarantine and countries that did not.

## What this is for

Australia, New Zealand and China kept strict border controls in place for most
of the pandemic. The United Kingdom, the United States and Sweden did not.
Comparing the two groups looks straightforward until the period of comparison
changes, at which point the answer can reverse.

Over the full period, March 2020 to December 2023, the two groups average
almost the same daily case rate. Restricted to 2020, the open-border countries
look about ninety times worse. Restricted to 2022, the strict-border countries
look worse. All three statements come from the same data, which is the point
the app is built to show.

## What is in the package

- `covid_border` - a cleaned daily dataset of cases, deaths and vaccination
  coverage for six countries, 8,406 rows and 7 variables
- `summarise_period()` - summarises outcomes for each country between any two
  dates
- `run_app()` - launches a Shiny app for exploring the comparison

## Installation

```r
# install.packages("remotes")
remotes::install_github("ETC5523-2026/etc5523-assignment-4-ishamantri")
```

## Getting started

```r
library(bordercovid)

# the whole period
summarise_period()

# 2020 on its own
summarise_period(from = "2020-03-01", to = "2020-12-31")

# 2022 on its own, which reverses the ranking
summarise_period(from = "2022-01-01", to = "2022-12-31")

# launch the Shiny app
run_app()
```

The app has a date range, a choice of cases or deaths, and country
checkboxes. Changing the date range is what makes the comparison move.

## Data source

Our World in Data COVID-19 dataset, licensed CC BY 4.0.
<https://docs.owid.io/projects/etl/api/covid/>

The preparation script is in `data-raw/covid_border.R` and can be re-run to
rebuild the dataset from source.

## Website

<https://etc5523-2026.github.io/etc5523-assignment-4-ishamantri/>

## Use of AI
