###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | TRAINING KKNN ON IPHONE | VERSION 7.0 | by ELSE  #
#                                                                             #
#       ...............................................................       
#                                                                             #
###############################################################################

# libraries ----
if (require(pacman) == FALSE) {
  install.packages('pacman')
}

pacman::p_load(readr, psych, ggplot2, dplyr, tidyverse, 
               plotly, kknn, e1071, caret, kknn, randomForest, 
               kernlab, corrplot)

# choose your subset to train your model on
trainData <- IphoneSUBSET2

# make sure iphonesentiment is set as factor
trainData$iphonesentiment <- as.factor(trainData$iphonesentiment)

# partition the data based on equal distribution of the sentiments
set.seed(123)
indexTrain <- createDataPartition(y = trainData$iphonesentiment, 
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
#tune mtry parameter
#parameterGrid <- expand.grid(mtry=c(1:7))
#set the training parameters of the model
KKNNFitIphone <- train(iphonesentiment~.,
                      data = setTraining,
                      method = "kknn",
                      trControl = FitControl)
KKNNFitIphone
summary(KKNNFitIphone)





# test the model on the setTest
#make sure the same set.seed is used as in the training script
set.seed(123)

#Make prediction with this model on test data
predSentimentIphone_KKNN <- predict(KKNNFitIphone, newdata = setTest)

#creates a new column with predicted data
setTest$predSentimentIphone_KKNN <- predSentimentIphone_KKNN

#make sure the same set.seed is used as in the training script
set.seed(123)


#make a confusion matrix between the column with predicted values
#and actual values from that dataset:
setTest$iphonesentiment <- as.factor(setTest$iphonesentiment)
setTest$predSentimentIphone_KKNN <- as.factor(setTest$predSentimentIphone_KKNN)
confusionMatrix(setTest$predSentimentIphone_KKNN, setTest$iphonesentiment)

# transform to integer and check results
setTest$iphonesentiment <- as.integer(setTest$iphonesentiment)
setTest$predSentimentIphone_KKNN <- as.integer(setTest$predSentimentIphone_KKNN)
setTest$errors <- setTest$iphonesentiment - setTest$predSentimentIphone_KKNN

plot(setTest$errors)

#make scatterpot to look at the errors of prediction on test data
ggplot(setTest) + geom_point(aes(x = predSentimentIphone_KKNN, 
                                 y = iphonesentiment, 
                                 color = (errors != 0)))


#see variable importance
varImp <- varImp(KKNNFitIphone)
plot(varImp)