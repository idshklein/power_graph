output$extreme_nodes <- renderVisNetwork({
  path_click()
  # visNetwork(nodes = data$nodes, edges = data$edges, height = "500px")%>%
  #   visNodes(color = "blue", size = 20)
})
path_click <- reactive({
  # shortest path calculator
  origin <- input$origin_node
  destination <- input$destination_node
  query_node <- input$query_node
  path_num <- as.integer(input$path_num)
  dict <- c("number of wires" = "num_wires","number of cables"="num_cables")
  # weight <- ifelse(input$edge_weight == "Nothing",1,data$edges[,dict[input$edge_weight]])
  if(input$edge_weight == "Nothing"){
    data$edges$weight  <- 1  
  }else{
    data$edges$weight <- 1/data$edges[,dict[input$edge_weight]]
  }
  # data$edges$weight <- ifelse(input$edge_weight == "Nothing",1,data$edges[,dict[input$edge_weight]])
  print(data$edges$weight)
  path_type <- input$path_type
  if(path_type == "Shortest paths"){
    sp <- all_shortest_paths(G,origin,destination)$res
    number_of_paths <- length(sp)
    selected_path <- sp[[path_num]]
  }else if(path_type == "All paths"){
    ap <- all_simple_paths(G,origin,destination)
    number_of_paths <- length(ap)
    selected_path <- ap[[path_num]]
  }else{
    
  }
  updateSelectInput(
    session,
    "path_num",
    choices = 1:number_of_paths,
    selected = path_num
  )
  color_of_query_node <- query_node %in% names(selected_path)
  data$edges$color <- "#D3D3D3"
  q <- data.frame(from = as.character(names(selected_path)[1:(length(selected_path)-1)]),
                  to = as.character(names(selected_path)[2:length(selected_path)]),color = "green")
  data$edges <- left_join(data$edges,q,by = c("from" = "from","to" = "to")) %>% 
    left_join(q,by = c("from" = "to","to" = "from"))
  data$edges$color <- ifelse(is.na(data$edges$color.y) & is.na(data$edges$color),data$edges$color.x,"green")
  data$nodes$color <- "#D3D3D3"
  data$nodes[data$nodes$id == origin,"color"] <- "blue"
  data$nodes[data$nodes$id == destination,"color"] <- "yellow"
  data$nodes[data$nodes$id == query_node,"color"] <- ifelse(color_of_query_node,"purple","red")
  data$nodes$x <- data$nodes$lon
  data$nodes$y <- data$nodes$lat
  print(names(selected_path))
  print(selected_path)
  visNetwork(nodes = data$nodes, edges = data$edges, height = "500px")
  # visNetworkProxy("extreme_nodes") %>%
  #   visRemoveEdges(data$edges) %>%
  #   visUpdateEdges(data$edges) %>%
  #   visRemoveNodes(data$nodes) %>%
  #   visUpdateNodes(data$nodes)
})