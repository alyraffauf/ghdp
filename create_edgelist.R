# Import Dataset with Attributes
org_links <- read.csv("global-health-references.csv", stringsAsFactors = F)
attributes <- read.csv("attributes.csv", stringsAsFactors = F)

# Join Dataset with Attributes

## Create Funding-to-Funding Edgelist
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

## Create Country-to-Country Edgelist
symbol_country = sqldf("SELECT b.Country as symbol_country
                       FROM org_links a
                       INNER JOIN attributes b ON(a.Symbol= b.Name)")
referent_country = sqldf("SELECT b.Country as referent_country
                         FROM org_links a
                         INNER JOIN attributes b ON(a.Referent= b.Name)")

country_edgelist <- merge(symbol_country, referent_country, by.symbol_country = 0, by.referent_country = res)
head(country_edgelist)
country_edgelist <- as.matrix(country_edgelist)
countryNetwork <- graph.edgelist(country_edgelist, directed=T)

### Get Vertex Degree based on number of Edges
country_vertex_degree <- (degree(countryNetwork))/3000
country_labelcex <- (0.025 * V(countryNetwork)$vertex_degree)

### Create Edgelist with only Unique Edges
country_edgelist <- unique( country_edgelist[ , 1:2 ] )

### Remove cases where Symbol and Referent are the same.
country_edgelist <- country_edgelist[country_edgelist[, "symbol_country"] != country_edgelist[, "referent_country"],]

countryNetwork <- graph.edgelist(country_edgelist, directed=T)

### Set Vertex Degree in Deduplicated Network
V(countryNetwork)$vertex_degree <- country_vertex_degree
V(countryNetwork)$label.cex <- country_labelcex

## Create Region-to-Region Edgelist
symbol_region = sqldf("SELECT b.Region as symbol_region
                      FROM org_links a
                      INNER JOIN attributes b ON(a.Symbol= b.Name)")
referent_region = sqldf("SELECT b.Region as referent_region
                        FROM org_links a
                        INNER JOIN attributes b ON(a.Referent= b.Name)")

region_edgelist<- merge(symbol_region, referent_region, by.symbol_region = 0, by.referent_region = res)
head(region_edgelist)
region_edgelist <- as.matrix(region_edgelist)
regionNetwork <- graph.edgelist(region_edgelist, directed=T)

### Get Vertex Degree based on number of Edges
region_vertex_degree <- (degree(regionNetwork))/3000
region_labelcex <- (0.025 * V(regionNetwork)$vertex_degree)

### Create Edgelist with only Unique Edges
region_edgelist <- unique( region_edgelist[ , 1:2 ] )

### Remove cases where Symbol and Referent are the same.
region_edgelist <- region_edgelist[region_edgelist[, "symbol_region"] != region_edgelist[, "referent_region"],]

regionNetwork <- graph.edgelist(region_edgelist, directed=T)

#### Set Vertex Degree in Deduplicated Network
V(regionNetwork)$vertex_degree <- region_vertex_degree
V(regionNetwork)$label.cex <- region_labelcex

## Create Income-to-Income Edgelist
symbol_income = sqldf("SELECT b.Income as symbol_income
                      FROM org_links a
                      INNER JOIN attributes b ON(a.Symbol= b.Name)")
referent_income = sqldf("SELECT b.Income as referent_income
                        FROM org_links a
                        INNER JOIN attributes b ON(a.Referent= b.Name)")

income_edgelist<- merge(symbol_income, referent_income, by.symbol_income = 0, by.referent_income = res)
head(income_edgelist)
income_edgelist <- as.matrix(income_edgelist)
incomeNetwork <- graph.edgelist(income_edgelist, directed=T)

## Create Base Org-to-Org Edgelist
org_links <- as.matrix(org_links)
orgNetwork <- graph.edgelist(org_links, directed=T)