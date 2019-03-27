###############################################################################
#                                                                             #
#   AWS SENTIMENT ANALYSIS | COMPARE TRAINED MODELS  | VERSION 7.0 | by ELSE  #
#                                                                             #
#       ...............................................................       
#                                                                             #
###############################################################################


ModelData <- resamples(list(CART = cartFit1, SVM = svmFit1, C50 = c50Fit1))

Summary(ModelData)