library(shiny)

# server mantigini insaa et
shinyServer(function(input, output) {
  
  # ciktimiz bir grafik olacak
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser Verisi
    bins <- seq(min(x), max(x), length.out = input$kutu + 1)
    
    # histogrami ciz
    hist(x, breaks = bins, col = 'darkgray', border = 'white', main="Histogram grafik")
  })
})