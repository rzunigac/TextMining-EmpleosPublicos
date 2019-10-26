#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

source("modeloLDA.R", encoding="utf-8")

# Define UI for application that draws a histogram
ui = fluidPage(
    fluidRow(
        column(width = 12,
               textInput("x", "Ingrese Perfil", 'Abogado')
        ),
        column(width = 2,
               actionButton("button", "Show")
        )
    ),
    fluidRow(
        column(width = 12,
               tableOutput("table")
        )
    )
)

# Define server logic required to draw a histogram
server = function(input, output) {
    # Take an action every time button is pressed;
    # here, we just print a message to the console
    observeEvent(input$button, {
        cat("Showing", input$x, "rows\n")
    })
    # Take a reactive dependency on input$button, but
    # not on any of the stuff inside the function
    df <- eventReactive(input$button, {
        #head(cars, input$x)
        topico <- buscar_topico(ldaOut_guardado, input$x)
        documentos <- documentos_por_topico(ldaOut_guardado, topico)
        corpus_to_df(corpus_guardado[documentos])
        
    })
    output$table <- renderTable({
        df()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
