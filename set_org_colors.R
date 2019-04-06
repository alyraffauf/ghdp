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
