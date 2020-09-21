output$centrality_indices <- renderVisNetwork({
  visNetwork(nodes = data$nodes, edges = data$edges, height = "500px")%>%
    visNodes(color = "blue", size = 20) %>% 
    visInteraction(tooltipDelay = 0)
})
observe({
  if(input$component == "all"){
    present <- data$nodes  
  }else{
    present <- data$nodes[which(membership(components(G)) == as.numeric(input$component)),]  
  }
  
  # present <- data$nodes[which(membership(components(G)) == input$component),]
  f <- colorRamp(c(input$Lcolor, input$Hcolor))
  max_value <- max(present[,input$centrality_index],na.rm = T)
  colors <- rep("#888888",nrow(present))
  print(input$centrality_index)
  print(present[,input$centrality_index])
  colors[which(!is.nan(present[,input$centrality_index]))] <- 
    rgb(f(present[!is.nan(present[,input$centrality_index]),input$centrality_index]/max_value)/255)
  present$color <- colors
  visNetworkProxy("centrality_indices") %>%
    visRemoveNodes(data$nodes) %>% 
    visUpdateNodes(present)

})