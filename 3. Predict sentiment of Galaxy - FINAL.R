###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | PREDICT SENTIMENTS | VERSION 1.  | by ELSE       #
#                                                                             #
#       ...............................................................       
#                                                                             #
###############################################################################

LargeMatrixGalaxy <- load(file = "LargeMatrixGalaxyProcessed.rda")
str(LargeMatrixGalaxy)



# load the trained  models
Model <- load(file = "RFFitGalaxy - final.rda")


# make prediction with this model on test data
predSentimentGalaxy <- predict(RFFitGalaxy, LargeMatrixGalaxy)


# create a new column with predicted data
LargeMatrixGalaxy$predSentimentGalaxy <- predSentimentGalaxy

# check results
summary(LargeMatrixGalaxy$predSentimentGalaxy)

