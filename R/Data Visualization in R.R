library(tidyverse)

## Data Viz
## ggplot = grammar of graphics plot

## Base R (Not beautiful and hard to use):
plot(mtcars$mpg, mtcars$hp, pch = 16, col = "red")

boxplot(mtcars$mpg)

t1 <- table(mtcars$am)
barplot(t1)

hist(mtcars$mpg)

## ------------------------------------------------------------------------
#ggplot (beautiful and easy to use):

# Ex. one variable, numeric
ggplot(data = mtcars, mapping = aes(x = mpg)) + 
  geom_histogram(bins = 10)

ggplot(data = mtcars, mapping = aes(x = mpg)) + 
  geom_density()

ggplot(data = mtcars, mapping = aes(x = mpg)) + 
  geom_freqpoly()

# use usual one like this
ggplot(mtcars, aes(mpg)) + 
  geom_histogram(bins = 10)

p1 <- ggplot(mtcars, aes(mpg)) + 
  geom_histogram(bins = 5)

p2 <- ggplot(mtcars, aes(hp)) + 
  geom_histogram(bins = 10)

# curious
mtcars %>%
  filter(hp <= 200) %>%
  count()


## ---------------------------------------------------------------------
mtcars %>%
  mutate(am = ifelse(am == 0, "Auto", "Manual")) %>%
  count(am) %>%
  ggplot(aes(am, n)) + 
  geom_col()

# Summary table before creating a bar chart
#Approach 1 - Summary table + geom_col() use with summary table
t2 <- mtcars %>%
  mutate(am = ifelse(am == 0, "Auto", "Manual")) %>%
  count(am)

ggplot(t2, aes(x = am, y = n)) + 
  geom_col()

#Approach 2 - geom_bar() can use with raw dataframe
mtcars <- mtcars %>%
  mutate(am = ifelse(am == 0, "Auto", "Manual"))
View(mtcars)

ggplot(mtcars, aes(am)) +
  geom_bar()

#Two variables (numeric)
#Scatter plot
ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point(col = 'red', size = 5)

## ---------------------------------------------------------------------
## Session 2

#Data frame -> diamonds
glimpse(diamonds)
 diamonds %>%
   count(cut)

#Ordinal factor ใช้เรียงสูง กลาง ต่ำได้
temp <- c("high", "med", "low", "high")
temp <- factor(temp, levels = c("low", "med", "high"), ordered = TRUE)

#Frequency table
diamonds %>% 
  count(cut, color, clarity)

#Sample / use set seed to lock the result
set.seed(42)
diamonds %>%
  sample_n(5)

## fraction 1 = 100%data 0.1=10% data
diamonds %>%
  sample_frac(0.1)

diamonds %>%
  slice(500:510)

#Relationship (Pattern)
ggplot(diamonds %>% sample_n(5000), aes(carat, price)) +
  geom_point() +
  geom_smooth(method = "lm") 


p3 <- ggplot(diamonds %>% sample_n(500), aes(carat, price)) +
  geom_point() +
  geom_smooth(method = "loess") +
  geom_rug()

#Setting VS Mapping
colors()

#Setting (Manually set options)
ggplot(diamonds, aes(price)) + 
  geom_histogram(bins = 100, fill = 'saddlebrown')

ggplot(diamonds %>% sample_n(500), 
       aes(carat, price)) +
  geom_point(size = 5, alpha = 0.2, col = 'red')


#Mapping (Occurs in aesthetic function)
ggplot(diamonds %>% sample_n(500), 
       mapping = aes(carat, price, col = cut)) +
  geom_point(size = 5, alpha = 0.8) +
  theme_minimal() 

## Add label and color 
## from https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3
ggplot(diamonds %>% sample_n(500), 
       mapping = aes(carat, price, col = cut)) +
  geom_point(size = 5, alpha = 0.8) +
  theme_minimal() +
  labs(
    title = "Relationship between carat and price",
    x = "Carat",
    y = "Price (USD)",
    subtitle = "We found a positive relationship",
    caption = "Data source: diamonds (ggplot2)"
  ) +
  scale_color_brewer(type = "qual", palette = 2)

#Map color scale
p4 <- ggplot(mtcars, aes(hp, mpg, col = wt)) +
  geom_point(size = 5, alpha = 0.7) +
  theme_minimal() +
  scale_color_gradient(low = "green", high = "red")

## --------------------------------------------------------------
#Facet use to split chart
ggplot(diamonds %>% sample_n(5000), aes(carat, price)) +
  geom_point(alpha = 0.6) +
  geom_smooth(col = "red", fill = "gold") +
  theme_minimal() +
  facet_wrap( ~cut)

ggplot(diamonds %>% sample_n(500),  aes(carat, price)) +
  geom_point(alpha = 0.6) +
  geom_smooth(col = "red", fill = "gold") +
  theme_minimal() +
  facet_grid(cut ~ color)


## --------------------------------------------------------------
## Combine chart with patchwork
library(patchwork)
library(ggplot2)

qplot(mpg, data = mtcars, geom = "histogram", bins = 10)
qplot(hp, mpg, data = mtcars, geom = "point")
qplot(hp, data = mtcars, geom = "density")

p1 <- qplot(mpg, data = mtcars, geom = "histogram", bins = 10)
p2 <- qplot(hp, mpg, data = mtcars, geom = "point")
p3 <- qplot(hp, data = mtcars, geom = "density")

## quickplot
p1 + p2 + p3
(p1 + p2) / p3
p1 / p2 / p3
p1 / (p2 + p3)
(p1 + p2 + p3) /p4