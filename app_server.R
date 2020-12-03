library("shiny")
library(tidyverse)
library(maps)
library(mapproj)
library(patchwork)
library(styler)

# Use source() to execute the `app_ui.R` and `app_server.R` files. These define the values `ui` and `server`
# source("app_ui.R")
# source("app_server.R")

# Create a new `shinyApp()` using the loaded `ui` and `server` variables
# shinyApp(ui = ui, server = server)

climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE) %>%
#analysis_data <- na.omit(climate_data) %>%
  mutate(
    capita_per_gdp = energy_per_capita / energy_per_gdp,
    co2_growth_by_gdp = co2_growth_prct / gdp,
    energy_gdp_by_pop = energy_per_gdp / population,
    energy_capita_by_pop = energy_per_capita / population,
    prim_energy_consum_by_pop  = primary_energy_consumption / population,
    prim_energy_consum_by_gdp  = primary_energy_consumption / population
  )