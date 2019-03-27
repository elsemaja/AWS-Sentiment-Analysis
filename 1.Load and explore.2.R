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

pacman::p_load(readr, psych, ggplot2, dplyr, tidyverse, plotly, caret, corrplot)

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
plot_ly(IphoneData, x= ~IphoneData$iphonesentiment, type='histogram')

# check for missing data
IphoneData[!complete.cases(IphoneData),] 

# make sure iphonesentiment is set as factor
IphoneData$iphonesentiment <- as.factor(IphoneData$iphonesentiment)

# check for correlation
# Check correlation and plot heatmap
#options(max.print=1000000)
#cor(IphoneDataSmall)
#iphoneCOR <- cor(IphoneDataSmall)
#corrplot(iphoneCOR, tl.cex = 0.5)
#cor(IphoneSUBSET)
#iphoneCOR2 <- cor(IphoneSUBSET)
#corrplot(iphoneCOR2, tl.cex = 1)

# create a new dataset that will be used for recoding sentiment
IphoneDataRAW$Recode <- recode(IphoneData$iphonesentiment, 
                               '0' = 1, 
                               '1' = 1, 
                               '2' = 1, 
                               '3' = 5, 
                               '4' = 5, 
                               '5' = 5) 

names(IphoneDataRAW)
summary(IphoneDataRAW$Recode)

# inspect results
summary(iphoneRC)
str(iphoneRC)

# make iphonesentiment a factor
iphoneRC$iphonesentiment <- as.factor(IphoneData$iphonesentiment)




#nearZeroVar() with saveMetrics = TRUE returns an object containing a table including: 
#frequency ratio, percentage unique, zero variance and near zero variance 
nzvMetrics <- nearZeroVar(IphoneData, saveMetrics = TRUE)
nzvMetrics

# nearZeroVar() with saveMetrics = FALSE returns an vector 
nzv <- nearZeroVar(IphoneData, saveMetrics = FALSE) 
nzv


# create a new data set and remove near zero variance features
IphoneNZV <- IphoneData[,-nzv]
str(IphoneNZV)



# subset only the attributes that say something about iphone 
IphoneSUBSET <- IphoneData %>%
  select(starts_with("iphone"), starts_with("ios"))


#nearZeroVar() with saveMetrics = TRUE returns an object containing a table including: 
#frequency ratio, percentage unique, zero variance and near zero variance 
nzvMetrics <- nearZeroVar(IphoneSUBSET, saveMetrics = TRUE)
nzvMetrics

# nearZeroVar() with saveMetrics = FALSE returns an vector 
nzv <- nearZeroVar(IphoneSUBSET, saveMetrics = FALSE) 
nzv


# create a new data set and remove near zero variance features
IphoneSUBSET <- IphoneSUBSET[,-nzv]
str(IphoneSUBSET)


# plot 
plot(IphoneSUBSET$iphone)

# remove the rows that do not mention iphone
IphoneSUBSET2 <- IphoneSUBSET %>%
  filter(iphone >= 1)

# make the data more balanced regarding sentiments





