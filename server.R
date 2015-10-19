# server.R

library(wordcloud)
library(tm)
library(memoise)
library(lubridate)
library(markdown)

getTwitterInterest <- function(mFile) {
  
#  myFile <- paste0("interest",strftime(myDate, "%d"),"Oct15.csv")
  
  interest <<- read.csv(mFile, 
                       header = TRUE, 
                       row.names = NULL,
                       fill = TRUE)
  
  interest_list <- interest$text
  
  interest_list <- gsub("http://.*", "", interest_list)
  interest_list <- gsub("http.*", "", interest_list)
  interest_list <- gsub("[[:digit:]]", "", interest_list)
  interest_list <- iconv(interest_list, "latin1", "ASCII", sub="")
  
  interest_corpus <- Corpus(VectorSource(interest_list))
  
  interest_corpus <- tm_map(interest_corpus,removePunctuation)
  interest_corpus <- tm_map(interest_corpus,content_transformer(tolower))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,stopwords("english")))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"donald trump"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"realdonaldtrump"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"donald"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"trump"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"trumps"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"falsenanaa"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"href"))

}

TwitterCluster <- function(mCorpus, mSpars) {

#Next step going to a term-document matrix analysis

interest.tdm <- TermDocumentMatrix(mCorpus)

# Remove sparse terms from the tdm = term-document matrix
# Convert the tdm to a data frame

tdm2 <- removeSparseTerms(interest.tdm, sparse = mSpars)
m2 <- as.matrix(tdm2)

distMatrix <- dist(scale(m2))

fit <- hclust(distMatrix, method = "complete")

}

function(input, output, session) {
  
    # Define a reactive expression for the document term matrix
  
        terms <- reactive({
                # Change when the "update" button is pressed...
                input$update
                
                isolate({
                  withProgress({
                
                    setProgress(message = "Processing Twitter corpus...")
                    
                    if (input$choices == "realTrump") {
                    myFile <<- "realdonaldtrumpOct15.csv"
                    }
                      
                    if (input$choices == "feedbck") {
                      myFile <<- paste0("interest",strftime(as.character(input$myDate), "%d"),"Oct15.csv") 
                    }
                    
                    if (input$choices == "mainTopics") { 
                      vv <<- TwitterCluster(myCorpus, input$spars)
                    }  
                      
                    myCorpus <<- getTwitterInterest(myFile)
                    
                  })
            })
                
        })
        
  
            
        # Make the wordcloud drawing predictable during a session
        
       wordcloud_rep <- repeatable(wordcloud)
        
       output$plot <- renderPlot({
         
         par(mfrow = c(1,2))
          
         v <- terms()
          
        palette <- brewer.pal(7,"PuRd")
        palette <- palette[-(1:2)]
                 
         wordcloud_rep(v, scale=c(5,2),
                               min.freq = max(1,input$freq),
                               max.words = max(1,input$max),
                               colors=palette)
         
         text(x = 0.12, y = 0.0, paste("(based on ",dim(interest)[1], " Tweets)"), 
              font = 2, 
              cex =1.2, 
              col = "firebrick1")
         
         if (input$choices == "mainTopics") {
         
           vv <<- TwitterCluster(myCorpus, input$spars)
           
           plot(vv, main = "Tweeter Topical Clusters", xlab = "Cluster Dendrogram",
              font.main = 2, 
              cex.main = 2,
              col.main = "firebrick2",
              cex = 1.1)
              
         
           rect.hclust(vv, k = input$kguess)
         
         }
         
        }, height = 600, width = 1200)
       
       #output$documentation <- renderText({
       #   includeMarkdown("documentation.md")
       #})
}
