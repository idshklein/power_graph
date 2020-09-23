output$network_basic_manipulation <- renderVisNetwork({
  visNetwork(nodes = data$nodes, edges = data$edges, height = "500px")%>%
    visNodes(color = "blue", size = 20) %>% 
    visOptions(selectedBy= list(variable = "typ",main = "Select by node type")) %>% 
    visInteraction(tooltipDelay = 0)
})


observe({
  visNetworkProxy("network_basic_manipulation") %>%
    visFocus(id = input$Focus, scale = 2)
})

observe({
  data$edges$color <- input$edge_color
  data$edges$width <- data$edges[,input$edge_width]
  visNetworkProxy("network_basic_manipulation") %>%
    visRemoveEdges(data$edges) %>% 
    visUpdateEdges(data$edges) 
})


observe({
  visNetworkProxy("network_basic_manipulation") %>%
    visNodes(color = input$node_color, size = input$size, shadow = input$shadow) %>%
    visEdges(dashes = input$dashes, smooth = input$smooth)
})