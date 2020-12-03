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

climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)

analysis_data <- na.omit(climate_data) %>%
  mutate(
    capita_per_gdp = energy_per_capita / energy_per_gdp,
    co2_growth_by_gdp = co2_growth_prct / gdp,
    energy_gdp_by_pop = energy_per_gdp / population,
    energy_capita_by_pop = energy_per_capita / population,
    prim_energy_consum_by_pop  = primary_energy_consumption / population,
    prim_energy_consum_by_gdp  = primary_energy_consumption / population
  )

# For convenience store the `range()` of values for the `price` column
# (of your sample)
data_range <- range(climate_data$year)

# For convenience, get a vector of column names from the `diamonds` data set to
# use as select inputs
select_values <- colnames(climate_data)

price_input <- sliderInput(
  inputId = "co2_choice",
  label = "CO2 range",
  min = data_range[1],
  max = data_range[2],
  value = data_range
)

feature_input <- selectInput(
  inputId = "feature",
  label = "Feature of Interest",
  choices = select_values,
  selected = "co2_growth_prct"
)

ui <- fluidPage(
  navbarPage(
    "Climate Change Analysis",
    tabPanel(
      "Summary Data and Analysis",
      h4("This project seeks to visualize CO2 data collected by the Our World in Data project; "),
    ),
    tabPanel(
      "CO2 Viewer",
      price_input,
      feature_input,
      checkboxInput("smooth", label = strong("Show Trendline"), value = TRUE),
      plotOutput("plot")
    )
  )
)


# Define a `server` function (with appropriate arguments)
# This function should perform the following:
server <- function(input, output) {
  # Assign a reactive `renderPlot()` function to the outputted 'plot' value
  output$plot <- renderPlot({
    # This function should first filter down the `diamonds_sample` data
    # using the input price range (remember to get both ends)!
    plot_data <- climate_data %>%
      filter(co2 > input$co2_choice[1], co2 < input$co2_choice[2])
    # Use the filtered data set to create a ggplot2 scatter plot with the
    # user-select column on the x-axis, and the price on the y-axis,
    # and encode the "cut" of each diamond using color
    # Save your plot as a variable.
    p <- ggplot(
      data = plot_data,
      mapping = aes_string(x = "year", y = input$feature, color = "co2")
    ) +
      geom_point()
    
    # Finally, if the "trendline" checkbox is selected, you should add (+)
    # a geom_smooth geometry (with `se=FALSE`) to your plot
    # Hint: use an if statement to see if you need to add more geoms to the plot
    if (input$smooth) {
      p <- p + geom_smooth(se = FALSE)
    }
    # Be sure and return the completed plot!
    p
  })
}

# Create a new `shinyApp()` using the above ui and server
shinyApp(ui = ui, server = server)
