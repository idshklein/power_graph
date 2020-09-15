shiny::tabPanel(
  title = "Basic graph manipulation",
  fluidRow(
    column(
      width = 3,offset = 0, style='border: 4px double red;padding-right:0px;',
      selectInput("Focus", "Focus on node :",
                  data$nodes$id),
      selectInput("node_color", "Nodes Color :",
                  c("blue", "red", "green")),
      selectInput("edge_color", "Edges Color :",
                  c("blue", "red", "green")),
      checkboxInput("shadow", "Shadow", FALSE),
      sliderInput("size", "Size : ", min = 10, max = 100, value = 20),
      checkboxInput("dashes", "Dashes", FALSE),
      checkboxInput("smooth", "Smooth", TRUE),
      selectInput("edge_width", "Edge width : ", 
                    c("num_cables","num_wires"))
    ),
    column(
      width = 8,offset = 0, style='padding:0px;',
      visNetworkOutput("network_basic_manipulation", height = "800px")
    )
  )
)
