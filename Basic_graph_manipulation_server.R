output$network_basic_manipulation <- renderVisNetwork({
  visNetwork(nodes = data$nodes, edges = data$edges, height = "500px")%>%
    visNodes(color = "blue", size = 20)
})

observe({
  visNetworkProxy("network_basic_manipulation") %>%
    visNodes(color = input$color, size = input$size, shadow = input$shadow) %>%
    visEdges(dashes = input$dashes, smooth = input$smooth)
})