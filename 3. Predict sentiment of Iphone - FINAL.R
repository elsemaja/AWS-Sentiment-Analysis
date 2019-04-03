###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | PREDICT SENTIMENTS | VERSION 1.  | by ELSE       #
#                                                                             #
#       ...............................................................       
#                                                                             #
###############################################################################


# load webscrape
IphoneData <- load(file = "LargeMatrixIphoneProcessed.rda")


# load the trained  model
Model <- load(file = "RFFitIphone - final.rda")


#Make prediction with this model on test data
predSentimentIphone <- predict(RFFitIphone, LargeMatrixIphone)


#create a new column with predicted data
LargeMatrixIphone$predSentimentIphone <- predSentimentIphone

# Check results
summary(LargeMatrixIphone$predSentimentIphone)
