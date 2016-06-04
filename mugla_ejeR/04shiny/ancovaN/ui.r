library(shiny)


# Define UI for slider demo application
shinyUI(fluidPage(
  
  #  Application title
  titlePanel("ANCOVA required sample"),
  
  # Sidebar with sliders that demonstrate various available
  # options
  sidebarLayout(
    sidebarPanel(
      # Simple integer interval
      sliderInput("pow", "Target Power:", 
                  min=0, max=1, value=.5,step=.1),
      
      # Decimal interval with step value
      sliderInput("alp", "Alpha:", 
                  min = 0, max = 1, value = 0.05, step= 0.01),
      
      # Specification of range within an interval
      sliderInput("del", "Delta (effect size):",
                  min = 0, max = 2, value = c(.2,.5),step=.01),
   
      # Specification of range within an interval
      sliderInput("r2", "Explained Variance:",
                  min = 0, max = .95, value = c(.4,.6),step=.01)

    ),
    
    # Show a table summarizing the values entered
    mainPanel(
      h4("Input"),
      tableOutput("values"),
      
      h4("Output"),
      tableOutput("values2")
    )
  )
))