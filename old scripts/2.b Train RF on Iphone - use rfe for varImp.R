

# load previous files
source(file = "0.Parallel cores.R")
source(file = "1.Load and explore.R")

# choose subset for modelling
IphoneData <- IphoneDataRAW

# Let's sample the data before using RFE
set.seed(123)
iphoneSample <- IphoneData[sample(1:nrow(IphoneData), 1000, replace=FALSE),]

# Set up rfeControl with randomforest, repeated cross validation and no updates
ctrl <- rfeControl(functions = rfFuncs, 
                   method = "repeatedcv",
                   repeats = 5,
                   verbose = FALSE)

# Use rfe and omit the response variable (attribute 59 iphonesentiment) 
rfeResults <- rfe(iphoneSample[,1:58], 
                  iphoneSample$iphonesentiment, 
                  sizes=(1:58), 
                  rfeControl=ctrl)

# Get results
rfeResults

# Plot results
plot(rfeResults, type=c("g", "o"))


#The resulting table and plot display each subset and its accuracy and kappa. 
# An asterisk denotes the the number of features that is judged the most optimal from RFE.
# create new data set with rfe recommended features
iphoneRFE <- IphoneData[,predictors(rfeResults)]

# add the dependent variable to iphoneRFE
iphoneRFE$iphonesentiment <- IphoneData$iphonesentiment

# review outcome
str(iPhoneRFE)