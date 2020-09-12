library(tidyverse)
library(igraph)
library(tidygraph)
library(sfnetworks)
library(ggraph)
library(ggspatial)
library(sf)
library(leaflet)
library(visNetwork)
# IO and initial processing
G <- read_graph("D:/blavatnik/dash_example/Power_grids-v1.0.0/ComplexNetTSP-Power_grids-415a65f/Countries/Austria/graphml/Austria_highvoltage.graphml",format = "graphml")
G <- as_tbl_graph(G)
G <- G %>% 
  activate(nodes) %>%
  mutate(present_name = name)
G <- set.vertex.attribute(G, "name", value=paste("n",1:149,sep=""))
clusters(G)
H <- induced_subgraph(G,names(components(G)$membership[components(G)$membership == 1]))
IJ <- induced_subgraph(G,names(components(G)$membership[components(G)$membership == 2]))
vertex_connectivity(H)
vertex_connectivity(IJ)
apply(t(combn(names(V(H)),2)),1,function(x) print(paste(x[1],x[2],vertex_connectivity(G,x[1],x[2]))))

vertex_connectivity(G,"n1","n43")
are_adjacent(G,"n1","n44")

which.min(eccentricity(H))
visNetwork(G)
