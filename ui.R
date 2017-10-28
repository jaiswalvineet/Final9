




# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  # Application title
  titlePanel("Top 10 movies | Statistical analysis "),
  tags$h4("This application running on tmdb 5000 movie database") ,
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(

    sidebarPanel(
      tags$h3("Axis"),
      selectInput("xvar", "X-axis variable",axis_vars , selected = "Vote_Average"),
      selectInput("yvar", "Y-axis variable",axis_vars , selected = "Vote_Count"),
      tags$small(paste0(" Graph based on below mentioned filters ",
                        " You can change the filter as per your need  "
      )),
      tags$h3("Filters"),
      textInput("Keyword", "Anything you can think about the movie like keyword, star,director etc"),
      uiOutput("Genre"),
      uiOutput("Country"),
      uiOutput("Language"),
      sliderInput(
        "Vote_Average",
        "Select the vote average:",
        min = 0,
        max = 10,
        value = 10
      ),
      sliderInput(
        "Vote_Count",
        "Select the vote count:",
        min = 0,
        max = 15000,
        value = 15000
      ),
      sliderInput(
        "Year",
        "Year released:", 
        1910, 
        2014,  
        value = c(1980, 2014)),
      sliderInput(
        "Popularity",
        "Select the popularity:",
        min = 0,
        max = 1000,
        value = 1000
      ),
      sliderInput(
        "Budget",
        "Select the budget:",
        min = 0,
        max = 500000000,
        value = 5000000000
      ),
      sliderInput(
        "Revenue",
        "Select the revenue:",
        min = 0,
        max = 1000000000,
        value = 1000000000
      ),
      sliderInput(
        "Runtime",
        "Select the runtime:",
        min = 0,
        max = 500,
        value = 500
      ),
      selectInput(
        "Status",
         "Choose a status:",
         as.list(c('Released', 'Post Production', 'Rumored')), selected = 'Released'
        )
     
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("basePlot")
    )
  )
))
