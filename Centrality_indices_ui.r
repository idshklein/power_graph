shiny::tabPanel(
  title = "Centrality indices",
  fluidRow(
    column(
      width = 3,offset = 0, style='border: 4px double red;padding-right:0px;',
      selectInput("component","Component:",c("all",1:components(G)$no)),
      selectInput("centrality_index", "Centrality index:",
                  c("eccentricity","betweenness","degree","page_rank","eigen_centrality","closeness","transitivity")
                  ,selected ="eccentricity"),
      selectInput("Hcolor","High color:",c("red","green","blue"),selected = "green"),
      selectInput("Lcolor","Low color:",c("red","green","blue"),selected = "red")
    ),
    column(
      width = 8,offset = 0, style='padding:0px;',
      visNetworkOutput("centrality_indices", height = "800px")
    )
  )
)
