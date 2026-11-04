# Summarise COVID-19 outcomes between two dates

Returns case and death numbers for each country over a chosen date
range. Which period gets picked makes a big difference to how the
countries compare, so the dates are set directly rather than the
function assuming one.

## Usage

``` r
summarise_period(
  data = covid_border,
  from = min(data$date),
  to = max(data$date),
  countries = NULL
)
```

## Arguments

- data:

  A data frame shaped like
  [covid_border](https://etc5523-2026.github.io/etc5523-assignment-4-ishamantri/reference/covid_border.md).
  Defaults to
  [covid_border](https://etc5523-2026.github.io/etc5523-assignment-4-ishamantri/reference/covid_border.md).

- from:

  Start date. A `Date` or a string like `"2021-06-01"`. Defaults to the
  first date in the data.

- to:

  End date. Defaults to the last date in the data.

- countries:

  Country names to keep. Defaults to `NULL`, which keeps all of them.

## Value

A tibble, one row per country, with:

- `country` and `border_strategy`

- `days` - how many days of data fell in the window

- `mean_cases` and `peak_cases` - daily cases per million

- `deaths_total` - deaths per million added up over the window

- `vaccinated_end` - vaccination coverage on the last day

Sorted by `deaths_total`, highest first.

## Examples

``` r
# everything
summarise_period()
#> # A tibble: 6 × 7
#>   country        border_strategy        days mean_cases peak_cases deaths_total
#>   <fct>          <fct>                 <int>      <dbl>      <dbl>        <dbl>
#> 1 United States  Open border            1401      257.       2371.       3419. 
#> 2 United Kingdom Open border            1401      260.       3149.       3404. 
#> 3 Sweden         Open border            1401      187.       3878.       2545. 
#> 4 Australia      Strict border control  1401      319.       3210.        932  
#> 5 New Zealand    Strict border control  1401      339.       3999.        706  
#> 6 China          Strict border control  1401       49.7      4127.         83.7
#> # ℹ 1 more variable: vaccinated_end <dbl>

# first year, before any vaccines
summarise_period(from = "2020-03-01", to = "2020-12-31")
#> # A tibble: 6 × 7
#>   country        border_strategy        days mean_cases peak_cases deaths_total
#>   <fct>          <fct>                 <int>      <dbl>      <dbl>        <dbl>
#> 1 United Kingdom Open border             306      115.       647.        1338. 
#> 2 United States  Open border             306      182.       639.        1009. 
#> 3 Sweden         Open border             306      133.       680.         898. 
#> 4 Australia      Strict border control   306        3.5       21.1         35.1
#> 5 New Zealand    Strict border control   306        1.1       12.8          4.9
#> 6 China          Strict border control   306        0          0.3          1.5
#> # ℹ 1 more variable: vaccinated_end <dbl>

# Australia and NZ during the Omicron wave
summarise_period(
  from = "2022-01-01",
  to = "2022-06-30",
  countries = c("Australia", "New Zealand")
)
#> # A tibble: 2 × 7
#>   country     border_strategy        days mean_cases peak_cases deaths_total
#>   <fct>       <fct>                 <int>      <dbl>      <dbl>        <dbl>
#> 1 Australia   Strict border control   181      1553.      3210.         314 
#> 2 New Zealand Strict border control   181      1404.      3999.         273.
#> # ℹ 1 more variable: vaccinated_end <dbl>
```
