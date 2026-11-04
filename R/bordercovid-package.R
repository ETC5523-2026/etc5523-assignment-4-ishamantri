#' @keywords internal
"_PACKAGE"

#the dataset is used as a default argument in summarise_period(), which
#R CMD check cannot see, so it is declared here

utils::globalVariables("covid_border")

#DT, bslib and ggplot2 are used by the Shiny app in inst/app, so one
#function from each is imported to show they are needed

#' @importFrom DT datatable
#' @importFrom bslib page_sidebar
#' @importFrom ggplot2 ggplot
#' @importFrom utils globalVariables
NULL
