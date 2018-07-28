library(shiny)
library(ggplot2)

dataset <- movies[, c(2:6)]

shinyServer(function(input, output) {
  
  dataset <- reactive({
    movies[movies$year >= input$year[1] & movies$year <= input$year[2] & movies$length >= input$length[1] & movies$length <= input$length[2] & movies$votes >= input$votes[1] & movies$votes <= input$votes[2],c(2:6)]
  })
  
  output$plot <- renderPlot({
    
    data = dataset()
    p <- ggplot(data, aes_string(x=input$x, y=input$y)) + geom_point() + geom_density2d()
    # abline(lm(input$y ~ input$x, data=data))
    
    print(p) 
  })
  
})
