# Launch the border comparison Shiny app

Starts the Shiny application that ships with the package. The app plots
daily cases or deaths for the selected countries and date range, and
reports how the two border strategies compare over that window.

## Usage

``` r
run_app(...)
```

## Arguments

- ...:

  Extra arguments passed on to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html), such
  as `launch.browser` or `port`.

## Value

Nothing useful is returned. The function is called for its side effect,
which is starting the app. It keeps running until stopped.

## Examples

``` r
if (interactive()) {
  run_app()
}
```
