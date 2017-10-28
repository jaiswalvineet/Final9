

# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jsonlite)
library(plotly)
library(ggplot2)
library(dplyr)


# Load the raw data
rawData <- read.csv("raw.csv", stringsAsFactors = F)
rawData <- na.omit(rawData)
rawData <- anti_join(rawData, subset(rawData, rawData$release_date==""))
rawData$release_date <-  as.Date(rawData$release_date, "%Y-%m-%d")
rawData <- rawData %>% mutate(Year = format(as.Date(release_date, "%d/%m/%Y"), '%Y'))

#' Title
#'
#' @param input 
#' @param output 
#'
#' @return
#' @export
#'
#' @examples
shinyServer(function(input, output) {
    
    
    output$basePlot <- renderPlotly({
      
      output$Table <- renderTable({
        output <- data.frame(genres)})
      
      output$Genre <- renderUI({
        selectInput("Genre", 
                    "Choose a genre:", 
                    append("All", sort(genres$name))) })
      
      output$Language <- renderUI({
        selectInput("Language",
                    "Choose a language:",
                    unique(rawData$original_language), multiple = T, selected = 'en' ) })
      
      output$Country <- renderUI({
        selectInput("Country",
                    "Choose a Country:",
                    sort(countries$name), multiple = T , selected = 'United States of America') })
      
      
      Vote_Average <- input$Vote_Average
      Vote_Count <- input$Vote_Count
      minyear <- input$Year[1]
      maxyear <- input$Year[2]

      # build graph with ggplot syntax
      p <- ggplot(rawData, aes(x = vote_average,
                                y = vote_count,
                                color = Year)) + geom_point() + labs(title = "Movie database statistical analysis based on input", x =
                                                                       "Vote Average", y = "Vote Count") + scale_color_discrete(name = ' Release Year')
      
      ggplotly(p)

    })
    
    
  })


## Table Genre
genre <- rawData$genres
genreList <- lapply(genre, function(x) fromJSON(x))
genreList <- genreList[sapply(genreList, function(x) as.numeric(dim(x)[1])) > 0]
genreList <- genreList[!sapply(genreList, is.null)]
genres <- unique(Reduce(function(...) merge(..., all=T), genreList)) 


## Table Keyword
# keyword <- raw$keywords
# keywordList <- lapply(keyword, function(x) fromJSON(x))
# keywordList <- keywordList[sapply(keywordList, function(x) as.numeric(dim(x)[1])) > 0]
# keywordList <- keywordList[!sapply(keywordList, is.null)]
# keywords <- unique(Reduce(union, keywordList)) 

## Table Country
country <- rawData$production_countries
countryList <- lapply(country, function(x) fromJSON(x))
countryList <- countryList[sapply(countryList, function(x) as.numeric(dim(x)[1])) > 0]
countryList <- countryList[!sapply(countryList, is.null)]
countries <- unique(Reduce(function(...) merge(..., all=T), countryList)) 