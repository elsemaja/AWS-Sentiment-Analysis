
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


# set working directory
setwd("~/Google Drive/BSSA - data analytics/Module 4 - AWS/Sentiment analysis")

# load training data file
LargeMatrix <- read.csv(file = "aws-large/output large 1/LargeMatrix.csv")

LargeMatrix[!complete.cases(LargeMatrix),] 
# explore the data
str(LargeMatrix)
summary(LargeMatrix)
names(LargeMatrix)


LargeMatrixIphone <- LargeMatrix

# do the same preprocess 
# make new columns of all the positive, negative and unclear words
LargeMatrixIphone$Pos <- LargeMatrixIphone$iphonecampos + LargeMatrixIphone$iphonedispos + LargeMatrixIphone$iphoneperpos + LargeMatrixIphone$iosperpos
LargeMatrixIphone$Neg <- LargeMatrixIphone$iphonecamneg + LargeMatrixIphone$iphonedisneg + LargeMatrixIphone$iphoneperneg + LargeMatrixIphone$iosperneg
LargeMatrixIphone$Unc <- LargeMatrixIphone$iphonecamunc + LargeMatrixIphone$iphonedisunc + LargeMatrixIphone$iphoneperunc + LargeMatrixIphone$iosperunc
LargeMatrixIphone <- select(LargeMatrixIphone, Pos, Neg, Unc, iphone, ios)


LargeMatrixIphone <- LargeMatrixIphone %>%
  filter(iphone >= 1)

str(LargeMatrixIphone)

save(LargeMatrixIphone, file = "LargeMatrixIphoneProcessed.rda")
