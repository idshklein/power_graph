library(shiny)
source("spatial.R", local = TRUE, encoding = "UTF-8")
ui <- shinyUI(navbarPage(
  title = "Examples",
  source("Basic_graph_manipulation_ui.R", local = TRUE)$value,
  source("Shortest_path_ui.R", local = TRUE)$value,
  source("Centrality_indices_ui.R", local = TRUE)$value,
  source("Communities_ui.R", local = TRUE)$value,
  source("extreme_nodes_ui.R", local = TRUE)$value
))
server = shinyServer(function(input, output,session) {
  # source("spatial.R", local = TRUE, encoding = "UTF-8")
  source("Basic_graph_manipulation_server.R", local = TRUE, encoding = "UTF-8")
  source("Shortest_path_server.R", local = TRUE, encoding = "UTF-8")
  source("Centrality_indices_server.R", local = TRUE, encoding = "UTF-8")
  source("Communities_server.R", local = TRUE, encoding = "UTF-8")
  source("extreme_nodes_server.R", local = TRUE, encoding = "UTF-8")
})


shinyApp(ui = ui, server = server)