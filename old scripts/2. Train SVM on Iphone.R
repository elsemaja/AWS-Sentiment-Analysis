###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | TRAINING SVM ON IPHONE | VERSION . | by ELSE   #
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
trainData <- IphoneNZV

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
SVMFitIphone <- train(iphonesentiment~.,
                     data = setTraining,
                     method = "svmLinear",
                     trControl = FitControl)
SVMFitIphone
summary(SVMFitIphone)





# test the model on the setTest
#make sure the same set.seed is used as in the training script
set.seed(123)

#Make prediction with this model on test data
predSentimentIphone_SVM <- predict(SVMFitIphone, newdata = setTest)

#creates a new column with predicted data
setTest$predSentimentIphone_SVM <- predSentimentIphone_SVM

#make sure the same set.seed is used as in the training script
set.seed(123)


#make a confusion matrix between the column with predicted values
#and actual values from that dataset:
setTest$iphonesentiment <- as.factor(setTest$iphonesentiment)
setTest$predSentimentIphone_SVM <- as.factor(setTest$predSentimentIphone_SVM)
confusionMatrix(setTest$predSentimentIphone_SVM, setTest$iphonesentiment)

# transform to integer and check results
setTest$iphonesentiment <- as.integer(setTest$iphonesentiment)
setTest$predSentimentIphone_SVM <- as.integer(setTest$predSentimentIphone_SVM)
setTest$errors <- setTest$iphonesentiment - setTest$predSentimentIphone_SVM

plot(setTest$errors)


#see variable importance
varImp(SVMFitIphone)
varImp <- varImp(SVMFitIphone)
plot(varImp)
