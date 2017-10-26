
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

# Load the raw data
rawData <- read.csv("raw.csv", stringsAsFactors = F)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- rawData$budget
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    output$Table <- renderTable({
        output<-data.frame(genres)
        output
    })

  })

})


## table name  
  genre <- raw$genres
  genreList <- lapply(genre,function(x) fromJSON(x))
  genreList <- genreList[sapply(genreList, function(x) as.numeric(dim(x)[1])) > 0]
  genreList <- genreList[!sapply(genreList, is.null)]
  genres <- unique(Reduce(union, genreList)) 