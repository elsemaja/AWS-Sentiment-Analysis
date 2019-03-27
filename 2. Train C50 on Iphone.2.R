###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | TRAINING C5.0 ON IPHONE | VERSION 7.0 | by ELSE  #
#                                                                             #
#       ...............................................................       
#                                                                             #
###############################################################################

# load previous files
source(file = "0.Parallel cores.R")
source(file = "1.Load and explore.R")

# libraries ----
if (require(pacman) == FALSE) {
  install.packages('pacman')
}

pacman::p_load(readr, psych, ggplot2, dplyr, tidyverse, plotly, caret, C50, kknn, randomForest, corrplot)

IphoneDataRAW <- select(IphoneDataRAW, -iphonesentiment)



# choose your subset to train your model on
trainData <- IphoneDataRAW

# make sure iphonesentiment is set as factor
trainData$Recode <- as.factor(trainData$Recode)

# partition the data based on equal distribution of the sentiments
set.seed(123)
indexTrain <- createDataPartition(y = trainData$Recode, 
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
c50FitIphone <- train(Recode~.,
               data = setTraining,
               method = "C5.0",
               trControl = FitControl)
c50FitIphone






# test the model on the setTest
#make sure the same set.seed is used as in the training script
set.seed(123)

#Make prediction with this model on test data
predSentimentIphone <- predict(c50FitIphone, newdata = setTest)

#creates a new column with predicted data
setTest$predSentimentIphone <- predSentimentIphone

#make sure the same set.seed is used as in the training script
set.seed(123)


#make a confusion matrix between the column with predicted values
#and actual values from that dataset:

confusionMatrix(setTest$predSentimentIphone, setTest$Recode)

# transform to integer and check results
setTest$Recode <- as.integer(setTest$Recode)
setTest$predSentimentIphone <- as.integer(setTest$predSentimentIphone)
setTest$errors <- setTest$Recode - setTest$predSentimentIphone

plot(setTest$errors)


#see variable importance
varImp(c50FitIphone)
varImp <- varImp(c50FitIphone)
plot(varImp)



#plot importance of variables
#rfmtry4 <- randomForest(brand~., 
#                        data = training,
#                        mtry=4,
#                        importance=TRUE,
#                        proximity=TRUE)
#
#varImpPlot(rfmtry4,
 #          main = "Random Forest mtry=4")


