output$communities <- renderVisNetwork({
  visNetwork(nodes = data$nodes, edges = data$edges, height = "500px")%>%
    visNodes(color = "blue", size = 20)
})
output$community_score <- renderUI({
  HTML(paste("<b>", "Modularity score:", "</b>",ifelse(input$community_type == "ceb_community",ceb_score,clp_score)))
})
observe({
  present <- data$nodes
  present$color <- randomColor(max(present[,input$community_type]))[present[,input$community_type]]
  print(input$community_type)
  print(present[,input$community_type])
  print(present$color)
  visNetworkProxy("communities") %>%
    visRemoveNodes(present) %>% 
    visUpdateNodes(present)
})