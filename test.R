# Script to combine all models

#create column for positive words for iphone
#create column for unclear words for iphone
# create column for negative words for iphone

IphoneDataSUM <- IphoneDataRAW
IphoneDataSUM$IphonePositive <- IphoneDataRAW$iphonecampos + 
  IphoneDataRAW$iphonecampos + 
  IphoneDataRAW$iphonedispos + 
  IphoneDataRAW$iphoneperpos + 
  IphoneDataRAW$iosperpos

IphoneDataSUM$IphoneNegative <- IphoneDataRAW$iphonecamneg + 
  IphoneDataRAW$iphonecamneg + 
  IphoneDataRAW$iphonedisneg + 
  IphoneDataRAW$iphoneperneg + 
  IphoneDataRAW$iosperneg

IphoneDataSUM$IphoneNegative <- IphoneDataRAW$iphonecamunc + 
  IphoneDataRAW$iphonecamunc + 
  IphoneDataRAW$iphonedisunc + 
  IphoneDataRAW$iphoneperunc + 
  IphoneDataRAW$iosperunc


IphoneDataSUM <- select(IphoneDataRAW, -iphonecamunc, 
                        - iphonecamunc, - 
                          iphonedisunc, - 
                          iphoneperunc, - 
                          iosperunc, -
                          iphonecamneg, -
                          iphonecamneg, - 
                          iphonedisneg, - 
                          iphoneperneg, - 
                          iosperneg, -
                          iphonecampos, - 
                          iphonecampos, - 
                          iphonedispos, - 
                          iphoneperpos, - 
                          iosperpos)

# finish creating a new dataset with new columnns

