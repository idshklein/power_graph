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
source("spatial.R", local = TRUE, encoding = "UTF-8")
ui <- shinyUI(navbarPage(
  title = "Examples",
  source("Basic_graph_manipulation_ui.R", local = TRUE)$value,
  source("Extreme_nodes_ui.R", local = TRUE)$value,
  source("Centrality_indices_ui.R", local = TRUE)$value,
  source("Communities_ui.R", local = TRUE)$value
))
server = shinyServer(function(input, output) {
  # source("spatial.R", local = TRUE, encoding = "UTF-8")
  source("Basic_graph_manipulation_server.R", local = TRUE, encoding = "UTF-8")
  source("Extreme_nodes_server.R", local = TRUE, encoding = "UTF-8")
  source("Centrality_indices_server.R", local = TRUE, encoding = "UTF-8")
  source("Communities_server.R", local = TRUE, encoding = "UTF-8")
})


shinyApp(ui = ui, server = server)