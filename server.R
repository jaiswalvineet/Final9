

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
    # generate bins based on input$bins from ui.R
    x    <- rawData$budget
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    # hist(x,breaks = bins,col = 'darkgray',border = 'white')
    
    output$Table <- renderTable({
    output <- data.frame(genres)})
    #output
    #output$Table <- renderTable({
     # output <- data.frame(keywords)})
    
    output$Genre <- renderUI({
      selectInput("Genre", 
                  "Choose a genre:", 
                  append("Select", sort(genres$name))) })
    
    output$Language <- renderUI({
      selectInput("Language",
                  "Choose a language:",
                  unique(raw$original_language), multiple = T ) })
    
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