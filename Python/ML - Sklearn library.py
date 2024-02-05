### ML with sklearn
# Find 3 algorithm of sklearn
# Use it to train and find a good fit model


# import 3 model and simple ml pipeline
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import train_test_split
import pandas as pd
import numpy as np

mtcars = pd.read_csv("https://gist.githubusercontent.com/seankross/a412dfbd88b3db70b74b/raw/5f23f993cd87c283ce766e7ac6b329ee7cc2e1d1/mtcars.csv")
mtcars.head()

# prepare data take 50-80% times in total to do ml
X = mtcars[ ["hp", "wt", "qsec", "vs", "am"]]
y = mtcars[ "mpg" ]

# split data 80:20
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# train model
model = KNeighborsRegressor()
model.fit(X_train, y_train)

# test model/ score
pred = model.predict(X_test)

# evaluate
# MAE mean absolute error
mae = np.mean(np.absolute(y_test - pred))
# MSE
mse = np.mean((y_test - pred)**2)


print(mae, mse)

lm_result = [mae, mse]
print(lm_result)

rf_result = [mae, mse]
print(rf_result)

knn_result = [mae, mse]
print(knn_result)


### The winner is linear model!