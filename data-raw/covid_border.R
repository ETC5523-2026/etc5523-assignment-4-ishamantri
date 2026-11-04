
#packages

library(dplyr)
library(tidyr)
library(readr)

#Download Data

owid_url <- "https://catalog.ourworldindata.org/garden/covid/latest/compact/compact.csv"

owid_raw <- read_csv(owid_url, show_col_types = FALSE)

#Select countries

strict_border <- c("Australia", "New Zealand", "China")
open_border   <- c("United Kingdom", "United States", "Sweden")

#Filter and clean
#using smoothed per-million so country sizes are comparable

covid_border <- owid_raw |>
  filter(
    country %in% c(strict_border, open_border),
    date >= as.Date("2020-03-01"),
    date <= as.Date("2023-12-31")
  ) |>
  select(
    country,
    date,
    cases_per_million  = new_cases_smoothed_per_million,
    deaths_per_million = new_deaths_smoothed_per_million,
    vaccinated_pct     = people_fully_vaccinated_per_hundred,
    population
  ) |>
  mutate(
    border_strategy = factor(
      if_else(country %in% strict_border, "Strict border control", "Open border"),
      levels = c("Strict border control", "Open border")
    ),
    country = factor(country, levels = c(strict_border, open_border))
  ) |>
  arrange(country, date)

#Fix missing vaccination values

covid_border <- covid_border |>
  group_by(country) |>
  fill(vaccinated_pct, .direction = "down") |>
  mutate(vaccinated_pct = replace_na(vaccinated_pct, 0)) |>
  ungroup() |>
  filter(!is.na(cases_per_million) | !is.na(deaths_per_million))

#Save to package

usethis::use_data(covid_border, overwrite = TRUE)
