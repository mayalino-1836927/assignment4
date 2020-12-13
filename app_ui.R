
data_range <- range(climate_data$year)

select_values <- colnames(climate_data)

co2_input <- sliderInput(
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
      h3("This project seeks to visualize CO2 data collected by the Our World in Data project. 
         Additionally for this project, are the computed values of the highest co2 producers and consumers, 
         as well the GDP of those countries. Additional data columns have also been added into the dataset 
         answering such questions as: What is the ratio of energy per capity by the energy per gdp? What is the 
         growth of CO2 by GDP? What is the energy per GDP by population? What is the energy per capita by population? 
         What is the primary energy consumption by population? and What is the primary energy consumption by GDP?"),
      h4("The analysis shows that : "),
      h4("the highest consumers of CO2 are ", highest_co2_consumer[1,1], ", ", highest_co2_consumer[2,1], ", ",
         highest_co2_consumer[3,1], ", ", highest_co2_consumer[4,1],", ", highest_co2_consumer[5,1]),
      h4("and its GDP is ",  highest_co2_consumer_gdp),
      h4("the highest producers of CO2 are ", highest_co2_producer[1,1], ", ", highest_co2_producer[2,1], ", ",
         highest_co2_producer[3,1], ", ", highest_co2_producer[4,1], ", ", highest_co2_producer[5,1]),
      h4("and its GDP is ", highest_co2_producer_gdp),
      h4("the lowest consumers of CO2 are ", lowest_co2_consumer[1,1], ", ", lowest_co2_consumer[2,1]),
      h4("and its GDP is ", lowest_co2_consumer_gdp[1,1]),
      h4("the lowest producers of CO2 are ", lowest_co2_producer[1,1], ", ", lowest_co2_producer[2,1]),
      h4("and its GDP is ", lowest_co2_producer_gdp[1,1]),
      h3("Particularly, the aim of these calculations is to show the disparity of CO2 consumption and production by 
         wealth. There is an imbalance between the wealthier imperialist countries and its neo-colonies 
         which suffer the most from global warming yet contribute the least to it and garner no benefits from CO2 
         consumption/production when compared with the more affluent countries.")
    ),
    tabPanel(
      "CO2 Viewer",
      co2_input,
      feature_input,
      checkboxInput("smooth", label = strong("Show Trendline"), value = TRUE),
      plotOutput("plot"),
      h3("This chart depicts the selected value as it trends over time.")
    )
  ), View(climate_data)
)
