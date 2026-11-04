#' Summarise COVID-19 outcomes between two dates
#'
#' Returns case and death numbers for each country over a chosen date range.
#' Which period gets picked makes a big difference to how the countries
#' compare, so the dates are set directly rather than the function assuming
#' one.
#'
#' @param data A data frame shaped like [covid_border]. Defaults to
#'   [covid_border].
#' @param from Start date. A `Date` or a string like `"2021-06-01"`.
#'   Defaults to the first date in the data.
#' @param to End date. Defaults to the last date in the data.
#' @param countries Country names to keep. Defaults to `NULL`, which keeps
#'   all of them.
#'
#' @return A tibble, one row per country, with:
#'   * `country` and `border_strategy`
#'   * `days` - how many days of data fell in the window
#'   * `mean_cases` and `peak_cases` - daily cases per million
#'   * `deaths_total` - deaths per million added up over the window
#'   * `vaccinated_end` - vaccination coverage on the last day
#'
#'   Sorted by `deaths_total`, highest first.
#'
#' @examples
#' # everything
#' summarise_period()
#'
#' # first year, before any vaccines
#' summarise_period(from = "2020-03-01", to = "2020-12-31")
#'
#' # Australia and NZ during the Omicron wave
#' summarise_period(
#'   from = "2022-01-01",
#'   to = "2022-06-30",
#'   countries = c("Australia", "New Zealand")
#' )
#'
#' @importFrom rlang .data
#' @export
summarise_period <- function(data = covid_border,
                             from = min(data$date),
                             to = max(data$date),
                             countries = NULL) {

  from <- as.Date(from)
  to   <- as.Date(to)

  if (is.na(from) || is.na(to)) {
    stop("`from` and `to` must be valid dates.", call. = FALSE)
  }

  if (from > to) {
    stop("`from` must be on or before `to`.", call. = FALSE)
  }

  if (!is.null(countries)) {
    unknown <- setdiff(countries, levels(data$country))
    if (length(unknown) > 0) {
      stop(
        "These are not in the data: ", paste(unknown, collapse = ", "),
        call. = FALSE
      )
    }
    data <- dplyr::filter(data, .data$country %in% countries)
  }

  out <- data |>
    dplyr::filter(.data$date >= from, .data$date <= to) |>
    dplyr::group_by(.data$country, .data$border_strategy) |>
    dplyr::summarise(
      days           = dplyr::n(),
      mean_cases     = round(mean(.data$cases_per_million, na.rm = TRUE), 1),
      peak_cases     = round(max(.data$cases_per_million, na.rm = TRUE), 1),
      deaths_total   = round(sum(.data$deaths_per_million, na.rm = TRUE), 1),
      vaccinated_end = round(dplyr::last(.data$vaccinated_pct), 1),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$deaths_total))

  out <- droplevels(out)

  if (nrow(out) == 0) {
    warning("No data falls in that date range.", call. = FALSE)
  }

  out
}
