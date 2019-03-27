###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | TRAINING C5.0 ON IPHONE | VERSION 7.0 | by ELSE  #
#                                                                             #
#       ...............................................................       
#                                                                             #
###############################################################################

# libraries ----
if (require(pacman) == FALSE) {
  install.packages('pacman')
}

pacman::p_load(readr, psych, ggplot2, dplyr, tidyverse, plotly, caret, corrplot)

# load the data or previous script 
IphoneData <- read.csv(file = "data/iphone_smallmatrix_labeled_8d.csv")


# make sure iphonesentiment is set as factor
IphoneSELECT$iphonesentiment <- as.factor(IphoneSELECT$iphonesentiment)

# partition the data based on equal distribution of the sentiments
set.seed(123)
indexTrain <- createDataPartition(y = IphoneSELECT$iphonesentiment, 
                                  p = .1, 
                                  list = FALSE)

# set training and testing set
setTraining <- IphoneSELECT[indexTrain,]
setTest <- IphoneSELECT[-indexTrain,]


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
c50FitIphone <- train(brand~.,
               data = training,
               method = "c50",
#               tuneGrid = parameterGrid,
               trControl = FitControl)
c50FitIphone




