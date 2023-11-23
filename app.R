library(shiny)
library(DT)
data <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/wine.csv")
# data <- read.csv("wine.csv")
data <- data[, -1]
data$alcohol <- round(data$alcohol, 2)
data$liver <- round(data$liver, 2)
ui <- fluidPage(
  
  titlePanel("Assignment B-3!"),
  
  sidebarLayout(
    
    sidebarPanel(
      # feature 3: filter data
      sliderInput("alcohol", "Filter by alcohol",
                  min=min(data$alcohol),
                  max=max(data$alcohol), 
                  value=c(min(data$alcohol), max(data$alcohol)),
                  step=0.1),
      # feature 1: sort the table by alcohol
      checkboxInput("order", 'Order by alcohol', value=F)
      
    ),
    
    mainPanel(
      # feature 2: Use the DT package to turn a static 
      # table into an interactive tab
      DTOutput(outputId = "table"),
      # feature 3: filter data
      textOutput("text")
    )
  )
)

server <- function(input, output) {
  
  # feature 2: Use the DT package to turn a 
  # static table into an interactive tab
  output$table <- renderDataTable({
    # feature 1: sort the table by alcohol
    if(input$order) {
      data <- data[order(data$alcohol), ]
    }
    # feature 3: filter data
    data <- data[data$alcohol>=input$alcohol[1] & data$alcohol<=input$alcohol[2], ]
    data
  })
  # feature 3: filter data
  
  output$text <- renderText({
    data <- data[data$alcohol>=input$alcohol[1] & data$alcohol<=input$alcohol[2], ]
    print(paste0("We found ", nrow(data), " records for you"))
  })
}

shinyApp(ui = ui, server = server)