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
# getting an sfnetwork object
nodes <- G %>%
  activate(nodes) %>%
  as_tibble() %>%
  mutate(icon = recode(typ, "joint" = "https://upload.wikimedia.org/wikipedia/commons/4/47/Bangladesh_Power_Grid_Transmission_Line.png",
                       "substation" = "https://e7.pngegg.com/pngimages/362/402/png-clipart-electric-grid-electrical-substation-electricity-surge-arrester-electric-power-distribution-transformer-distribution-miscellaneous-industry.png",
                       "sub_station" = "https://e7.pngegg.com/pngimages/362/402/png-clipart-electric-grid-electrical-substation-electricity-surge-arrester-electric-power-distribution-transformer-distribution-miscellaneous-industry.png",
                       "merge" = "https://f0.pngfuel.com/png/527/999/power-plant-clip-art-png-clip-art.png",
                       "plant" = "https://www.kindpng.com/picc/m/88-889207_plant-vector-power-electricity-creative-generation-power-station.png")) %>% 
  st_as_sf(wkt = "wktsrid4326", crs = 4326)
edges <- G %>% 
  activate(edges) %>%  
  as_tibble() %>% 
  st_as_sf(wkt = "wktsrid4326", crs = 4326)
net <- as_sfnetwork(edges) %>% 
  activate(nodes) %>% 
  st_join(nodes,by = "wktsrid4326")

# interactive spatial visualization
m <- leaflet() %>% 
  addProviderTiles("OpenStreetMap.Mapnik") %>% 
  addPolylines(data = activate(net, "edges") %>% st_as_sf(),popup = ~name) %>% 
  addMarkers(data = activate(net, "nodes") %>% st_as_sf(),popup = ~present_name, icon = list(iconSize = c(50,50),iconUrl = ~icon))
# static spatial visualization
p <- ggplot() +
  annotation_map_tile(zoom = 7) + 
  geom_sf(data = activate(net, "edges") %>% st_as_sf(), col = 'grey50') + 
  geom_sf(data = activate(net, "nodes") %>% st_as_sf(),mapping = aes(shape= typ))
p
# graph visualization
data <- toVisNetworkData(G)
data$nodes$x = data$nodes$lon
data$nodes$y = data$nodes$lat
visNetwork(nodes = data$nodes, edges = data$edges, height = "500px") %>% 
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)

