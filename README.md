# Global Health NGO Social Network Visualization

##### Alexandra Chace

##### 9 May 2019

## Executing Program

You can open the R project file in R Studio, the development environment for R programs. Just double-click on `Global Health NGO Social Network.rproj` after installing R and R Studio.
- [Free version of R Studio](https://www.rstudio.com/products/rstudio/download/).
- [R itself](https://cran.rstudio.com/).

Before executing this program, open up the `main.R` file in R Studio after you've loaded the project file. On the lower right, there should be a files panel available. Navigate to the folder where the program files are located. Hit "More" -> Select "Set as Working Directory". This makes sure the program knows where to find our data files.

To actually run the program, check the menu bar for 'Code'. Go to Code -> Source. This should run the program and create a series of PDFs in the working directory. If there are any previous PDFs in that directory, it may overwrite them.

## Raw Data Files

### global-health-references.csv

| Symbol     | Referent                            |
| ---------- | ----------------------------------- |
| Task Force | CHAMPS                              |
| Task Force | Gates Foundation                    |
| Task Force | PIVI Partners                       |
| Task Force | Mectizan                            |
| Task Force | Global Partnership for Zero Leprosy |

This file indicates connections between websites, i.e. which symbol (website) links out to another website (the referent). 

### attributes.csv

| Name                                           | Funding | Country       | Region        | Income |
| ---------------------------------------------- | ------- | ------------- | ------------- | ------ |
| Aeras                                          | NGO     | United States | North America | High   |
| African Field Epidemiology Network             | NGO     | United States | North America | High   |
| African Institute for Health &   Development   | NGO     | United States | North America | High   |
| African Programme for Onchocerciasis   Control | NGO     | United States | North America | High   |
| Agence de Médecine Préventive                  | NGO     | United States | North America | High   |
| Alliance Against Leprosy                       | NGO     | United States | North America | High   |
| Alter Vida                                     | NGO     | United States | North America | High   |

This is a simple dictionary file that contains data on each of our organizations: type of funding, country of origin, region of origin, and the income level of the country of origin. Ideally, in the future this could simply be reduces to name, type of funding, and country of origin, and countries would be linked to regions and incomes in another attributes file for easier editing and additions to the data.

## Dependencies

The R program depends on two external tools in order to manipulate the data and draw the graphs. These are easily installed in R itself.

- igraph (allows us to write the graph)
- sqldf (lets us interact with the data via SQL, which makes merging attributes much easier)

These should install and load themselves, but may require some user prompting for updates and initial installation. Here is the code that installs and loads these libraries:

```R
# Load Dependencies
## Make sure packages are installed and up-to-date.
install.packages("igraph")
install.packages("sqldf")

## Load packages so we can use them in our code.
library(igraph)
library(sqldf)
```

## Creating Edgelists

The program begins by constructing a list of edges (lines) and corresponding vertices (nodes on the graph). Lines are directional, pointing to a connection between one circular vertex (with accompanying label) to another. Several different edgelist variations are built:

1. Symbol-to-Referent (i.e. website-to-website, this is quite a large and confusing graph).

   1. Vertices colored by country of origin.

   2. Vertices colored by funding.
   3. Vertices colored by region.
   4. Vertices colored by income.
2. Attribute-to-Attribute.

   1. Country-to-country (vertices are countries, vertex size is determined by number of countries with origin in that country, and links between vertices show link between any of their NGOs with another country's NGOs).
   2. Region-to-Region.

### Joining Data

#### Attribute-to-Attribute Graphs

For all attribute-to-attribute edgelists, the data from both CSV files is combined through a series of SQL database operations:

```R
# Create Funding-to-Funding Edgelist

symbol_funding = sqldf("SELECT b.Funding as symbol_funding
                       FROM org_links a
                       INNER JOIN attributes b ON(a.Symbol= b.Name)")
referent_funding = sqldf("SELECT b.Funding as referent_funding
                         FROM org_links a
                         INNER JOIN attributes b ON(a.Referent= b.Name)")

funding_edgelist<- merge(symbol_funding, referent_funding, by.symbol_funding = 0, by.referent_funding = res)
head(funding_edgelist)
funding_edgelist <- as.matrix(funding_edgelist)
fundingNetwork <- graph.edgelist(funding_edgelist, directed=T)
```

In this case, the joined data is known as funding_edgelist in matrix form. This matrix is then converted into an edgelist for our graph, but the raw data looks like this:

| symbol_funding | referent_funding |
| -------------- | ---------------- |
| NGO            | NGO              |
| NGO            | NGO              |
| NGO            | UNI              |
| NGO            | NGO              |
| NGO            | CORP             |
| NGO            | NGO              |

There are lots of duplicates in this file, which are later deduplicated to make the graph more coherent. The duplicates arise because the symbol and referent websites are replaced with their funding type, but aren't necessary to show connections on our graph (and actually make it very hard to open and cumbersome to read).

#### Symbol-to-Referent Graphs

For these graphs, the process is much, much simpler. Each attribute is imported as a variable attached to each entry in the imported CSV file:

```R
## Read the attribute data into their counterparts in the orgNetwork
for (x in 1:nrow(attributes)) {
  V(orgNetwork)[(attributes[, "Name"][x])]$Funding <- attributes[, "Funding"][x]
  V(orgNetwork)[(attributes[, "Name"][x])]$Region <- attributes[, "Region"][x]
  V(orgNetwork)[(attributes[, "Name"][x])]$Country <- attributes[, "Country"][x]
  V(orgNetwork)[(attributes[, "Name"][x])]$Income <- attributes[, "Income"][x]
}
```



## Setting Colors

Vertices are colored differently on Symbol-to-Referent graphs based on their attributes. For example, the following code sets the color for Symbol-to-Referent graphs colored by funding:

```R
V(orgNetwork)$funding_color <- NA
V(orgNetwork)$funding_color <- ifelse(V(orgNetwork)$Funding == "NGO", "burlywood1", "chocolate")
V(orgNetwork)$funding_color <- ifelse(V(orgNetwork)$Funding == "GOV", "seagreen", V(orgNetwork)$funding_color)
V(orgNetwork)$funding_color <- ifelse(V(orgNetwork)$Funding == "UNI", "tomato", V(orgNetwork)$funding_color)
V(orgNetwork)$funding_color <- ifelse(V(orgNetwork)$Funding == "CORP", "chocolate1", V(orgNetwork)$funding_color)

```

Unfortunately, these have to be manually entered for now. [Here](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf) is a list of colors available in R. Because colors are hard-coded for now, you should be mindful that if you add new countries to the data file, you will need to add new color declarations in order for those to be distinguished on the graphs. Here is the code for country colors:

```R
V(orgNetwork)$country_color <- NA
V(orgNetwork)$country_color <- ifelse(V(orgNetwork)$Country == "United States", "burlywood1", "chocolate")
V(orgNetwork)$country_color <- ifelse(V(orgNetwork)$Country == "United Kingdom", "seagreen", V(orgNetwork)$country_color)
V(orgNetwork)$country_color <- ifelse(V(orgNetwork)$Country == "Hati", "tomato", V(orgNetwork)$country_color)
V(orgNetwork)$country_color <- ifelse(V(orgNetwork)$Country == "Mexico", "chocolate1", V(orgNetwork)$country_color)
```

New countries can be added by inserting a new addition to this list of declarations. For example:

```R
V(orgNetwork)$country_color <- ifelse(V(orgNetwork)$Country == "Costa Rica", "aquamarine3", V(orgNetwork)$country_color)
```

## Layouts

There are several options available in terms of algorithms for laying out vertices and edges on the graph, each with their own set of advantages. Some are better at showing centrality and connection (i.e. the most-connected vertices would be in the center, and clusters of vertices would be closer to one another), while others are better at fitting a large number of vertices on the graph with minimal overlap.

For now, I am using the [Fruchterman-Reingold](https://wiki.cns.iu.edu/pages/viewpage.action?pageId=1704110) algorithm:

```R
# This is our layout - a variety of layouts could be used, 
# but this one works well for the most part.
layout <- layout.fruchterman.reingold(orgNetwork, dim=2)
```

Layouts are not exactly reproducible because of how the algorithm makes real-time decisions about vertex and edge placement. That means that if you have a particularly nice looking arrangement, you may want to back that PDF up before re-executing the program.

Be aware that for Attribute-to-Attribute graphs, the layout is defined inside the `plot()` function:

```R
layout=layout.fruchterman.reingold(incomeNetwork, dim=2),
```

## Plotting Graphs

### Symbol-to-Referent Graphs

By changing he variable `graph_name` passed to the `color_plot_network()` function, you can change the title text printed on the graphs.

```R
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
```

### Attribute-to-Attribute Graphs

For these, the title text needs to be changed manually. The function `mtext()` determined what text is printed to the graph. In the following example, it simply writes "country-to-country" in the top center of the PDF.

```R
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
```

