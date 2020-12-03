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
    prim_energy_consum_by_gdp  = primary_energy_consumption / gdp
  )

highest_co2_producer <- climate_data %>%
  group_by(country) %>%
  summarize(cumulative_co2 = mean(co2, na.rm = TRUE)) %>%
  filter(cumulative_co2 == max(cumulative_co2)) %>%
  select(country) %>%
  print()
  #group_by(country) %>%
  #filter(cumulative_co2 > 0) %>%
  #summarize(num_co2 = n()) %>%
  #filter(num_co2 == max(num_co2)) %>%
  #select(country) %>%
  #print()
  
lowest_co2_producer <- climate_data %>%
  group_by(country) %>%
  summarize(cumulative_co2 = mean(co2, na.rm = TRUE)) %>%
  filter(cumulative_co2 == min(cumulative_co2)) %>%
  select(country) %>%
  print()

highest_co2_consumer <- climate_data %>%
  group_by(country) %>%
  summarize(consumption_co2 = mean(co2, na.rm = TRUE)) %>%
  filter(consumption_co2 == min(consumption_co2)) %>%
  select(country) %>%
  print()

lowest_co2_consumer <- climate_data %>%
  group_by(country) %>%
  summarize(consumption_co2 = mean(co2, na.rm = TRUE)) %>%
  filter(consumption_co2 == max(consumption_co2)) %>%
  select(country) %>%
  print()

highest_co2_producer_gdp <- climate_data %>%
  filter(country == highest_co2_producer) %>%
  select(gdp) %>%
  print()

lowest_co2_producer_gdp <- climate_data %>%
  filter(country == lowest_co2_producer) %>%
  select(gdp) %>%
  print()

highest_co2_consumer_gdp <- climate_data %>%
filter(country == highest_co2_consumer) %>%
  select(gdp) %>%
  print()

lowest_co2_consumer_gdp <- climate_data %>%
filter(country == lowest_co2_consumer) %>%
  select(gdp) %>%
  print()

server <- function(input, output) {
  output$plot <- renderPlot({
    plot_data <- climate_data %>%
      filter(co2 > input$co2_choice[1], co2 < input$co2_choice[2])
    p <- ggplot(
      data = plot_data,
      mapping = aes_string(x = "year", y = input$feature, color = "co2")
    ) +
      geom_point()
    
    if (input$smooth) {
      p <- p + geom_smooth(se = FALSE)
    }
    p
  })
}
