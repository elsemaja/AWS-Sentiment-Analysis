###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | TRAINING RF ON Galaxy | VERSION 1.0 | by ELSE    #
#                                                                             #
#       ...............................................................       
#                                                                             #
###############################################################################

# load previous files
source(file = "0.Parallel cores.R")

# libraries ----
if (require(pacman) == FALSE) {
  install.packages('pacman')
}

pacman::p_load(readr, psych, ggplot2, dplyr, tidyverse, 
               plotly, caret, C50, kknn, randomForest, corrplot)

load(file = "GalaxyDataProcessed.rda")


# choose your subset to train your model on
trainData <- GalaxyData

# make sure iphonesentiment is set as factor
trainData$recodedsentimentgalaxy <- as.factor(trainData$recodedsentimentgalaxy)

# partition the data based on equal distribution of the sentiments
set.seed(123)
indexTrain <- createDataPartition(y = trainData$recodedsentimentgalaxy, 
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
                           verboseIter = TRUE)
#tune mtry parameter
#parameterGrid <- expand.grid(mtry=c(1:7))

#set the training parameters of the model
RFFitGalaxy <- train(recodedsentimentgalaxy~.,
                      data = setTraining,
                      method = "rf",
                      preProc = c("center", "scale"),
                      trControl = FitControl)
RFFitGalaxy

# save the model to load them in the prediction script
save(RFFitGalaxy, file = "RFFitGalaxy - final.rda")




# test the model on the setTest
#make sure the same set.seed is used as in the training script
set.seed(123)

#Make prediction with this model on test data
predSentimentGalaxy <- predict(RFFitGalaxy, newdata = setTest)

#creates a new column with predicted data
setTest$predSentimentGalaxy <- predSentimentGalaxy

#make sure the same set.seed is used as in the training script
set.seed(123)


#make a confusion matrix between the column with predicted values
#and actual values from that dataset:

confusionMatrix(setTest$predSentimentGalaxy, setTest$recodedsentimentgalaxy)

# transform to integer and check results
setTest$recodedsentimentgalaxy <- as.integer(setTest$recodedsentimentgalaxy)
setTest$predSentimentGalaxy <- as.integer(setTest$predSentimentGalaxy)
setTest$errors <- setTest$recodedsentimentgalaxy - setTest$predSentimentGalaxy

plot(setTest$errors)


#see variable importance
varImp(RFFitGalaxy)
varImp <- varImp(RFFitGalaxy)
plot(varImp)

