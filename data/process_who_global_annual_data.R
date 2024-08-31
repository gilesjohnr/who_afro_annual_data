################################################################################
# Process global annual cholera data from 1949 to 2021 (precollated by OWiD)
################################################################################

afro_iso_codes <- c(
     "DZA", "AGO", "BEN", "BWA", "BFA", "BDI", "CPV", "CMR", "CAF", "TCD",
     "COM", "COG", "COD", "CIV", "GNQ", "ERI", "SWZ", "ETH", "GAB", "GMB",
     "GHA", "GIN", "GNB", "KEN", "LSO", "LBR", "MDG", "MWI", "MLI", "MRT",
     "MUS", "MOZ", "NAM", "NER", "NGA", "RWA", "STP", "SEN", "SYC", "SLE",
     "SOM", "ZAF", "SSD", "TGO", "UGA", "TZA", "ZMB", "ZWE"
)

cholera_cases <- read.csv(file.path(getwd(), "data/raw/who_global_1949_2021/number-reported-cases-of-cholera.csv"), stringsAsFactors = FALSE)
cholera_deaths <- read.csv(file.path(getwd(), "data/raw/who_global_1949_2021/number-of-reported-cholera-deaths.csv"), stringsAsFactors = FALSE)

cholera_cases_afr <- cholera_cases[cholera_cases$Code %in% afro_iso_codes, ]

colnames(cholera_cases_afr)[colnames(cholera_cases_afr) == "Year"] <- "year"
colnames(cholera_cases_afr)[colnames(cholera_cases_afr) == "Entity"] <- "country"
colnames(cholera_cases_afr)[colnames(cholera_cases_afr) == "Code"] <- "iso_code"
colnames(cholera_cases_afr)[colnames(cholera_cases_afr) == "Reported.cholera.cases"] <- "cases_total"

cholera_cases_afr$region <- "AFR0"
cholera_cases_afr$cases_imported <- NA
cholera_cases_afr$cfr <- NA

cholera_deaths_afr <- cholera_deaths[cholera_deaths$Code %in% afro_iso_codes, ]

colnames(cholera_deaths_afr)[colnames(cholera_deaths_afr) == "Year"] <- "year"
colnames(cholera_deaths_afr)[colnames(cholera_deaths_afr) == "Entity"] <- "country"
colnames(cholera_deaths_afr)[colnames(cholera_deaths_afr) == "Code"] <- "iso_code"
colnames(cholera_deaths_afr)[colnames(cholera_deaths_afr) == "Reported.cholera.deaths"] <- "deaths_total"

cholera_data_1949_2021 <- merge(cholera_cases_afr,
                                cholera_deaths_afr[, c("country", "year", "iso_code", "deaths_total")],
                                by = c("country", "iso_code", "year"), all.x = TRUE)

cholera_data_1949_2021 <- cholera_data_1949_2021[,c("region", "country", "iso_code", "year", "cases_total", "cases_imported", "deaths_total", "cfr")]

cholera_data_1949_2021$cfr <- cholera_data_1949_2021$deaths_total / cholera_data_1949_2021$cases_total
cholera_data_1949_2021$cfr[is.nan(cholera_data_1949_2021$cfr)] <- NA


write.csv(cholera_data_1949_2021, file=file.path(getwd(), "data/processed/who_afro_annual_1949_2021.csv"), row.names = FALSE)




################################################################################
# Process global annual cholera data from 2022
################################################################################

cholera_data_2022 <- data.frame(
     region = rep("AFR0", 17),
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
     deaths_total = c(
          2, 0, 0, 279, 298, 27, 64, 0, 576, 22, 597, 0, 88, 0, 1, 0, 1
     ),
     cfr = c(
          0.5, 0.0, 0.0, 1.9, 1.6, 3.2, 1.8, 0.0, 3.3, 0.5, 2.5, 0.0, 0.6, 0.0, 0.2, 0.0, 25.0
     ),
     stringsAsFactors = FALSE
)

cholera_data_2022$year <- 2022
cholera_data_2022$cfr <- cholera_data_2022$cfr / 100


write.csv(cholera_data_2022, file=file.path(getwd(), "data/processed/who_afro_annual_2022.csv"), row.names = FALSE)






################################################################################
# Process global annual cholera data from 2023 and 2024
################################################################################

