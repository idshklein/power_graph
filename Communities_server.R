output$network_basic_manipulation <- renderVisNetwork({
  
  
  # communities
  
  # division of edges according to non-separable(no cut vertices) subgraphs
  biconnected_components(G)
  # clusters based on cutting highest edge-betweeness edges
  membership(cluster_edge_betweenness(G))
  # clusters based on voting
  membership(cluster_label_prop(G))
  
  membership_vector <- c()
  #score of clustering
  modularity(G,membership_vector)
  
  # vis of clustering
  # V(G)$cluster_label_prop = membership(cluster_label_prop(G))
  # V(G)$color <- randomColor(max(V(G)$cluster_label_prop))[V(G)$cluster_label_prop]
  # tkplot(G)
  
  #score of clustering
  modularity(G,membership_vector)
  
  # complex - dont use
  # membership(cluster_walktrap(G))
  # membership(cluster_fast_greedy(G))
  # membership(cluster_leading_eigen(G))
  # # membership(cluster_spinglass(G)) only connected graph
  # membership(cluster_infomap(G))
  # membership(cluster_louvain(G))
  # clusters based on maximizing modularity - takes forever
  # membership(cluster_optimal(G))
  
  
  
  
  
  visNetwork(nodes = data$nodes, edges = data$edges, height = "500px")%>%
    visNodes(color = "blue", size = 20) %>% 
    visOptions(selectedBy= "voltage")
})
