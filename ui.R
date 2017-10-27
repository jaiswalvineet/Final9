



# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "bins",
        "Number of bins:",
        min = 1,
        max = 50,
        value = 30
      ),
      sliderInput(
        "budget",
        "Select the budget:",
        min = 0,
        max = 380000000,
        value = 300000000
      ),
      uiOutput("Genre"),
      uiOutput("Language"),
      uiOutput("Country"),
      sliderInput(
        "popularity",
        "Select the popularity:",
        min = 0,
        max = 1000,
        value = 500
      ),
      sliderInput("year", "Year released:", 1910, 2014, value = c(1980, 2014)),
      sliderInput(
        "Revenue",
        "Select the revenue:",
        min = 0,
        max = 1000000000,
        value = 300000000
      ),
      sliderInput(
        "Runtime",
        "Select the runtime:",
        min = 0,
        max = 500,
        value = 300
      ),
      selectInput("Status",
                  "Choose a status:",
                  as.list(
                    c('Released', 'Post Production', 'Rumored')
                  )),
      sliderInput(
        "Vote_Average",
        "Select the vote average:",
        min = 0,
        max = 10,
        value = 5
      ),
      sliderInput(
        "Vote_Count",
        "Select the vote count:",
        min = 0,
        max = 5,
        value = 2
      )
      
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(plotOutput("distPlot"),
              tabsetPanel(
                tabPanel(
                  "Genre",
                  htmlOutput("header"),
                  tableOutput("Table"),
                  htmlOutput("Text")
                )
              ))
  )
))
