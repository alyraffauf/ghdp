#installing packages and libraries

library(igraph)
library(sqldf)

source("create_edgelist.R")

## Convert Attributes to Matrix
attributes <- as.matrix(attributes)

for (x in 1:nrow(attributes)) {
  print((attributes[, "Name"][x]))
  V(orgNetwork)[(attributes[, "Name"][x])]$Funding <- attributes[, "Funding"][x]
  V(orgNetwork)[(attributes[, "Name"][x])]$Region <- attributes[, "Region"][x]
  V(orgNetwork)[(attributes[, "Name"][x])]$Country <- attributes[, "Country"][x]
  V(orgNetwork)[(attributes[, "Name"][x])]$Income <- attributes[, "Income"][x]
}

V(orgNetwork)$funding_color <- NA
V(orgNetwork)$funding_color <- ifelse(V(orgNetwork)$Funding == "NGO", "burlywood1", "chocolate")
V(orgNetwork)$funding_color <- ifelse(V(orgNetwork)$Funding == "GOV", "seagreen", V(orgNetwork)$funding_color)
V(orgNetwork)$funding_color <- ifelse(V(orgNetwork)$Funding == "UNI", "tomato", V(orgNetwork)$funding_color)
V(orgNetwork)$funding_color <- ifelse(V(orgNetwork)$Funding == "CORP", "chocolate1", V(orgNetwork)$funding_color)

V(orgNetwork)$region_color <- NA
V(orgNetwork)$region_color <- ifelse(V(orgNetwork)$Region == "North America", "burlywood1", "chocolate")
V(orgNetwork)$region_color <- ifelse(V(orgNetwork)$Region == "Europe", "seagreen", V(orgNetwork)$region_color)
V(orgNetwork)$region_color <- ifelse(V(orgNetwork)$Region == "Asia", "tomato", V(orgNetwork)$region_color)
V(orgNetwork)$region_color <- ifelse(V(orgNetwork)$Region == "Caribbean", "chocolate1", V(orgNetwork)$region_color)

V(orgNetwork)$country_color <- NA
V(orgNetwork)$country_color <- ifelse(V(orgNetwork)$Country == "United States", "burlywood1", "chocolate")
V(orgNetwork)$country_color <- ifelse(V(orgNetwork)$Country == "United Kingdom", "seagreen", V(orgNetwork)$country_color)
V(orgNetwork)$country_color <- ifelse(V(orgNetwork)$Country == "Hati", "tomato", V(orgNetwork)$country_color)
V(orgNetwork)$country_color <- ifelse(V(orgNetwork)$Country == "Mexico", "chocolate1", V(orgNetwork)$country_color)


V(orgNetwork)$income_color <- NA
V(orgNetwork)$income_color <- ifelse(V(orgNetwork)$Income == "High", "burlywood1", "chocolate")
V(orgNetwork)$income_color <- ifelse(V(orgNetwork)$Income == "Upper-Middle", "seagreen", V(orgNetwork)$income_color)
V(orgNetwork)$income_color <- ifelse(V(orgNetwork)$Income == "Lower-Middle", "tomato", V(orgNetwork)$income_color)
V(orgNetwork)$income_color <- ifelse(V(orgNetwork)$Income == "Low", "chocolate1", V(orgNetwork)$income_color)

layout <- layout.fruchterman.reingold(orgNetwork, dim=2)

V(orgNetwork)$vertex_degree <- (degree(orgNetwork) + 10)/5
V(orgNetwork)$label.cex <- (0.025 * V(orgNetwork)$vertex_degree)

# V(orgNetwork)$label.cex <- ifelse(V(orgNetwork)$label.cex == .055, 0, 0.25 * V(orgNetwork)$label.cex)

# ngoMulti <- multilevel.community(orgNetwork)
# ngoMultiGroup <- communities(ngoMulti)

color_plot_network = function(graph_name, color) {
  pdf_name = paste(graph_name, ".pdf", sep="")
  pdf(pdf_name, height=8.5, width=11)
  plot(orgNetwork, 
       margin = 0,
       curved=TRUE,
       layout=layout_nicely,
       # mark.groups = ngoMultiGroup,
       
       vertex.size = V(orgNetwork)$vertex_degree, 
       vertex.color = color, 
       vertex.shape = "circle", 
       vertex.frame.color = "black", 
       
       vertex.label.color = "black",
       vertex.label.font = 2,
       vertex.label.degree = -pi/2,
       vertex.label.dist = 0,
       
       edge.color="black",
       edge.curved = .3, 
       edge.arrow.size = .1, 
       edge.width = .2)
  mtext(graph_name)
  dev.off()
}

color_plot_network("group-to-group with color by funding", V(orgNetwork)$funding_color)
color_plot_network("group-to-group with color by region", V(orgNetwork)$region_color)
color_plot_network("group-to-group with color by country", V(orgNetwork)$country_color)
color_plot_network("group-to-group with color by income", V(orgNetwork)$income_color)

# Write Country-to-Country PDF
pdf_name = paste("country-to-country", ".pdf", sep="")
pdf(pdf_name, height=8.5, width=11)
plot(countryNetwork, 
     margin = 0,
     curved=TRUE,
     layout=layout.fruchterman.reingold(countryNetwork, dim=2),
     # mark.groups = ngoMultiGroup,
     
     vertex.size = V(countryNetwork)$vertex_degree, 
     vertex.color = "tomato", 
     vertex.shape = "circle", 
     vertex.frame.color = "black", 
     
     vertex.label.color = "black",
     vertex.label.font = 2,
     vertex.label.degree = -pi/2,
     vertex.label.dist = 0,
     
     edge.color="black",
     edge.curved = .3, 
     edge.arrow.size = .1, 
     edge.width = .2)
mtext("country-to-country")
dev.off()

# Write Region-to-Region PDF
pdf_name = paste("region-to-region", ".pdf", sep="")
pdf(pdf_name, height=8.5, width=11)
plot(regionNetwork, 
     margin = 0,
     curved=TRUE,
     layout=layout.fruchterman.reingold(regionNetwork, dim=2),
     # mark.groups = ngoMultiGroup,
     
     vertex.size = V(regionNetwork)$vertex_degree, 
     vertex.color = "tomato", 
     vertex.shape = "circle", 
     vertex.frame.color = "black", 
     
     vertex.label.color = "black",
     vertex.label.font = 2,
     vertex.label.degree = -pi/2,
     vertex.label.dist = 0,
     
     edge.color="black",
     edge.curved = .3, 
     edge.arrow.size = .1, 
     edge.width = .2)
mtext("region-to-region")
dev.off()