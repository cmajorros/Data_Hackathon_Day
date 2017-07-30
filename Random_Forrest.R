
DataSet <- read.csv("dataset.csv")
head(DataSet)
str(DataSet)

#convert continue factors to categories factors
DataSet$Status <- as.factor(DataSet$Status)
DataSet$Acct_Age <- ifelse(DataSet$Acc_Age <= 7 ,'less than or equal 7', ifelse(DataSet$Acc_Age <= 14, "8-14 days", ifelse(DataSet$Acc_Age <= 21, "15-21", ifelse(DataSet$Acc_Age <= 28, "22-28", ifelse(DataSet$Acc_Age <= 35 , "29-35", ifelse(DataSet$Acc_Age <= 42, "36-42", ifelse(DataSet$Acc_Age <= 49, "43- 49" ,"greater than 49")  ))) )) )

str(DataSet)
DataSet2 <- DataSet[c("Acct_Age", "Have_Reward", "objecttype", "action", "Status")]
DataSet2$Acct_Age <- as.factor(DataSet2$Acct_Age) 
str(DataSet2)

# Replace Data

Mode <- function (x, na.rm) {
  xtab <- table(x)
  xmode <- names(which(xtab == max(xtab)))
  if (length(xmode) > 1) xmode <- ">1 mode"
  return(xmode)
}




for (var in 1:ncol(DataSet2)) {
  if (class(DataSet2[,var])=="numeric") {
    DataSet2[is.na(DataSet2[,var]),var] <- mean(DataSet2[,var], na.rm = TRUE)
  } else if (class(DataSet2[,var]) %in% c("character", "factor")) {
    DataSet2[is.na(DataSet2[,var]),var] <- Mode(DataSet2[,var], na.rm = TRUE)
  }
}

print(DataSet2)




# Data Patition 
set.seed(123)
ind <- sample(2,nrow(DataSet2), replace = TRUE, prob = c(0.7, 0.3))
train <- DataSet2[ind == 1,]
test <- DataSet2[ind == 2,]

# Random Forest Model
library(randomForest)
set.seed(123)
rf <- randomForest(Status~., data = train)
rf
### from No. of trees = 500 

#Create Confusion Matrix 
library(caret)
Predict_Train <- predict(rf, train)
confusionMatrix(Predict_Train, train$left)
## Result for accuracy is 0.9998 

#Predict testing data and create confusion matrix
Predict_Test <- predict(rf, test)
confusionMatrix(Predict_Test, test$left)
### Notice that accuracy is declined

# check the error rate and the optimal number of trees 
plot(rf)


## tuning rf model
NewRF <- tuneRF(train[-10], train[10], stepFactor =  1, plot = TRUE, ntreeTry = 80, trace =  TRUE, improve = 0.05) ##number in train[n] must be equal to the number of predictors 

# plot histogram Number of Nodes in trees
hist(treesize(rf), main = "Nodes of Random Forest")
#From the plot most of tree are grow with at 90 nodes

#Variable Importance
varImpPlot(rf)

importance(rf) ## show importance of variable
varUsed(rf) ##show number of using of variable
