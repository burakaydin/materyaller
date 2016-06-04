library(shiny)

# User Interface (kullanici arayuz) tanimla
shinyUI(fluidPage(
  
  # Uygulamanin basligi
  titlePanel("Shiny de neymis?"),

  # bolme sayisini belirlemek icin slider ile verilen Sidebar
  sidebarLayout(
    sidebarPanel(
      sliderInput("kutu",
                  "kutu sayisi:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # grafigi goster
    mainPanel(
      plotOutput("distPlot")
    )
  )
))