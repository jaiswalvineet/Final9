

# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

# Load the raw data
rawData <- read.csv("raw.csv", stringsAsFactors = F)

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
    output$distPlot <- renderPlot({
    
    output$Table <- renderTable({
    output <- data.frame(genres)})

    output$Genre <- renderUI({
      selectInput("Genre", 
                  "Choose a genre:", 
                  append("All", sort(genres$name))) })
    
    output$Language <- renderUI({
      selectInput("Language",
                  "Choose a language:",
                  unique(raw$original_language), multiple = T, selected = 'en' ) })
    
    output$Country <- renderUI({
      selectInput("Country",
                  "Choose a Country:",
                  sort(countries$name), multiple = T , selected = 'United States of America') })
    
  })
})



## Table Genre
genre <- raw$genres
genreList <- lapply(genre, function(x) fromJSON(x))
genreList <- genreList[sapply(genreList, function(x) as.numeric(dim(x)[1])) > 0]
genreList <- genreList[!sapply(genreList, is.null)]
genres <- unique(Reduce(union, genreList)) 


## Table Keyword
# keyword <- raw$keywords
# keywordList <- lapply(keyword, function(x) fromJSON(x))
# keywordList <- keywordList[sapply(keywordList, function(x) as.numeric(dim(x)[1])) > 0]
# keywordList <- keywordList[!sapply(keywordList, is.null)]
# keywords <- unique(Reduce(union, keywordList)) 

## Table Country
country <- raw$production_countries
countryList <- lapply(country, function(x) fromJSON(x))
countryList <- countryList[sapply(countryList, function(x) as.numeric(dim(x)[1])) > 0]
countryList <- countryList[!sapply(countryList, is.null)]
countries <- unique(Reduce(union, countryList)) 