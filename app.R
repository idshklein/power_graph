library(tidyverse)
library(igraph)
library(tidygraph)
library(sfnetworks)
library(ggraph)
library(ggspatial)
library(sf)
library(leaflet)
library(visNetwork)
library(shiny)

ui <- shinyUI(navbarPage(
  title = "Examples",
  source("spatial_ui2.R", local = TRUE)$value,
  source("spatial_ui.R", local = TRUE)$value,
  source("spatial_ui3.R", local = TRUE)$value
))
server = shinyServer(function(input, output) {
  source("spatial.R", local = TRUE, encoding = "UTF-8")
})


shinyApp(ui = ui, server = server)