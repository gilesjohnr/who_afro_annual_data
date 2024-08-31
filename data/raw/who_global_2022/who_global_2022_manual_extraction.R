# Load necessary libraries
library(rnaturalearth)
library(sf)

# Create the dataframe for Africa
cholera_data_africa <- data.frame(
     region = rep("AFR", 17),
     country = c(
          "Benin", "Burkina Faso", "Burundi", "Cameroon",
          "Democratic Republic of the Congo", "Ethiopia", "Kenya",
          "Liberia", "Malawi", "Mozambique", "Nigeria",
          "Rwanda", "Somalia", "South Africa", "South Sudan",
          "Zambia", "Zimbabwe"
     ),
     iso_code = c(
          "BEN", "BFA", "BDI", "CMR", "COD", "ETH", "KEN",
          "LBR", "MWI", "MOZ", "NGA", "RWA", "SOM", "ZAF",
          "SSD", "ZMB", "ZWE"
     ),
     cases_total = c(
          433, 4, 25, 14431, 18961, 846, 3525, 367,
          17488, 4378, 23839, 24, 15653, 1, 424, 34, 4
     ),
     cases_imported = c(
          0, 0, 0, 15, 0, 0, 0, 0, 186, NA, 0, 0, 0, 0, 0, 0, 1
     ),
     deaths = c(
          2, 0, 0, 279, 298, 27, 64, 0, 576, 22, 597, 0, 88, 0, 1, 0, 1
     ),
     cfr = c(
          0.5, 0.0, 0.0, 1.9, 1.6, 3.2, 1.8, 0.0, 3.3, 0.5, 2.5, 0.0, 0.6, 0.0, 0.2, 0.0, 25.0
     ),
     stringsAsFactors = FALSE
)

# Create the dataframe for Asia
cholera_data_asia <- data.frame(
     region = rep("ASIA", 16),
     country = c(
          "Afghanistan", "Bahrain", "Bangladesh", "Cambodia", "China",
          "India", "Iraq", "Kuwait", "Lebanon", "Nepal",
          "Pakistan", "Philippines", "Singapore",
          "Syrian Arab Republic", "Thailand", "United Arab Emirates"
     ),
     iso_code = c(
          "AFG", "BHR", "BGD", "KHM", "CHN",
          "IND", "IRQ", "KWT", "LBN", "NPL",
          "PAK", "PHL", "SGP",
          "SYR", "THA", "ARE"
     ),
     cases_total = c(
          281485, 1, 1191, 20, 31,
          601, 3708, 1, 5715, 77,
          1006, 8098, 7,
          70222, 5, 37
     ),
     cases_imported = c(
          6, 1, NA, NA, 0,
          NA, 0, 1, 4, 0,
          0, NA, 7,
          0, 0, 37
     ),
     deaths = c(
          100, 0, NA, 0, 0,
          NA, 25, 0, 23, 0,
          43, 100, 0,
          102, 1, 0
     ),
     cfr = c(
          0.04, 0.0, NA, 0.0, 0.0,
          NA, 0.7, 0.0, 0.4, 0.0,
          4.3, 1.2, 0.0,
          0.1, 20.0, 0.0
     ),
     stringsAsFactors = FALSE
)

# Create the dataframe for Europe
cholera_data_europe <- data.frame(
     region = rep("EURO", 9),
     country = c(
          "Austria", "France", "Germany", "Greece",
          "Italy", "Netherlands", "Norway",
          "Sweden", "United Kingdom"
     ),
     iso_code = c(
          "AUT", "FRA", "DEU", "GRC",
          "ITA", "NLD", "NOR",
          "SWE", "GBR"
     ),
     cases_total = c(
          1, 7, 6, 1,
          1, 2, 3,
          7, 23
     ),
     cases_imported = c(
          1, 3, 6, 1,
          1, 2, 3,
          7, 23
     ),
     deaths = c(
          0, 0, 0, 0,
          0, 0, 0,
          0, 0
     ),
     cfr = c(
          0.0, 0.0, 0.0, 0.0,
          0.0, 0.0, 0.0,
          0.0, 0.0
     ),
     stringsAsFactors = FALSE
)

# Create the dataframe for Australia and New Zealand
cholera_data_oceania <- data.frame(
     region = rep("OCE", 2),
     country = c(
          "Australia", "New Zealand"
     ),
     iso_code = c(
          "AUS", "NZL"
     ),
     cases_total = c(
          3, 1
     ),
     cases_imported = c(
          2, 1
     ),
     deaths = c(
          0, 0
     ),
     cfr = c(
          0.0, 0.0
     ),
     stringsAsFactors = FALSE
)

# Combine the Africa, Asia, Europe, and Oceania dataframes
cholera_data <- rbind(cholera_data_africa, cholera_data_asia, cholera_data_europe, cholera_data_oceania)

# Replace "NR" and "--" with NA
cholera_data$cases_imported[cholera_data$cases_imported == "NR" | cholera_data$cases_imported == "--"] <- NA
cholera_data$deaths[cholera_data$deaths == "NR" | cholera_data$deaths == "--"] <- NA
cholera_data$cfr[cholera_data$cfr == "NR" | cholera_data$cfr == "--"] <- NA

cholera_data$year <- 2022

# Download the global country shapefile
world <- ne_countries(scale = "medium", returnclass = "sf")

# Extract the country names from the shapefile
shapefile_countries <- world$name_long

# Check for mismatches between your data and the shapefile
mismatches <- cholera_data$country[!(cholera_data$country %in% shapefile_countries)]

# Print mismatches
if (length(mismatches) == 0) {
     print("All country names match the shapefile.")
} else {
     print("Mismatched country names:")
     print(mismatches)
}

# View the combined dataframe
print(cholera_data)

write.csv(cholera_data, file=file.path(getwd(), "data/who_global_annual/raw/who_global_2022/who_global_2022.csv"), row.names = FALSE)
