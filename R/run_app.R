#' Launch the border comparison Shiny app
#'
#' Starts the Shiny application that ships with the package. The app plots
#' daily cases or deaths for the selected countries and date range, and
#' reports how the two border strategies compare over that window.
#'
#' @param ... Extra arguments passed on to [shiny::runApp()], such as
#'   `launch.browser` or `port`.
#'
#' @return Nothing useful is returned. The function is called for its side
#'   effect, which is starting the app. It keeps running until stopped.
#'
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
#'
#' @export
run_app <- function(...) {

  app_dir <- system.file("app", package = "bordercovid")

  if (app_dir == "") {
    stop(
      "Could not find the app. Try reinstalling bordercovid.",
      call. = FALSE
    )
  }

  shiny::runApp(app_dir, ...)
}
