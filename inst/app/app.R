#packages

library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(DT)
library(bordercovid)

#colours - blues for strict border, oranges for open border
#so the two groups separate visually

country_cols <- c(
  "Australia"      = "#1B4965",
  "New Zealand"    = "#2A7F9E",
  "China"          = "#62B6CB",
  "United Kingdom" = "#A63A1E",
  "United States"  = "#D4663B",
  "Sweden"         = "#E8A87C"
)

all_countries <- levels(covid_border$country)
date_min <- min(covid_border$date)
date_max <- max(covid_border$date)

#UI

ui <- page_sidebar(

  title = "Did closing the border work?",

  theme = bs_theme(
    version = 5,
    bg = "#FDFCFA",
    fg = "#232323",
    primary = "#1B4965",
    base_font = font_google("Source Sans 3"),
    heading_font = font_google("Source Sans 3")
  ),

  sidebar = sidebar(
    width = 330,

    h5("Who this is for"),
    p(class = "small",
      "A public health student trying to work out whether strict border",
      "control actually reduced COVID-19 cases and deaths - and running",
      "into the problem that different sources seem to disagree."),

    h5("The question"),
    p(class = "small",
      "How do case and mortality rates in strict-border countries compare",
      "with open-border ones, and how much does that comparison change",
      "depending on which period is examined?"),

    hr(),

    dateRangeInput(
      "dates",
      "Period to examine",
      start  = date_min,
      end    = date_max,
      min    = date_min,
      max    = date_max,
      format = "dd M yyyy"
    ),

    selectInput(
      "metric",
      "Measure",
      choices = c(
        "Daily cases per million"  = "cases_per_million",
        "Daily deaths per million" = "deaths_per_million"
      )
    ),

    checkboxGroupInput(
      "countries",
      "Countries",
      choices  = all_countries,
      selected = all_countries
    ),

    hr(),

    accordion(
      open = FALSE,
      accordion_panel(
        "What the numbers mean",
        p(class = "small",
          strong("Per million"), " - raw counts are useless for comparing",
          "the US with New Zealand, so everything is scaled by population."),
        p(class = "small",
          strong("Seven-day average"), " - smooths out the dips where",
          "countries did not report on weekends."),
        p(class = "small",
          strong("Deaths over window"), " - daily deaths per million added",
          "up across the selected period, so it grows with a longer window."),
        p(class = "small",
          strong("Vaccinated"), " - share of the population fully",
          "vaccinated on the last day of the window."),
        p(class = "small",
          strong("Days"), " - how many days of data fell inside the",
          "selected period."),
        p(class = "small",
          strong("Mean cases"), " and ", strong("Peak cases"), " - the",
          "average daily rate across the window, and the highest single",
          "day in it.")
      ),
      accordion_panel(
        "How to use this",
        p(class = "small",
          strong("Period to examine"), " - start with the full range, then",
          "shorten it. Try 2020 on its own, then 2022 on its own. The",
          "ranking in the table changes completely."),
        p(class = "small",
          strong("Measure"), " - switch between cases and deaths. Deaths",
          "follow cases by a few weeks, so the two do not always point the",
          "same way."),
        p(class = "small",
          strong("Countries"), " - untick any country to compare a smaller",
          "set. At least one from each group is needed for the reading",
          "underneath to work.")
      )
    )
  ),

  layout_columns(
    col_widths = c(12),

    card(
      card_header(textOutput("trend_title")),
      plotOutput("trend", height = "360px")
    ),

    card(
      card_header("Summary for the selected period"),
      DTOutput("summary")
    ),

    card(
      card_header("Reading this"),
      uiOutput("reading")
    )
  )
)

#Server

server <- function(input, output, session) {

  #one filter, shared by every output
  selected <- reactive({
    validate(
      need(length(input$countries) > 0,
           "No countries selected. Tick at least one in the sidebar.")
    )

    covid_border |>
      filter(
        country %in% input$countries,
        date >= input$dates[1],
        date <= input$dates[2]
      )
  })

  output$trend_title <- renderText({
    label <- if (input$metric == "cases_per_million") "cases" else "deaths"

    paste0(
      "Daily ", label, " per million, ",
      format(input$dates[1], "%d %b %Y"), " to ",
      format(input$dates[2], "%d %b %Y")
    )
  })
  output$trend <- renderPlot({
    d <- selected()

    validate(
      need(nrow(d) > 0,
           "No data in that date range. Try widening the period.")
    )

    ggplot(d, aes(date, .data[[input$metric]], colour = country)) +
      geom_line(linewidth = 0.6, na.rm = TRUE) +
      scale_colour_manual(values = country_cols, drop = FALSE) +
      labs(
        x = NULL,
        y = if (input$metric == "cases_per_million") {
          "Daily cases per million"
        } else {
          "Daily deaths per million"
        },
        colour = NULL,

        caption = "Our World in Data COVID-19 dataset (CC BY 4.0). Seven-day smoothed, per million population."
      ) +

      guides(colour = guide_legend(nrow = 1)) +
      theme_minimal(base_size = 13) +
    theme(
      legend.position = "bottom",
      panel.grid.minor = element_blank(),
      plot.caption = element_text(colour = "grey40", hjust = 0)
    )
  })

  output$summary <- renderDT({
    selected()

    tab <- summarise_period(
      from = input$dates[1],
      to = input$dates[2],
      countries = input$countries
    )

    datatable(
      tab,
      rownames = FALSE,
      colnames = c(
        "Country", "Border strategy", "Days",
        "Mean cases", "Peak cases", "Deaths over window", "Vaccinated %"
      ),
      options = list(dom = "t", pageLength = 10)
    )
  })

  output$reading <- renderUI({
    d <- selected()

    gaps <- d |>
      group_by(border_strategy) |>
      summarise(avg = mean(.data[[input$metric]], na.rm = TRUE),
                .groups = "drop")

    if (nrow(gaps) < 2) {
      return(p("Select countries from both groups to compare them."))
    }

    strict <- gaps$avg[gaps$border_strategy == "Strict border control"]
    open   <- gaps$avg[gaps$border_strategy == "Open border"]
    ratio  <- open / strict

    label <- if (input$metric == "cases_per_million") "cases" else "deaths"

    verdict <- if (ratio > 1.2) {
      paste0("Open-border countries fared worse over this window, by a factor of ",
             round(ratio, 1), ".")
    } else if (ratio < 0.83) {
      paste0("Strict-border countries fared worse over this window, by a factor of ",
             round(1 / ratio, 1), ".")
    } else {
      "The two groups come out almost identical over this window."
    }

    tagList(
      p(strong(verdict)),
      p(HTML(paste0(
        "Open-border countries averaged <strong>", round(open, 1),
        "</strong> daily ", label,
        " per million. Strict-border countries averaged <strong>",
        round(strict, 1), "</strong>."
      ))),
      p(class = "small text-muted",
        "This ratio is not fixed. Narrow the window to 2020 and the gap is",
        "enormous. Narrow it to 2022 and it inverts. The strict-border",
        "countries delayed their first large wave rather than avoiding one,",
        "so when the comparison is made matters as much as what is compared.")
    )
  })
}

shinyApp(ui, server)
