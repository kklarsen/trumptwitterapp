# ui.R

library(shiny)
library(shinyBS)
library(manipulate)

minDate <<- "2015-10-01"
maxDate <<- "2015-10-16"


fluidPage(
  
           # Application title
           titlePanel("Donald Trump - Twitter October 2015"),
           
           sidebarLayout(
             # Sidebar with a slider and selection inputs
             sidebarPanel(
               radioButtons("choices", "Choose Analysis:",
                            c("Trump's own Tweets" = "realTrump",
                              "Other's Tweets on Trump" = "feedbck",
                              "Add Topics Tree" = "mainTopics")
                            ),
           
               dateInput("myDate", "Twitter Date:",
                         value = "2015-10-16",
                         min = minDate,
                         max = maxDate,
                         format = "yyyy-mm-dd", 
                         startview = "month", 
                         weekstart = 0, 
                         language = "en"),

               sliderInput("freq",
                           "Min. Word Frequency for Wordcloud:",
                           min = 0,  max = 50, step = 10, value = 10),
               sliderInput("max",
                           "Max. Number of Words in Wordcloud:",
                           min = 0,  max = 300, step = 10,  value = 50),
               sliderInput("spars",
                           "Sparseness (Topics Tree):",
                           min = 0,  max = 1, step = 0.01,  value = 0.98),
               sliderInput("kguess",
                           "#Clusters k (Topics Tree):",
                           min = 1,  max = 10, step = 1,  value = 5),
               
               #actionButton("update","Update", width = "100%" ),
               bsButton("update","Update", block = TRUE, style = "primary" ),
               hr()
               

    ),
        
  # Show Word Cloud
  mainPanel(
    
    tabsetPanel(
      
      tabPanel("TrumpCloud", plotOutput("plot") ),
      tabPanel("Documentation",includeMarkdown("documentation.md"))
      )
    )
    
    
     )         
  )