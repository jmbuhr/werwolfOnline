#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(

  pageWithSidebar(

    headerPanel("Werwolf Online Generator")

    , sidebarPanel(
      selectizeInput(
        "players"
        , "Enter the player names"
        , choices = NULL
        , multiple = TRUE
        , options = list(create = TRUE)
      ),
      p("Roles have to be unique (sorry). So enter werwolf1 and werwolf2 etc. instead of werwolf twice"),
      selectizeInput(
        "roles"
        , "Enter the roles"
        , choices = NULL
        , multiple = TRUE
        , options = list(create = TRUE)
      ),
      p("Add or remove names or roles to reshuffle")
    ),

    mainPanel(

      h4("Assignments:"),
      tableOutput("tbl1")

    )

  )
)

server <- shinyServer(function(input, output) {

  assignment <- reactive({
    validate(
      need({
        length(input$players) == length(input$roles)
      },
      message = "Need same number of roles as players",
      label = "roles == players")
    )

    df <- tibble::tibble(
      player = input$players,
      role = sample(input$roles)
    )
    df
  })

  output$tbl1 <- renderTable({
    assignment()
  })

})

shinyApp(ui = ui, server = server)
