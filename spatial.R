library(tidyverse)
library(igraph)
library(tidygraph)
# library(sfnetworks)
# library(sf)
library(visNetwork)
# IO and initial processing
G <- read_graph("Austria_highvoltage.graphml",format = "graphml")
G <- as_tbl_graph(G)
G <- G %>% 
  activate(nodes) %>%
  mutate(present_name = name)
G <- set.vertex.attribute(G, "name", value=paste("n",1:149,sep=""))
# # getting an sfnetwork object
# nodes <- G %>%
#   activate(nodes) %>%
#   as_tibble() %>%
#   mutate(icon = recode(typ, "joint" = "https://upload.wikimedia.org/wikipedia/commons/4/47/Bangladesh_Power_Grid_Transmission_Line.png",
#                        "substation" = "https://e7.pngegg.com/pngimages/362/402/png-clipart-electric-grid-electrical-substation-electricity-surge-arrester-electric-power-distribution-transformer-distribution-miscellaneous-industry.png",
#                        "sub_station" = "https://e7.pngegg.com/pngimages/362/402/png-clipart-electric-grid-electrical-substation-electricity-surge-arrester-electric-power-distribution-transformer-distribution-miscellaneous-industry.png",
#                        "merge" = "https://f0.pngfuel.com/png/527/999/power-plant-clip-art-png-clip-art.png",
#                        "plant" = "https://www.kindpng.com/picc/m/88-889207_plant-vector-power-electricity-creative-generation-power-station.png")) %>% 
#   st_as_sf(wkt = "wktsrid4326", crs = 4326)
# edges <- G %>% 
#   activate(edges) %>%  
#   as_tibble() %>% 
#   st_as_sf(wkt = "wktsrid4326", crs = 4326)
# net <- as_sfnetwork(edges) %>% 
#   activate(nodes) %>% 
#   st_join(nodes,by = "wktsrid4326")
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
data$nodes$clique <- "single"
data$nodes$clique[unlist(largest_clique)]<- "clique"
# parts of a graph
data$nodes$component <- membership(components(G))
# cut vertices
data$nodes$articulation_points <- "no"
data$nodes[articulation_points(G) %>% as.vector(),"articulation_points"] <- "yes"
# most far away vertices
fv<- farthest_vertices(G,weights = NULL)
data$nodes$far_points <- "no"
data$nodes[unlist(fv$vertices) %>% as.vector(),"far_points"] <- "yes"
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

