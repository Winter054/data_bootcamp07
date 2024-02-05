install.packages("tidyverse")
install.packages("caret")

library(tidyverse)
library(caret)
library(readxl)

#Import data set
house_price_data <- read_xlsx("House Price India.xlsx")
glimpse(house_price_data)
View(house_price_data)


#Basic data visualization
ggplot(house_price_data, aes(Price)) +
  geom_histogram()

#The Price column is skewed positively
#Fix skewness by using log transformation
house_price_data_log <- house_price_data %>%
  mutate(Price_log = log(Price + 1))

view(house_price_data_log)

ggplot(house_price_data_log, aes(Price_log)) +
  geom_histogram()

# Rename column
house_price_renamed <- house_price_data_log %>%
  rename("Distance_from_the_airport" = "Distance from the airport",
         "grade_of_the_house" = "grade of the house",
         "condition_of_the_house" = "condition of the house",
         "living_area" = "living area", "lot_area" = "lot area")
glimpse(house_price_renamed)

#Train Test Split 70:30 function
train_test_split <- function(data, train_ratio = 0.7) {
  set.seed(42)
  n <- nrow(data)
  id <- sample(1 : n, size = train_ratio * n)
  train_data <- data[id, ]
  test_data <- data[-id, ]
  return( list(train = train_data, test = test_data) )
}

#1. Split Data
split_data <- train_test_split(house_price_renamed, 0.7)
train_data <- split_data[[1]]
test_data <- split_data[[2]]

#2. Train Data
#mpg = f(hp, wt, am)
#method = Algorithm
set.seed(42)

#Change Resampling Method (LOOCV, boot, cv) *USE cv
ctrl <- trainControl(
  method = "cv", #Golden Standard
  number = 5, #K = 5
  verboseIter = TRUE 
)

#Linear Regression Model
lm_model <- train(Price_log ~ Distance_from_the_airport + grade_of_the_house + 
                    condition_of_the_house + living_area + lot_area, 
                  data = train_data, method = "lm", 
                  trControl = ctrl)

#K-Nearest Neighbors Model
knn_model <- train(Price_log ~ Distance_from_the_airport + grade_of_the_house + 
                     condition_of_the_house + living_area + lot_area, 
                   data = train_data, method = "knn", 
                   trControl = ctrl)

#3. Score
p_lm <- predict(lm_model, newdata = test_data)
p_knn <- predict(knn_model, newdata = test_data)

#4. Evaluate
RMSE(test_data$Price_log, p_lm)
RMSE(test_data$Price_log, p_knn)

#5. Save Model
saveRDS(lm_model, "linear_regression_v1.RDS")
saveRDS(knn_model, "K_nearest_neighbors_v1.RDS")