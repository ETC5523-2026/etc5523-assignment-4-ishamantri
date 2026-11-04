# Getting started with bordercovid

## Why this package exists

Australia, New Zealand and China kept strict border quarantine in place
for most of the pandemic. The United Kingdom, the United States and
Sweden did not. Asking which approach did better sounds like a question
with one answer. It is not, and that is what this package is built to
show.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("ETC5523-2026/etc5523-assignment-4-ishamantri")
```

``` r
library(bordercovid)
```

## The data

`covid_border` holds daily case and death rates per million for the six
countries, from March 2020 to December 2023.

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
```

Rates are per million and smoothed over seven days, so countries of very
different sizes can sit on the same axis and weekend reporting gaps do
not show up as spikes.

## Summarising a period

[`summarise_period()`](https://etc5523-2026.github.io/etc5523-assignment-4-ishamantri/reference/summarise_period.md)
takes any two dates and returns one row per country, sorted by deaths
over the window.

``` r
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
```

Over the whole period the two groups are hard to separate. Now narrow it
to the first year.

``` r
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
```

The gap is enormous. New Zealand averaged around one case per million a
day while the United Kingdom averaged over a hundred.

Now take 2022 on its own.

``` r
summarise_period(from = "2022-01-01", to = "2022-12-31")
#> # A tibble: 6 × 7
#>   country        border_strategy        days mean_cases peak_cases deaths_total
#>   <fct>          <fct>                 <int>      <dbl>      <dbl>        <dbl>
#> 1 United States  Open border             365       375.      2371.        790. 
#> 2 Sweden         Open border             365       359.      3878.        652. 
#> 3 Australia      Strict border control   365      1090.      3210.        594. 
#> 4 United Kingdom Open border             365       455.      3149.        577. 
#> 5 New Zealand    Strict border control   365      1084.      3999.        443. 
#> 6 China          Strict border control   365       144.      4127.         27.3
#> # ℹ 1 more variable: vaccinated_end <dbl>
```

The ranking inverts. Australia and New Zealand record the highest mean
case rates of all six countries.

## What that means

Strict border control did not stop the wave, it moved it. Those
countries delayed their first large outbreak until vaccination coverage
was high, which is why their death totals stay low even in the window
where their case rates are highest. Reading a single window and calling
it the answer gets it wrong in one direction or the other.

## Exploring it directly

``` r
run_app()
```

The app has a date range, a choice of cases or deaths, and country
checkboxes. Moving the date range is the thing worth doing: the plot,
the table and the written reading underneath all update together, and
the verdict at the top reverses between the 2020 and 2022 windows.
