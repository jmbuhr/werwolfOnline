library(shiny)
library(tidyverse)
library(bslib)

# Define UI for application that draws a histogram
ui <- fluidPage(
  title = "Werwolf",
  theme = bs_theme(version = 4, bootswatch = "minty"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  sidebarLayout(
    sidebarPanel(
      selectizeInput(
        "players" ,
        "Enter the player names" ,
        choices = NULL ,
        multiple = TRUE ,
        options = list(create = TRUE)
      ),
      p("Roles have to be unique (sorry). So enter werwolf1 and werwolf2 etc. instead of werwolf twice"),
      selectizeInput(
        "roles" ,
        "Enter the roles" ,
        choices = NULL ,
        multiple = TRUE ,
        options = list(create = TRUE)
      ),
      p("Add or remove names or roles to reshuffle")
    ),
    mainPanel(
      h4("Assignments:"),
      p(
        "You might want to download the table, as it will be lost when the page is reloaded",
        class = 'note'
      ),
      tableOutput("tbl1"),
      downloadButton("downloadTable",
                     label = "download table")
    )
  )
)

server <- shinyServer(function(input, output) {

  assignment <- reactive({
    validate(need({
      length(input$players) == length(input$roles)
    },
    message = "Need same number of roles as players",
    label = "roles == players"))

    df <- tibble(player = input$players,
                 role = sample(input$roles))
    df
  })

  output$tbl1 <- renderTable({
    assignment()
  })

  output$downloadTable <- downloadHandler(
    filename = function() {
      paste("werwolf-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write_csv(assignment(), file)
    }
  )

})

shinyApp(ui = ui, server = server)
