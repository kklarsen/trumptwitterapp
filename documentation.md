**DOCUMENTATION**

This document describes how my application can be used as well as the background for the various analysis carried out in the app.

**INTRO**

This application carries out textual mining on twitter data related to Donald Trump, republican presidential candidate, and his followers. Thus the data has two components;

- Twitter data from Donald Trump himself, i.e., realDonaldTrump. A total amount of 500+ tweets have been collected over the period.
- Twitter data mentioning "Donald Trump". A quarter of a million tweets was collected over the period.

**Up-to** 15,000 tweets (i.e., it can be less but not more) are extracted daily from October 4th and to Sunday October 25th.

**GET GOING WITH THIS APP**

This App have three tabs;

1. **TrumpCloud** is the primary tab providing a WordCloud based on Donald Trump related tweets as well as a Topic Tree that provides a view of the most important topics in the analyzed tweets. A great degree of users control has been given to both the WordCloud and Topic Tree structure.
2. **TrumpTable** is the secondary tab providing a topics table consisting of 6 topics (sorry not changeble this App) with 6 main items per topic (also fixed) and a word association table based on user inputs.
3. **Documentation** is what you read ... you found it! ;-)

**THE SIDEBAR**

There are 3 basic choices (i.e., radio buttons) to be made;

- **Trump's own Tweets (Default)**: Donald Trump's own tweets over the period 4 to 25th of October visualized with Wordcloud. Note the tweets includes everything from Original Tweets, Retweets to Favorites.
- **Other's Tweets on Trump**: Other Twitter user's tweets on Donald Trump, or more accurately tweets including "Donald Trump" in its body. Again this includes Original Tweets, Retweets and Favorites. **Note** generating the Wordcloud may take a couple of minutes.
- **Add Topics Tree**: The last choice is to add a Topics Tree next to the Wordcloud. For topical analysis hierachical clustering analysis is carried out on the Twitter data selected.

**Important: remember to always click the update button (i.e., the red one) once a choice has been made. Otherwise the analysis may not update correctly!**

For the **Other's Tweets on Trump** selection you have the freedom to select any date between 4th and 25th of October. This is done clicking **Twitter Date of interest** (remember to click **Update** button). After the Wordcloud has been generated (which can take a couple of minutes) then you can select **Add Topics Tree** and a Topics Tree based on Tweets of the date selected will be generated.

Controlling the Wordcloud can be done by changing;

- **Cut-off Word Frequency (Wordcloud)** slider. This will cut-off words from the Wordcloud generation if their frequency is less than set by the slider.
- **Max. Number of Words (Wordcloud)** slider sets the maximum number of words to be included in the Wordcloud.

Controlling the Topic Tree can be done by changing;

- **Sparseness (Topics Tree)** slider set the level of sparseness (i.e., infrequent words) to consider in the clustering analysis. For this analysis best results are for a sparseness of 0.98 (default and means that most words are included in the analysis).
- **#Clusters (Topics Tree)** slider allows you to guess the appropriate number of k-clusters (or topics). Note if Sparseness is chosen lower normally k should be lower as well. **Note** an error message can occur if the sparseness has been chosen lower than 0.98 and Clusters are k = 5. Lowering k usually would allow the model to converge.

The red **Update** button does exactly that. It should in general be pushed when changes have been made to the WordCloud and Topics Tree controls.

**TrumpTable - Topics** take you to the TrumpTable tab. In this tab you will find two tables;

1. **Topic Table** (6 main topics with 6 main key words) comes out of so-called LDA (Latent Dirichlet Allocation) (see ref. 4 below) analisys on the chosen twitter data (e.g., either Donald's own or his followers). It should be noted  that statistically the LDA may not be the best method as it inherently assumes that different topics are uncorrelated which is in many instances not the case. Nevertheless, the LDA method does in many instances give a pretty good idea of the main topics being debated. **Note** for the big twitter datasets (up-to 15k+ tweets) processing the Topic Table may take a couple of minutes.
2. The second Table, takes a word input (small letters) from the **"Enter word & find associations"** on the sidebar. As a default I have chosen **"dumb"** (e.g., which is a re-occuring theme in many of the "Donald Trump"tweets either from himself or his followers).This is input is user defined. **Note** In case your word has not been found no Table will be shown (which can also be an interesting message).

For example also try out; immigrants, mexican, clinton, etc...

**REFERENCES**

1. The code for this App can be found at GitHub following this link: [TrumpTwitterApp](https://github.com/kklarsen/trumptwitterapp).
2. Nathan Danneman & Richard Heimann, ["Social Media Mining with R"](https://www.packtpub.com/big-data-and-business-intelligence/social-media-mining-r), (2014), Packt Publishing.
3. Ingo Feinerer, Kurt Hornik, & David Meyer, ["Text Mining Infrastructure in R"](http://www.jstatsoft.org/article/view/v025i05/v25i05.pdf), J. Stat. Software, (March 2008), Vol. 25, Issue 5.
4. Bettina Grun & Kurt Hornik, ["topicmodels: An R Package for Fitting Topic Models"](https://cran.r-project.org/web/packages/topicmodels/vignettes/topicmodels.pdf),J. Stat. Software, (May 2011), Vol. 40, Issue 13. 
4. Ian Fellows, ["Package 'wordcloud'"](https://cran.r-project.org/web/packages/wordcloud/wordcloud.pdf), (Febr. 2015). Fellow's blog ["Fells Stats - know your data"](http://blog.fellstat.com/?cat=11) is a very recommendable source of what you can do with the "wordcloud" package.
2. Yanchang Zhao, ["Text Mining with R - Twitter Data Analysis"](http://www.rdatamining.com/docs/text-mining-with-r-of-twitter-data-analysis), (28 May 2015).
2. Jeffrey Breen, ["R by example: mining Twitter for consumer attitudes towards airlines."](https://jeffreybreen.wordpress.com/2011/07/04/twitter-text-mining-r-slides/), (June 2011).
3. On [Hierarchical Cluster Analysis in R](http://www.r-tutor.com/gpu-computing/clustering/hierarchical-cluster-analysis).
4. [Wikipedia on Hierachical Clustering](https://en.wikipedia.org/wiki/Hierarchical_clustering).
