library(tidyverse)
library(igraph)
library(tidygraph)
library(visNetwork)
library(randomcoloR)

# IO and initial processing
G <- read_graph("./Austria_highvoltage.graphml",format = "graphml")
G <- as_tbl_graph(G)
G <- G %>% 
  activate(nodes) %>%
  mutate(present_name = name)
G <- set.vertex.attribute(G, "name", value=paste("n",1:149,sep=""))
data <- toVisNetworkData(G)
num_cables <- sapply(str_split(data$edges$cables,";"),function(x) mean(as.integer(x),na.rm = T))
num_cables[is.nan(num_cables)] <- min(num_cables,na.rm = T)
data$edges$num_cables <- num_cables
num_wires <- sapply(str_split(data$edges$wires,";"),function(x) mean(as.integer(x),na.rm = T))
num_wires[is.nan(num_wires)] <- min(num_wires,na.rm = T)
data$edges$num_wires <- num_wires
data$edges$width <- data$edges$num_cables
data$edges$id <- 1:nrow(data$edges)
data$edges$group <- data$edges$operator

# extreme_nodes calc
# largest subgraphs which are complete
largest_clique <- largest_cliques(G)
data$nodes$clique <- FALSE
data$nodes$clique[unlist(largest_clique)]<- TRUE
# parts of a graph
data$nodes$component <- membership(components(G))
# cut vertices
data$nodes$articulation_points <- FALSE
data$nodes[articulation_points(G) %>% as.vector(),"articulation_points"] <- TRUE
# most far away vertices
fv<- farthest_vertices(G,weights = NULL)
data$nodes$far_points <- FALSE
data$nodes[unlist(fv$vertices) %>% as.vector(),"far_points"] <- TRUE
far_distance <- fv$distance
# shortest cycle - not interesting
# girth(G)
# maximal non-separable(no cut vertices) subgraphs - too complex
# blocks(cohesive_blocks(G))

# nodes coords
data$nodes$x <- data$nodes$lon
data$nodes$y <- data$nodes$lat

# nodes tooltip
data$nodes$title <- paste0("<p>name:",data$nodes$present_name,
                           "<br>operator:",data$nodes$operator,
                           "<br>type:",data$nodes$typ,
                           "<br>voltage:",data$nodes$voltage,"</p>")
data$edges$title <- paste0("<p>name:",data$edges$name,
                           "<br>operator:",data$edges$operator,
                           "<br>type:",data$edges$type,
                           "<br>voltage:",data$edges$voltage,"</p>")

# centrality indices calc
data$nodes$eccentricity <- eccentricity(G)
data$nodes$betweenness <- betweenness(G)
data$nodes$degree <- degree(G)
data$nodes$page_rank <- page_rank(G)$vector
data$nodes$eigen_centrality <- eigen_centrality(G)$vector
closness_vec <- lapply(1:components(G)$no, function(x){
  closeness(induced_subgraph(G,V(G)[membership(components(G))==x]))
}) %>% unlist()
data$nodes$closeness <- closness_vec[match(data$nodes$id,names(closness_vec))]
data$nodes$transitivity <- transitivity(G,"localundirected")
data$edges$betweenesss <- edge_betweenness(G)
# with weights - future development
# strength(G)

# edges attributes
# esge betweeness score
data$edges$betweenesss <- edge_betweenness(G)
# division of edges according to non-separable (no cut vertices) subgraphs
li <- biconnected_components(G)
ids <- li$component_edges %>% unlist() %>% unname()
component_size <- unlist(sapply(li$component_edges,function(x) rep(length(x),length(x))))
dfbi <- data.frame(ids,component_size) %>% arrange(ids)
bi_edge_scale <- dfbi$component_size

# communities
# clusters based on cutting highest edge-betweeness edges
ceb_community <- membership(cluster_edge_betweenness(G))
data$nodes$ceb_community <- ceb_community
# clusters based on voting
clp_community <- membership(cluster_label_prop(G))
data$nodes$clp_community <- clp_community
#score of clustering
ceb_score <- modularity(G,ceb_community)
clp_score <-modularity(G,clp_community)
# vis of clustering
# V(G)$cluster_label_prop = membership(cluster_label_prop(G))
# V(G)$color <- randomColor(max(V(G)$cluster_label_prop))[V(G)$cluster_label_prop]
# tkplot(G)
# complex - dont use
# membership(cluster_walktrap(G))
# membership(cluster_fast_greedy(G))
# membership(cluster_leading_eigen(G))
# # membership(cluster_spinglass(G)) only connected graph
# membership(cluster_infomap(G))
# membership(cluster_louvain(G))
# clusters based on maximizing modularity - takes forever
# membership(cluster_optimal(G))