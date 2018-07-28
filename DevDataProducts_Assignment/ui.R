library(shiny)
library(ggplot2)

dataset <- movies[, c(2:6)]

shinyUI(
  navbarPage("IMDB Movies Dataset Insights",
             tabPanel("Application",
                      sidebarPanel(
                            sliderInput("year", 
                                    "Year:", 
                                    min = 1893, 
                                    max = 2005, 
                                    value = c(1893, 2005),
                                    format="####"),

                            sliderInput("length", 
                                      "Length of the Movie:", 
                                      min = 1, 
                                      max = 5220, 
                                      value = c(1, 5220),
                                      step = 25),

                            sliderInput("votes", 
                                        "Votes:", 
                                        min = 0, 
                                        max = 157608, 
                                        value = c(0, 157608),
                                        step = 1000),                          
                            selectInput('x', 'X', names(dataset)),
                            selectInput('y', 'Y', names(dataset))          
                      ),
                      
                      mainPanel(
                                plotOutput('plot')
                        
                                )
                    ),
             
             tabPanel("Details",
                      mainPanel(
                        includeMarkdown("details.html")
                      )
             )
  )
)
