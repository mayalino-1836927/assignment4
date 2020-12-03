library("shiny")
library(tidyverse)
library(maps)
library(mapproj)
library(patchwork)
library(styler)

# Use source() to execute the `app_ui.R` and `app_server.R` files. These define the values `ui` and `server`
source("app_ui.R")
source("app_server.R")

data_range <- range(climate_data$year)

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

# Create a new `shinyApp()` using the above ui and server
shinyApp(ui = ui, server = server)
