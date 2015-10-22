# server.R

library(wordcloud)
library(tm)
library(topicmodels)
library(markdown)

set.seed(123)

Cleaning4Assocation <- function(mCorpus0) {
  
  interest_corpus <- tm_map(mCorpus0,removePunctuation)
  interest_corpus <- tm_map(interest_corpus,content_transformer(tolower))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,stopwords("english")))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"donald trump"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"realdonaldtrump"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"trumps"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"falsenanaa"))
  interest_corpus <- tm_map(interest_corpus,function(x)removeWords(x,"href"))
  
}

getTwitterInterest <- function(mFile) {
  
  interest <<- read.csv(mFile, 
                       header = TRUE, 
                       row.names = NULL,
                       fill = TRUE)
  
  interest_list <- interest$text
  
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

TwitterTopicModel <- function(mCorpus) {
  
 
  interest.tdm <- TermDocumentMatrix(mCorpus)
  
  dtm <- as.DocumentTermMatrix(interest.tdm)
  
  rowTotals <- apply(dtm , 1, sum) #Find the sum of words in each Document
  dtm.new   <- dtm[rowTotals> 0, ]
  
  lda <- LDA(dtm.new, k = 6)
  tweetTopics <- terms(lda, 6)
  
}

TwitterAssociation <- function(mWord) {
  
  mCorpus <- Cleaning4Assocation(interest_corpus0)
  
  interest.tdm <- TermDocumentMatrix(mCorpus)
  
  findAssocs(interest.tdm,mWord,0.5)
  
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
        
        mTable1 <- reactive({
          # Change when the "update" button is pressed...
          
          input$topics
          
          isolate({
            withProgress({
              
              setProgress(message = "Processing Twitter Topic Table...")
              
              TwitterTopicModel(myCorpus)
              
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
       
        ## TrumpTable tab
        ## Add two tables
          
        output$table1 <- renderDataTable({
          
          
          xx <- mTable1()

        }, options = list(lengthMenu = c(6), pageLength = 6))
        
        output$table2 <- renderDataTable({
          
          yy <- mTable2()
          
        })

}
