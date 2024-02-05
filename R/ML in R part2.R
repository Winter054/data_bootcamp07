# install library
install.packages(c("caret", "tidyverse", "rpart", "mlbench", 
                   "randomForest", "class", "glmnet"))

library(caret)
library(tidyverse)
library(rpart)
library(mlbench)
library(randomForest)
library(class)
library(glmnet)
library(MLmetrics)

## see availiable data
data()
data("BostonHousing")

df <- BostonHousing
glimpse(df)

## clustering => segmentation

subset_df <- df %>%
  select(crim, rm, age, lstat, medv) %>%
  as_tibble()

## clustering algorithm is K, test different k (k=2-5)
## x = dataset, center = k
kmeans(x = subset_df, center = 3)

result <- kmeans(x = subset_df, center = 3)
result$cluster

## membership [1,2,3]
subset_df$cluster <- result$cluster


## Build model -----------------------------------------------------
## lm, knn
as_tibble(df)

# 1. split data ------------------------
set.seed(42)
n <- nrow(df)
id <- sample(1:n, size = 0.8*n)
train_data <- df[id, ]
test_data <- df[-id, ]
glimpse(train_data)

## 2. train model -----------------------
# median value price(medv) = f(crim, rm, age)
lm_model_p2 <- train(medv ~ crim + rm + age,
                   data = train_data,
                   method = "lm",
                   preProcess = c("center", "scale"))

# bad rmse bc data is on different scale must do standardization
# center and scale
set.seed(42)

ctrl <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE)

# grid search = custom k in knn
k_grid <- data.frame(k = c (3,5,7,9,11))

knn_model_p2 <- train(medv ~ crim + rm + age,
                   data = train_data,
                   method = "knn",
                   metric = "Rsquared",
                   tuneGrid = k_grid,
                   preProcess = c("center", "scale"),
                   trControl = ctrl) 

# tuneLenght is random search
knn_model_p2 <- train(medv ~ crim + rm + age,
                      data = train_data,
                      method = "knn",
                      metric = "Rsquared",
                      tuneLength = 5,
                      preProcess = c("center", "scale"),
                      trControl = ctrl) 

# trade off acc vs explainability
# knn vs lm
lm_model_p2$finalModel

# 3. score -----------------------------
p <- predict(knn_model_p2, newdata = test_data)

# 4. evaluate --------------------------
RMSE(p, test_data$medv)


## --------------------------------------------------------------------

## classification problem
data("PimaIndiansDiabetes")
glimpse(PimaIndiansDiabetes)
df <- PimaIndiansDiabetes

# re level data
df$diabetes <- fct_relevel(df$diabetes, "pos")


# 1. split data
set.seed(42)
n <- nrow(df)
id <- sample(1:n, size = 0.8*n)
train_data <- df[id, ]
test_data <- df[-id, ]
glimpse(train_data)

# 2. train model ( . = fx of all variable in dataset)
set.seed(42)
ctrl <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE)

(knn_model <- train(diabetes ~ .,
                   data = train_data,
                   method = "knn",
                   preProcess = c("center", "scale"),
                   metric = "Accuracy", 
                   trControl = ctrl))

# 3. score
p <- predict(knn_model, newdata = test_data)

# 4. evaluate confusion metric
table(test_data$diabetes, p, dnn = c("Actual", "Prediction"))

confusionMatrix(p, test_data$diabetes, positive = "pos",
                mode = "prec_recall")


## -----------------------------------------------------------------------
## Logistic Regression

set.seed(42)
ctrl <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE)

(logit_model <- train(diabetes ~ .,
                    data = train_data,
                    method = "glm",
                    metric = "Accuracy", 
                    trControl = ctrl))

logit_model$finalModel

## -----------------------------------------------------------------------
## Decision Tree

(tree_model <- train(diabetes ~ .,
                    data = train_data,
                    method = "rpart",
                    metric = "Accuracy", 
                    trControl = ctrl))

library(rpart.plot)
rpart.plot(tree_model$finalModel) 


## -----------------------------------------------------------------------
## Random Forest
## Model acc push to >= 78%

# mtry = number of feature(col) use to train model
# bootstrap sampling
mtry_grid <- data.frame(mtry = 2:8)

(rf_model <- train(diabetes ~ .,
                     data = train_data,
                     method = "rf",
                     metric = "Accuracy",
                     tuneGrid = mtry_grid,
                     trControl = ctrl))

## ---------------------------------------------------
## compare models

list_models <- list(knn = knn_model,
                    logistic = logit_model,
                    decisiontree = tree_model,
                    randomforest = rf_model,
                    ridgelasso = glmnet_model)

result <- resamples(list_models)

summary(result)

## ---------------------------------------------------
## Regularized Regression
#  Regularization is a key technique in ML to reduce overfitting

## Ridge Regression vs Lasso Regression

glmnet_grid <- expand.grid(alpha = 0:1,
                          lambda = c(0.1, 0.2, 0.3))

# alpha 0 = ridge, 1 = lasso
(glmnet_model <- train(diabetes ~ .,
                   data = train_data,
                   method = "glmnet",
                   metric = "Accuracy",
                   tuneGrid = glmnet_grid,
                   trControl = ctrl))
