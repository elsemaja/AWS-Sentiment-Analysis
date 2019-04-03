# preprocess large matrix
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


LargeMatrixGalaxy <- LargeMatrix

# do the same preprocess 
LargeMatrixGalaxy <- select(LargeMatrixGalaxy, 
                     starts_with("samsung"), 
                     starts_with("google"), 
                     -id,
                     -contains("unc"))



LargeMatrixGalaxy <- LargeMatrixGalaxy %>%
  filter(samsunggalaxy >= 1)

save(LargeMatrixGalaxy, file = "LargeMatrixGalaxyProcessed.rda")




# remove the rows that do not mention iphone
LargeMatrixIphone <- LargeMatrixIphone %>%
  filter(iphone >= 1)







