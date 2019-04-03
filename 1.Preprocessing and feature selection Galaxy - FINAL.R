###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | LOADING AND EXPLORING | VERSION 7.0 | by ELSE    #
#                                                                             #
#                         Preprossessing Galaxy Data                          #
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

# Load the small matrix
GalaxyDataRAW <- read.csv("data/galaxy_smallmatrix_labeled_8d.csv")
GalaxyData <- GalaxyDataRAW

# check for incompete rows
GalaxyData[!complete.cases(GalaxyData),] 

# check for the distribution in sentiment
GalaxyBalance <- GalaxyData %>% group_by(galaxysentiment) %>% summarize(Class_count = n())
print(head(GalaxyBalance))

# recode the sentiment into negative =1 and positive = 5
GalaxyData$recodedsentimentgalaxy <- recode(GalaxyData$galaxysentiment, 
                                            '0' = 1, 
                                            '1' = 1, 
                                            '2' = 1, 
                                            '3' = 5, 
                                            '4' = 5, 
                                            '5' = 5) 

# process recoded sentiment as factor
GalaxyData$recodedsentimentgalaxy <- as.factor(GalaxyData$recodedsentimentgalaxy)

# select the features 
GalaxyData <- select(GalaxyData, 
                     starts_with("samsung"), 
                     starts_with("google"), 
                     -galaxysentiment,
                     samsunggalaxy,
                     recodedsentimentgalaxy,
                     -contains("unc"))

# filter that samung galaxy is mentioned at least once
GalaxyData <- GalaxyData %>%
  filter(samsunggalaxy >= 1)



# balance the data, otherwise the model will have bias
GalaxyData <- ovun.sample(recodedsentimentgalaxy~., 
                          data=GalaxyData,
                          N=nrow(GalaxyData), 
                          p=0.5,
                          seed=1, 
                          method="both")$data

# check the new distribution
table(GalaxyData$recodedsentimentgalaxy)

# save the file to load it in another script
save(GalaxyData, file = "GalaxyDataProcessed.rda")
