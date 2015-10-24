# server.R

library(wordcloud)
library(tm)
library(topicmodels)
library(markdown)
library(data.table)
library(memoise)

getTwitterInterest <- memoise( function(mFile) {
  
  interest <- read.csv(mFile, 
                       header = TRUE, 
                       row.names = NULL,
                       fill = TRUE)
  
  mDim <<- dim(interest)[1]
  
  if ( mDim > 5000 ) interest_list <- sample(interest$text,5000)
  if ( mDim <= 5000 ) interest_list <- interest$text
  

  interest_list <- gsub("http://.*", "", interest_list)
  interest_list <- gsub("http.*", "", interest_list)
  interest_list <- gsub("[[:digit:]]", "", interest_list)
  interest_list <- iconv(interest_list, "latin1", "ASCII", sub="")
  
  interest_corpus0 <<- Corpus(VectorSource(interest_list))
  
  interest_corpus <- tm_map(interest_corpus0,removePunctuation)
  interest_corpus <- tm_map(interest_corpus,content_transformer(tolower))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,stopwords("english")))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"donald trump"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"realdonaldtrump"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"trumps"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"falsenanaa"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"href"))

  mCorpus.bis <- interest_corpus
  interest.bis <<- TermDocumentMatrix(mCorpus.bis)
  
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"donald"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"trump"))
  
  interest.tdm <<- TermDocumentMatrix(interest_corpus)
  dtm <<- as.DocumentTermMatrix(interest.tdm)
  
  interest_corpus <- interest_corpus
  
  
})

TwitterCluster <- function(mSpars) {


# Remove sparse terms from the tdm = term-document matrix
# Convert the tdm to a data frame

tdm2 <- removeSparseTerms(interest.tdm, sparse = mSpars)
m2 <- as.matrix(tdm2)

distMatrix <- dist(scale(m2))

fit <- hclust(distMatrix, method = "complete")

}

TwitterTopicModel <- function() {
  
  rowTotals <- apply(dtm , 1, sum) #Find the sum of words in each Document
  dtm.new   <- dtm[rowTotals> 0, ]
  
  lda <- LDA(dtm.new, k = 6)
  tweetTopics <- terms(lda, 6)
  
}

TwitterAssociation <- function(mWord) {
        
  findAssocs(interest.bis,mWord,0.5)
  
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
                            
                        TwitterCluster(input$spars)
                    }  
                      
                        getTwitterInterest(myFile)
                    
                  })
                 
            })
                
        })
        
        mTable1 <- reactive({
          # Change when the "update" button is pressed...
          
          input$topics
          
          isolate({
            
            withProgress({
              
              setProgress(message = "Processing Twitter Topic Table...")
              
                TwitterTopicModel()
              
              })
            
           })
        })          
        
        mTable2 <- reactive({
          
         input$text
          
         isolate({
            withProgress({
              
              setProgress(message = "Processing Twitter Associations ...")
              
                t(as.data.frame(TwitterAssociation(input$text)[[1]]))
              

           })
            
          })
       })          
          
        
      observe ( {
        
        if (input$topics > 0) {
          
          updateTabsetPanel(session, "inTabset", selected = "TrumpTable")
          
        }
        
      })  
      
      # Make the wordcloud drawing "predictable" ensuring that the same seed is used during a session
      # and generating the same wordcloud for the same data.
        
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
         
         text(x = 0.12, y = 0.0, paste("(based on ",mDim, " Tweets)"), 
              font = 2, 
              cex =1.2, 
              col = "firebrick1")
         
         if (input$choices == "mainTopics") {
         
           vv <<- TwitterCluster(input$spars)
           
           plot(vv, main = "Twitter Topical Clusters", xlab = "Cluster Dendrogram",
              font.main = 2, 
              cex.main = 2,
              col.main = "firebrick2",
              cex = 1.1)
              
         
           rect.hclust(vv, k = input$kguess)
         
         }
         
        }, height = 600, width = 1200)
       
        ## TrumpTable tab
        ## Add two tables
          
        output$table1 <- renderDataTable({
          
          
          xx <- mTable1()

        }, options = list(lengthMenu = c(6), pageLength = 6))
        
        output$table2 <- renderDataTable({
          
          yy <- mTable2()
          
        })

}
