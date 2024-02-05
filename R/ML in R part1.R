# caret = Classification and Regression Tree
library(caret)
library(tidyverse)

glimpse(mtcars)

## train test split
# 1. split data
# 2. train 
# 3. score
# 4. evaluate

# split data 80:20
set.seed(42)
n <- nrow(mtcars)
id <- sample(1:n, size = 0.8*n)

train_data <- mtcars[id, ]
test_data <- mtcars[-id, ]

# train
model <- lm(mpg ~ hp + wt + am, data = train_data)

# score
mpg_pred <- predict(model, newdata = test_data)

# evaluate
# Mean absolute error(MAE), Mean square error(MSE), RootMSE(RMSE)

# MAE Treat every data point the same
mae_metric <- function(actual, prediction) {
  abs_error <- abs(actual - prediction)
  mean(abs_error)
}

# MSE Punish the wrong data prediction more and make error increase
mse_metric <- function(actual, prediction) {
  sq_error <- (actual - prediction)**2
  mean(sq_error)
}

# RMSE remove sqrt to make data unit back to normal
rmse_metric <- function(actual, prediction) {
  sq_error <- (actual - prediction)**2
  sqrt(mean(sq_error))
}

# Build a train test data function
train_test_split <- function(data, train_ratio = 0.7) {
  set.seed(42)
  n <- nrow(data)
  id <- sample(1 : n, size = train_ratio * n)
  train_data <- data[id, ]
  test_data <- data[-id, ]
  
  return( list(train = train_data, test = test_data) )
}

set.seed(42)
split_data <- train_test_split(mtcars, 0.7)
train_data <- split_data$train
test_data <- split_data$test ##split_data[["test"]]


## Caret = Classification and Regression Tree
## Supervised Learning = Prediction

# 1. split data
splitData <- train_test_split(mtcars, 0.7)
train_data <- split_data[[1]]
test_data <- split_data[[2]]

# 2. train model
# mpg = f(hp, wt, am)
set.seed(42)

ctrl <- trainControl(
  method = "cv", # k-fold golden standard
  number = 5,
  verboseIter = TRUE
)

lm_model <- train(mpg ~ hp + wt + am, 
               data = train_data,
               method = "lm",
               trControl = ctrl) 

rf_model <- train(mpg ~ hp + wt + am, 
                  data = train_data,
                  method = "rf",
                  trControl = ctrl) 

knn_model <- train(mpg ~ hp + wt + am, 
                  data = train_data,
                  method = "knn",
                  trControl = ctrl) 

# 3. score model
p <- predict(model, newdata = test_data)

# 4. evaluate model
rmse_metric(test_data$mpg, p)

# 5. save model
saveRDS(model, "linear_regression_v1.RDS")

# On friend's PC
# Read model into R environment
(new_cars <- data.frame(
  hp = c(100, 150, 250),
  wt = c(1.25, 2.2, 2.25),
  am = c(0, 1, 1)
))

model <- readRDS("linear_regression_v1.RDS")

new_cars$mpg_pred <- predict(model, newdata = new_cars)
View(new_cars)
