###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | LOADING AND EXPLORING | VERSION 7.0 | by ELSE    #
#                                                                             #
#         Iphone data small matrix, galaxy data small matrix        
#                                                                             #
###############################################################################
# load previous files
source(file = "0.Parallel cores.R")

# libraries ----
if (require(pacman) == FALSE) {
  install.packages('pacman')
}

pacman::p_load(readr, psych, ggplot2, dplyr, tidyverse, plotly, caret, ROSE, corrplot)

# clean the data
# classify the attributes
# normalize or dummify the data if necessary



# set working directory
setwd("~/Google Drive/BSSA - data analytics/Module 4 - AWS/Sentiment analysis")

# load training data file
IphoneDataRAW <- read.csv("data/iphone_smallmatrix_labeled_8d.csv")
IphoneData <- IphoneDataRAW




# explore the data
str(IphoneData)
summary(IphoneData)




# check for missing data
IphoneData[!complete.cases(IphoneData),] 



# create a new dataset that will be used for recoding sentiment
IphoneData$recodedsentimentiphone <- recode(IphoneData$iphonesentiment, 
                               '0' = 1, 
                               '1' = 1, 
                               '2' = 1, 
                               '3' = 5, 
                               '4' = 5, 
                               '5' = 5) 


# make sure iphonesentiment is set as factor
IphoneData$recodedsentimentiphone <- as.factor(IphoneData$recodedsentimentiphone)


# remove old sentiments columns from the dataset
IphoneData <- select(IphoneData, -iphonesentiment)


# make new columns of all the positive, negative and unclear words
IphoneData$Pos <- IphoneData$iphonecampos + IphoneData$iphonedispos + IphoneData$iphoneperpos + IphoneData$iosperpos
IphoneData$Neg <- IphoneData$iphonecamneg + IphoneData$iphonedisneg + IphoneData$iphoneperneg + IphoneData$iosperneg
IphoneData$Unc <- IphoneData$iphonecamunc + IphoneData$iphonedisunc + IphoneData$iphoneperunc + IphoneData$iosperunc
IphoneData <- select(IphoneData, Pos, Neg, Unc, iphone, ios, recodedsentimentiphone)


names(IphoneData)


IphoneData <- IphoneData %>%
  filter(iphone >= 1)


#nearZeroVar() with saveMetrics = TRUE returns an object containing a table including: 
#frequency ratio, percentage unique, zero variance and near zero variance 

# check for columns with zeroVariance and remove them
nzvMetricsIphone <- nearZeroVar(IphoneData, saveMetrics = TRUE)
nzvIphone <- nearZeroVar(IphoneData, saveMetrics = FALSE) 
IphoneData <- IphoneData[,-nzvIphone]


# check for balance
IphoneBalance <- IphoneData %>% group_by(recodedsentimentiphone) %>% summarize(Class_count = n())
print(head(IphoneBalance))



# make sure to balance the dataset
IphoneData <- ovun.sample(recodedsentimentiphone~., 
                                      data=IphoneData,
                                      N=nrow(IphoneData), 
                                      p=0.5,
                                      seed=1, 
                                      method="both")$data

table(IphoneData$recodedsentimentiphone)

