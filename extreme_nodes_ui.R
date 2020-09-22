shiny::tabPanel(
  title = "Extreme nodes",
  fluidRow(
    column(
      width = 3,offset = 0, style='border: 4px double red;padding-right:0px;',
      selectInput("extreme_metric","Metric:",c("clique","articulation_points","far_points"))
    ),
    column(
      width = 8,offset = 0, style='padding:0px;',
      visNetworkOutput("extreme_nodes", height = "800px")
    )
  )
)
