## This is a Shiny App that will predict the next word for given a phrase.
## An algorithm makes use of grep and tidytext to predict the word.

library(shiny)
library(tidyr)
library(dplyr)

source("global.R", encoding = "UTF-8")

# Define UI that allows user to enter a phrase and predicted next word
ui <- fluidPage(

  # Application title
  titlePanel("An App to Predict the Next Word"),
  
  br(),
  div(h4("Enter a brief phrase and click the 'Get Next Word' button."), style = "color:blue"),
  tags$ul(
    tags$li(h5("The predicted next word will be displayed.")),
    tags$li(h5("Click on the Top Predictions tab to see other next-word predictions for your phrase."))
  ),
  br(),
  h5(tags$i("Note: it may take a little while to return a result. Please be patient.")),
  br(),
  br(),
  
  # Sidebar for text input
  sidebarLayout(
    sidebarPanel(
      br(),
      textInput("phrase", label = "Enter a phrase", value = ""),
      br(),
      actionButton("button", "Get Next Word",style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
      actionButton("reset", "Clear"),
      br(),
      h5("Use the Clear button to clear the input box")
    ),
    
    # Show the predicted next word in tab 1 and then other top predictions in tab 2.
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  tabPanel(strong("Next Word"),
                           br(),
                           tags$div(class="container-fluid",
                              tags$div(class="row",
                                 tags$div(class="col-sm-4",
                                    tags$form(class="well",
                                      tags$div(class="form-group shiny-input-container",
                                         tags$label("The next word is:"),
                                         tableOutput("prediction")
                                      )
                                    )
                                 )
                              )
                           ),
                           br(),
                           div(textOutput("elapsed"))
                  ),
                  
                  tabPanel("Top Predictions",
                    br(),
                    h4("Here is some other top predictions and their relative counts:"),
                    tableOutput("otherPredictions"))
      )
      
    )
  )
)


# Define server logic required pass the given phrase to the algorithm to generate the 
# next word and top predictions and then pass the results back to the UI.
server <- function(input, output, session) {
  
  observeEvent(input$reset, {
    n <- isolate(input$reset)
    if (n == 0) {
      return()
    } else {
      updateTextInput(session,"phrase", value="")
    }
  })

  observeEvent(input$button, {
    
    begin <- Sys.time()
    
    withProgress(message = 'Predicting next word...', value = 0, {
      
      if(is.na(input$phrase) | (input$phrase == "")) {
        predicted_word <- as_tibble("You must enter a phrase")
        output$prediction <- renderTable({predicted_word}, bordered = TRUE, striped = TRUE, colnames = FALSE)
      } else {
        predicted_word <- isolate(get_next_word(input$phrase))
      }
      
      output$prediction <- renderTable({predicted_word[1,1]}, bordered = TRUE, striped = TRUE, colnames = FALSE)
      
      if(nrow(predicted_word[-1,]) == 0) {
        no_other <- as_tibble("No other predictions")
        output$otherPredictions <- renderTable({no_other}, bordered = TRUE, striped = TRUE, colnames = FALSE)
      } else {
        output$otherPredictions <- renderTable({predicted_word[-1,]}, bordered = TRUE, striped = TRUE, colnames = FALSE)
      }
      
    })
    
    end <- Sys.time()
    diff <- format((end - begin), digits = 2)
    message <- paste0("It took ", diff ," seconds for this prediction.")
    output$elapsed <- renderText({message})
    
  })
  
} # end of server function

# Run the application 
shinyApp(ui = ui, server = server)

