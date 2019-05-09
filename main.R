# Load Dependencies
## Make sure packages are installed and up-to-date.
install.packages("igraph")
install.packages("sqldf")

## Load packages so we can use them in our code.
library(igraph)
library(sqldf)

source("create_edgelist.R")

# Convert Attributes to Matrix
## Makes it easier for us to work with.
attributes <- as.matrix(attributes)

## Read the attribute data into their counterparts in the orgNetwork
for (x in 1:nrow(attributes)) {
  V(orgNetwork)[(attributes[, "Name"][x])]$Funding <- attributes[, "Funding"][x]
  V(orgNetwork)[(attributes[, "Name"][x])]$Region <- attributes[, "Region"][x]
  V(orgNetwork)[(attributes[, "Name"][x])]$Country <- attributes[, "Country"][x]
  V(orgNetwork)[(attributes[, "Name"][x])]$Income <- attributes[, "Income"][x]
}

# Set color codes for Orgs
source("set_org_colors.R")

# This is our layout - a variety of layouts could be used, 
# but this one works well for the most part.
layout <- layout.fruchterman.reingold(orgNetwork, dim=2)

# Set the size of our vertices (nodes on the graph) and our labels 
# based on their connections
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
       layout=layout,
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

color_plot_network("symbol-to-referent with color by funding", V(orgNetwork)$funding_color)
color_plot_network("symbol-to-referent with color by region", V(orgNetwork)$region_color)
color_plot_network("symbol-to-referent with color by country", V(orgNetwork)$country_color)
color_plot_network("symbol-to-referent with color by income", V(orgNetwork)$income_color)

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

# Write Funding-to-Funding PDF
pdf_name = paste("funding-to-funding", ".pdf", sep="")
pdf(pdf_name, height=8.5, width=11)
plot(fundingNetwork, 
     margin = 0,
     curved=TRUE,
     layout=layout.fruchterman.reingold(fundingNetwork, dim=2),
     # mark.groups = ngoMultiGroup,
     
     vertex.size = V(fundingNetwork)$vertex_degree, 
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
mtext("funding-to-funding")
dev.off()

# Write income-to-income PDF
pdf_name = paste("income-to-income", ".pdf", sep="")
pdf(pdf_name, height=8.5, width=11)
plot(incomeNetwork, 
     margin = 0,
     curved=TRUE,
     layout=layout.fruchterman.reingold(incomeNetwork, dim=2),
     # mark.groups = ngoMultiGroup,
     
     vertex.size = V(incomeNetwork)$vertex_degree, 
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
mtext("income-to-income")
dev.off()
