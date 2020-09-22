shiny::tabPanel(
  title = "Communities",
  fluidRow(
    column(
      width = 3,offset = 0, style='border: 4px double red;padding-right:0px;',
      selectInput("community_type","community type:",c("ceb_community","clp_community")),
      htmlOutput("community_score")
    ),
    column(
      width = 8,offset = 0, style='padding:0px;',
      visNetworkOutput("communities", height = "800px")
    )
  )
)
