output$network_basic_manipulation <- renderVisNetwork({
  G
  eccentricity(G)
  betweenness(G)
  edge_betweenness(G)
  degree(G)
  # closeness - only with connected graph
  closeness(induced_subgraph(G,V(G)[membership(components(G))==1]))
  page_rank(G)$vector
  eigen_centrality(G)$vector
  transitivity(G,"localundirected")
  # with weights
  strength(G)
  visNetwork(nodes = data$nodes, edges = data$edges, height = "500px")%>%
    visNodes(color = "blue", size = 20) %>% 
    visOptions(selectedBy= "voltage")
})
