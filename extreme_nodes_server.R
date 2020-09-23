output$extreme_nodes <- renderVisNetwork({
  visNetwork(nodes = data$nodes, edges = data$edges, height = "500px")%>%
    visNodes(color = list(background = "gray",border = "darkblue",highlight="yellow"), size = 40)
})
output$extreme_nodes_explanation <- renderText({
  # paste("<b> Modularity score: </b>",ifelse(input$community_type == "ceb_community",ceb_score,clp_score))
})
observe({
  present <- data$nodes
  nodes_selection <- row.names(present[present[,input$extreme_metric],])
  print(nodes_selection)
  visNetworkProxy("extreme_nodes") %>%
    visSelectNodes(nodes_selection)
})