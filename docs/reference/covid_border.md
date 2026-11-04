# COVID-19 outcomes in strict-border and open-border countries

Daily COVID-19 case and death rates for six countries between March 2020
and December 2023. Three of them (Australia, New Zealand and China) kept
strict border quarantine in place for most of the pandemic. The other
three (the United Kingdom, the United States and Sweden) did not.

## Usage

``` r
covid_border
```

## Format

A data frame with 8,406 rows and 7 columns:

- country:

  Country name, as a factor.

- date:

  Date of the observation.

- cases_per_million:

  New confirmed cases per million people, as a seven-day rolling
  average.

- deaths_per_million:

  New confirmed deaths per million people, as a seven-day rolling
  average.

- vaccinated_pct:

  Share of the population fully vaccinated, in per cent. Carried forward
  between reporting dates, and zero before the rollout began.

- population:

  Country population.

- border_strategy:

  Whether the country used strict border control, as a factor with two
  levels.

## Source

Our World in Data COVID-19 dataset, licensed CC BY 4.0:
<https://docs.owid.io/projects/etl/api/covid/>. Prepared by
`data-raw/covid_border.R`.

## Examples

``` r
head(covid_border)
#> # A tibble: 6 × 7
#>   country   date       cases_per_million deaths_per_million vaccinated_pct
#>   <fct>     <date>                 <dbl>              <dbl>          <dbl>
#> 1 Australia 2020-03-01            0.0164            0                    0
#> 2 Australia 2020-03-02            0.0382            0.00545              0
#> 3 Australia 2020-03-03            0.0382            0.00545              0
#> 4 Australia 2020-03-04            0.0545            0.0109               0
#> 5 Australia 2020-03-05            0.109             0.0109               0
#> 6 Australia 2020-03-06            0.185             0.0109               0
#> # ℹ 2 more variables: population <dbl>, border_strategy <fct>
table(covid_border$country)
#> 
#>      Australia    New Zealand          China United Kingdom  United States 
#>           1401           1401           1401           1401           1401 
#>         Sweden 
#>           1401 
```
