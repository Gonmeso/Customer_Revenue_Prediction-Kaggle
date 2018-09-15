# Knowing that some of the columns have Jsons, lets flatten them up
library(tidyverse)

train <- read_csv('Input/train.csv')
test <- read_csv('Input/test.csv')

head(train)

# As we can see some of the columns are json so we need to extract them
library(jsonlite)

# Property of MrLong Kernel <- https://www.kaggle.com/mrlong/r-flatten-json-columns-to-make-single-data-frame
tic <- proc.time()
tr_device <- paste("[", paste(train$device, collapse = ","), "]") %>% fromJSON(flatten = T)
tr_geoNetwork <- paste("[", paste(train$geoNetwork, collapse = ","), "]") %>% fromJSON(flatten = T)
tr_totals <- paste("[", paste(train$totals, collapse = ","), "]") %>% fromJSON(flatten = T)
tr_trafficSource <- paste("[", paste(train$trafficSource, collapse = ","), "]") %>% fromJSON(flatten = T)

te_device <- paste("[", paste(test$device, collapse = ","), "]") %>% fromJSON(flatten = T)
te_geoNetwork <- paste("[", paste(test$geoNetwork, collapse = ","), "]") %>% fromJSON(flatten = T)
te_totals <- paste("[", paste(test$totals, collapse = ","), "]") %>% fromJSON(flatten = T)
te_trafficSource <- paste("[", paste(test$trafficSource, collapse = ","), "]") %>% fromJSON(flatten = T)
print(proc.time()-tic)
rm(tic)

head(tr_device)

# Append the new created dataframes
train <- cbind(train, tr_device, tr_geoNetwork, tr_totals, tr_trafficSource)
test <- cbind(test, te_device, te_geoNetwork, te_totals, te_trafficSource)

drops <- c('device','geoNetwork','totals','trafficSource')
train <- train[,!names(train) %in% drops]
test <- test[,!names(test) %in% drops]

rm(tr_device)
rm(tr_geoNetwork)
rm(tr_totals)
rm(tr_trafficSource)
rm(te_device)
rm(te_geoNetwork)
rm(te_totals)
rm(te_trafficSource)


# Check constant columns and drop them
constantColumnsTrain <- apply(train,2, function(x) length(unique(x)) == 1)
constantColumnsTest <- apply(test,2, function(x) length(unique(x)) == 1)

trainCstNames <- names(train)[constantColumnsTrain]
testCstNames <- names(test)[constantColumnsTest]

train <- train[, !names(train) %in% trainCstNames]
test <- test[, !names(test) %in% testCstNames]

# Write the flatten and non-constant datasets

write_csv(train, 'extraFiles/flattenTrain.csv')
write_csv(train, 'extraFiles/flattenTest.csv')
