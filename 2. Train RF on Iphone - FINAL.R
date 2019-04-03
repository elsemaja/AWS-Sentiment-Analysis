###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | TRAINING RF ON IPHONE | VERSION 7.0 | by ELSE    #
#                                                                             #
#       ...............................................................       
#                                                                             #
###############################################################################

# libraries ----
if (require(pacman) == FALSE) {
  install.packages('pacman')
}

pacman::p_load(readr, psych, ggplot2, dplyr, tidyverse, plotly, caret, kknn, LiblineaR, randomForest, corrplot)

# load iPhone data
load(file = "IphoneDataProcessed.rda")

# choose your subset to train your model on
trainData <- IphoneData

# make sure recodedsentimentiphone is set as factor
trainData$recodedsentimentiphone <- as.factor(trainData$recodedsentimentiphone)

# partition the data based on equal distribution of the sentiments
set.seed(123)
indexTrain <- createDataPartition(y = trainData$recodedsentimentiphone, 
                                  p = .7, 
                                  list = FALSE)

# set training and testing set
setTraining <- trainData[indexTrain,]
setTest <- trainData[-indexTrain,]


#set control parameters, in this case cross validation
#default search = "random" 
#change it to "grid" if searching with Manual Grid?

FitControl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 1,
                           preProc = c("center", "scale"),
                           verboseIter = TRUE)


#set the training parameters of the model
RFFitIphone <- train(recodedsentimentiphone~.,
                      data = setTraining,
                      method = "rf",
                      trControl = FitControl)
RFFitIphone
summary(RFFitIphone)

save(RFFitIphone, file = "RFFitIphone - final.rda")



# test the model on the setTest
#make sure the same set.seed is used as in the training script
set.seed(123)

#Make prediction with this model on test data
predSentimentIphone_RF <- predict(RFFitIphone, newdata = setTest)

#creates a new column with predicted data
setTest$predSentimentIphone_RF <- predSentimentIphone_RF

#make sure the same set.seed is used as in the training script
set.seed(123)


#make a confusion matrix between the column with predicted values
#and actual values from that dataset:
setTest$recodedsentimentiphone <- as.factor(setTest$recodedsentimentiphone)
setTest$predSentimentIphone_RF <- as.factor(setTest$predSentimentIphone_RF)
caret :: confusionMatrix(setTest$predSentimentIphone_RF, setTest$recodedsentimentiphone)

# transform to integer and check results
setTest$recodedsentimentiphone <- as.integer(setTest$recodedsentimentiphone)
setTest$predSentimentIphone_RF <- as.integer(setTest$predSentimentIphone_RF)
setTest$errors <- setTest$recodedsentimentiphone - setTest$predSentimentIphone_RF

plot(setTest$errors)



#see variable importance
varImp(RFFitIphone)
varImp <- varImp(RFFitIphone)
plot(varImp)
