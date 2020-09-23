shiny::tabPanel(
  title = "Shortest path",
  fluidRow(
    column(
      width = 3,offset = 0, style='border: 4px double red;padding-right:0px;',
      selectInput("origin_node", "Origin node:",
                  data$nodes$id,selected ="n1"),
      selectInput("destination_node", "Destination node:",
                  data$nodes$id,selected ="n2"),
      selectInput("query_node", "Query node:",
                  data$nodes$id,selected = "n3"),
      selectInput("path_num", "Path number:",
                  1,selected = 1),
      selectInput("edge_weight", "calculate path by:",c("Nothing","number of wires","number of cables")),
      selectInput("path_type", "Type of calculation:",c("Shortest paths","All paths"),selected="Shortest paths")#,
      # actionButton("calc_path","Calculate path")
    ),
    column(
      width = 8,offset = 0, style='padding:0px;',
      visNetworkOutput("Shortest_path", height = "800px")
    )
  )
)