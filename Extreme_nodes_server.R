output$extreme_nodes <- renderVisNetwork({
  # shortest path calculator
  shortest_paths(G,"n1","n47")
  all_shortest_paths(G,"n1","n50")
  # all_simple_paths - all the possibilities of getting from one node to another
  all_simple_paths(G,"n1","n20")
  # find out if node in path
  "n41" %in% names(all_simple_paths(G,"n1","n47")[[1]])
  
  
  visNetwork(nodes = data$nodes, edges = data$edges, height = "500px")%>%
    visNodes(color = "blue", size = 20) %>% 
    visOptions(selectedBy= "voltage")
})
observe({

  visNetworkProxy("network_basic_manipulation") %>%
    visRemoveEdges(data$edges) %>% 
    visUpdateEdges(data$edges) 
})