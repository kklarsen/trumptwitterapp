**DOCUMENTATION**

This document describes how my application can be used as well as the background for the various analysis carried out in the app.

**GET GOING WITH THIS APP**

There are 3 basic choices (i.e., radio buttons) to be made;

- **Trump's own Tweets (Default)**: Donald Trump's own tweets over the period 4 to 25th of October visualized with Wordcloud. Note the tweets includes everything from Original Tweets, Retweets to Favorites.
- **Other's Tweets on Trump**: Other Twitter user's tweets on Donald Trump, or more accurately tweets including "Donald Trump" in its body. Again this includes Original Tweets, Retweets and Favorites. **Note** generating the Wordcloud may take a couple of minutes.
- **Add Topics Tree**: The last choice is to add a Topics Tree next to the Wordcloud. For topical analysis hierachical clustering analysis is carried out on the Twitter data selected.

**Important: remember to always click the update button once a choice has been made. Otherwise the analysis may not update correctly!**

For the **Other's Tweets on Trump** selection you have the freedom to select any date between 4th and 25th of October. This is done clicking **Twitter Date of interest** (remember to click **Update** button). After the Wordcloud has been generated (which can take a couple of minutes) then you can select **Add Topics Tree** and a Topics Tree based on Tweets of the date selected will be generated.

Controlling the Wordcloud can be done by changing;

- **Cut-off Word Frequency (Wordcloud)** slider. This will cut-off words from the Wordcloud generation if their frequency is less than set by the slider.
- **Max. Number of Words (Wordcloud)** slider sets the maximum number of words to be included in the Wordcloud.

Controlling the Topic Tree can be done by changing;

- **Sparseness (Topics Tree)** slider set the level of sparseness (i.e., infrequent words) to consider in the clustering analysis. For this analysis best results are for a sparseness of 0.98 (default and means that most words are included in the analysis).
- **#Clusters (Topics Tree)** slider allows you to guess the appropriate number of k-clusters (or topics). Note if Sparseness is chosen lower normally k should be lower as well. **Note** an error message can occur if the sparseness has been chosen lower than 0.98 and Clusters are k = 5. Lowering k usually would allow the model to converge.   

**SUMMARY**

This application carries out textual mining on twitter data related to Donald Trump, republican presidential candidate, and his followers. Thus the data has two components;

- Twitter data from Donald Trump himself, i.e., realDonaldTrump. A total amount of 500+ tweets have been collected over the period.
- Twitter data mentioning "Donald Trump". A quarter of a million tweets was collected over the period.

**Up-to** 15,000 tweets (i.e., it can be less but not more) are extracted daily from October 4th and to Sunday October 25th.


**REFERENCES**

1. The code for this App can be found at GitHub following this link: [TrumpTwitterApp](https://github.com/kklarsen/trumptwitterapp).
2. Nathan Danneman & Richard Heimann, ["Social Media Mining with R"](https://www.packtpub.com/big-data-and-business-intelligence/social-media-mining-r), (2014), Packt Publishing.
2. Yanchang Zhao, ["Text Mining with R - Twitter Data Analysis"](http://www.rdatamining.com/docs/text-mining-with-r-of-twitter-data-analysis), (28 May 2015).
2. Jeffrey Breen, ["R by example: mining Twitter for consumer attitudes towards airlines."](https://jeffreybreen.wordpress.com/2011/07/04/twitter-text-mining-r-slides/), (June 2011).
3. On [Hierarchical Cluster Analysis in R](http://www.r-tutor.com/gpu-computing/clustering/hierarchical-cluster-analysis).
4. [Wikipedia on Hierachical Clustering](https://en.wikipedia.org/wiki/Hierarchical_clustering).