url <- "https://who.maps.arcgis.com/sharing/rest/content/items/3aa7bfec5da047a7ba7d4f9bcebd0061/data"
path <- file.path(getwd(), "data/who_global_annual/raw/who_global_2023_2024/cholera_adm0_public_2024.csv")
download.file(url, path, mode = "wb")

cholera_data_2023 <- read.csv(file.path(getwd(), "data/raw/who_global_2023_2024/cholera_adm0_public_2023.csv"), stringsAsFactors = FALSE)
cholera_data_2024 <- read.csv(file.path(getwd(), "data/raw/who_global_2023_2024/cholera_adm0_public_2024.csv"), stringsAsFactors = FALSE)

cholera_data_2023$year <- 2023
cholera_data_2024$year <- 2024

cholera_data_2023 <- cholera_data_2023[cholera_data_2023$who_region == "AFRO",]
cholera_data_2024 <- cholera_data_2024[cholera_data_2024$who_region == "African Region",]
cholera_data_2024$who_region <- "AFRO"

cholera_data_2023_2024 <- rbind(cholera_data_2023, cholera_data_2024)


colnames(cholera_data_2023_2024)[colnames(cholera_data_2023_2024) == "case_total"] <- "cases_total"
colnames(cholera_data_2023_2024)[colnames(cholera_data_2023_2024) == "death_total"] <- "deaths_total"
colnames(cholera_data_2023_2024)[colnames(cholera_data_2023_2024) == "who_region"] <- "region"
colnames(cholera_data_2023_2024)[colnames(cholera_data_2023_2024) == "iso_3_code"] <- "iso_code"
colnames(cholera_data_2023_2024)[colnames(cholera_data_2023_2024) == "adm0_name"] <- "country"
cholera_data_2023_2024$cases_imported <- NA
cholera_data_2023_2024$cfr <- cholera_data_2023_2024$deaths_total / cholera_data_2023_2024$cases_total
cholera_data_2023_2024 <- cholera_data_2023_2024[,!(colnames(cholera_data_2023_2024) %in% c("first_epiwk", "last_epiwk"))]


country_names <- sort(unique(c(cholera_data_1949_2021$country, cholera_data_2022$country)))
country_names <- country_names[!(country_names == "Democratic Republic of Congo")]



# Function to match and standardize country names
capitalize_words <- function(name) {
     s <- tolower(name)
     s <- strsplit(s, " ")[[1]]
     s <- paste(toupper(substring(s, 1, 1)), substring(s, 2), sep="", collapse=" ")
     return(s)
}

# Standardize country names in the 2023-2024 data to match the 2022 data
cholera_data_2023_2024$country <- sapply(cholera_data_2023_2024$country, capitalize_words)

# Manually fix any specific mismatches (e.g., "D.R. Congo" to "Democratic Republic of the Congo")
cholera_data_2023_2024$country[cholera_data_2023_2024$country == "Democratic Republic Of Congo"] <- "Democratic Republic of Congo"
cholera_data_2023_2024$country[cholera_data_2023_2024$country == "Democratic Republic Of The Congo"] <- "Democratic Republic of Congo"
cholera_data_2023_2024$country[cholera_data_2023_2024$country == "United Republic Of Tanzania"] <- "Tanzania"


# Verify if all country names match
mismatches <- cholera_data_2023_2024$country[!(cholera_data_2023_2024$country %in% country_names)]

# Print mismatches
if (length(mismatches) == 0) {
     print("All country names match the country_names vector.")
} else {
     print("Mismatched country names:")
     print(mismatches)
}

head(cholera_data_2023_2024)

write.csv(cholera_data_2023_2024, file=file.path(getwd(), "data/processed/who_afro_annual_2023_2024.csv"), row.names = FALSE)


combined_cholera_data <- rbind(cholera_data_1949_2021, cholera_data_2022, cholera_data_2023_2024)
combined_cholera_data$country[combined_cholera_data$country == "Democratic Republic of the Congo"] <- "Democratic Republic of Congo"


combined_cholera_data <- combined_cholera_data[,c("country", "iso_code", "year", "cases_total", "deaths_total")]

head(combined_cholera_data)

write.csv(combined_cholera_data, file=file.path(getwd(), "data/processed/who_afro_annual_1949_2024.csv"), row.names = FALSE)
