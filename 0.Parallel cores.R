###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | SET UP PARALLEL CORES | VERSION 7.0 | by ELSE    #
#                                                                             #
#        makes computing quicker                                              #       
#                                                                             #
###############################################################################

# Required
library(doParallel)

# Find how many cores are on your machine
detectCores() # Result = Typically 4 to 6

# Create Cluster with desired number of cores. Don't use them all! Your computer is running other processes. 
cl <- makeCluster(2)

# Register Cluster
registerDoParallel(cl)

# Confirm how many cores are now "assigned" to R and RStudio
getDoParWorkers() # Result 2 

# Stop Cluster. After performing your tasks, stop your cluster: stopCluster(cl)