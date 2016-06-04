library(shiny)
# library("devtools")
# #devtools::install_github('devtools', 'hadley')
# install_github('fun1ancovaN','burakaydin')
library("fun1ancovaN")
# Define server logic for slider examples
shinyServer(function(input, output) {
  
  # Reactive expression to compose a data frame containing all of
  # the values
  sliderValues <- reactive({
    
    # Compose data frame
    data.frame(
      Name = c("Target Power", 
               "Alpha",
               "Delta ",
               "Explained Variance",
               "tail",
               "proportion"),
      Value = as.character(c(input$pow, 
                             input$alp,
                             paste(input$del, collapse=' '),
                             paste(input$r2, collapse=' '),
                             "2",
                             "%50")), 
      stringsAsFactors=FALSE)
  }) 
  
  # Show the values using an HTML table
  output$values <- renderTable({
    sliderValues()
  })
  
  sliderValues2 <- reactive({
    
    # Compose data frame
    data.frame(
      A = as.character(c("",paste("d=",min(input$del)), paste("d=",max(input$del))),
                                 stringsAsFactors=FALSE),
      
      B = as.character(c(paste("R2=",min(input$r2)),
                          ancovaN(pow=input$pow,alp=input$alp,del=min(input$del),r2=min(input$r2)), 
                          ancovaN(pow=input$pow,alp=input$alp,del=max(input$del),r2=min(input$r2))), 
      stringsAsFactors=FALSE),
      
      C = as.character(c(paste("R2=",max(input$r2)),
                          ancovaN(pow=input$pow,alp=input$alp,del=min(input$del),r2=max(input$r2)), 
                          ancovaN(pow=input$pow,alp=input$alp,del=max(input$del),r2=max(input$r2))), 
                        stringsAsFactors=FALSE))
      
  }) 
  
  # Show the values using an HTML table
  output$values2 <- renderTable({
    sliderValues2()
  }) 
  
  })