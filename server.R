

# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jsonlite)
#library(plotly)
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
    
    
    output$basePlot <- renderPlot({
      
      # output$Table <- renderTable({
      #   output <- data.frame(genres)})
      
      # output$Genre <- renderUI({
      #   selectInput("Genre", 
      #               "Choose a genre:", 
      #               append("All", sort(genres$name))) })
      # 
      # output$Language <- renderUI({
      #   selectInput("Language",
      #               "Choose a language:",
      #               unique(rawData$original_language), multiple = T, selected = 'en' ) })
      # 
      # output$Country <- renderUI({
      #   selectInput("Country",
      #               "Choose a Country:",
      #               sort(countries$name), multiple = T , selected = 'United States of America') })
      
      minyear <- input$Year[1]
      maxyear <- input$Year[2]
      minVote_Count <- input$Vote_Count[1]
      maxVote_Count <- input$Vote_Count[2]
      minVote_Average <- input$Vote_Average[1]
      maxVote_Average <- input$Vote_Average[2]
      minPopularity <- input$Popularity[1]
      maxPopularity <- input$Popularity[2]
      
      # data for filer 
      filterData <- rawData %>% filter(
        Year >= minyear,
        Year<=maxyear,
        vote_count >= minVote_Count,
        vote_count<=maxVote_Count,
        vote_average >= minVote_Average,
        vote_average<=maxVote_Average,
        popularity >= minPopularity,
        popularity<=maxPopularity
        )%>% arrange(Year)
      
      output$n_movies <- renderText({nrow(filterData)})

      formattedData <-  filterData
      formattedData$genres <- lapply(filterData$genres,function(x)fromJSON(x)$name)
      formattedData$keywords <- lapply(filterData$keywords,function(x)fromJSON(x)$name)
      formattedData$production_companies <- lapply(filterData$production_companies,function(x)fromJSON(x)$name)
      formattedData$production_countries <- lapply(filterData$production_countries,function(x)fromJSON(x)$name)
      formattedData$spoken_languages <- lapply(filterData$spoken_languages,function(x)fromJSON(x)$name)
      formattedData<-formattedData[c("id","original_title","title","budget","revenue","genres","homepage","keywords","original_language","popularity","production_companies","production_countries","release_date","runtime","spoken_languages","status","tagline","vote_average","vote_count","Year")]
      output$formattedData <- renderDataTable(formattedData)

      # build graph with ggplot syntax
      p <- ggplot(filterData, aes(x = vote_average,
                                y = vote_count,
                                color = Year)) + geom_point() + labs(title = "Vote count and their average with respect of years", x =
                                                                       "Vote Average", y = "Vote Count") + scale_color_discrete(name = ' Release Year')
      
      # ggplotly(p)
      plot(p) 
      
    })
    output$hover <- renderPrint({
      d <- event_data("plotly_hover")
      if (is.null(d)) "Hover events appear here (unhover to clear)" else d
    })
    

    
  })


## Table Genre
genre <- rawData$genres
genreList <- lapply(genre, function(x) fromJSON(x))
genreList <- genreList[sapply(genreList, function(x) as.numeric(dim(x)[1])) > 0]
genreList <- genreList[!sapply(genreList, is.null)]
genres <- unique(Reduce(function(...) merge(..., all=T), genreList)) 


## Table Keyword
GetNames <- function(x){
name <- x
nameList <- lapply(name, function(x) fromJSON(x))
nameList <- nameList[sapply(nameList, function(x) as.numeric(dim(x)[1])) > 0]
nameList <- nameList[!sapply(nameList, is.null)]
return ((unique(Reduce(function(...) merge(..., all=T), nameList))))$name
}

## Table Country
country <- rawData$production_countries
countryList <- lapply(country, function(x) fromJSON(x))
countryList <- countryList[sapply(countryList, function(x) as.numeric(dim(x)[1])) > 0]
countryList <- countryList[!sapply(countryList, is.null)]
countries <- unique(Reduce(function(...) merge(..., all=T), countryList)) 