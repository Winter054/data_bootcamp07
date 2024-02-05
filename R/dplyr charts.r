## Test
install.packages("dplyr")
library(dplyr)

# Correct Ans
mtcars %>% select(hp, wt, am)
mtcars %>% select(11, everything())
select(mtcars, hp, wt, am)
mtcars %>% select(1, 2:5, 10)
mtcars %>% select(starts_with("a"))


# Wrong it can work but not dplyr R (%>%)
select(mtcars, hp, wt, am)


# Load required package
install.packages("ggplot2")
library(ggplot2)

# Create a histogram
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(binwidth = 3, fill = "blue", color = "black") +
  labs(title = "Distribution of MPG", x = "Miles Per Gallon", y = "Frequency")




# Create a bar chart
ggplot(mtcars, aes(x = factor(gear))) +
  geom_bar(fill = "green", color = "black") +
  labs(title = "Distribution of Gears", x = "Number of Gears", y = "Frequency")

# Generate example data
set.seed(123)
exam_data <- data.frame(ExamA = rnorm(50, mean = 75, sd = 10),
                        ExamB = rnorm(50, mean = 70, sd = 15))

# Create a scatter plot
library(ggplot2)
ggplot(exam_data, aes(x = ExamA, y = ExamB)) +
  geom_point(color = "purple") +
  labs(title = "Relationship between Exam A and Exam B",
       x = "Exam A Score", y = "Exam B Score")



# Create example data
data <- data.frame(x = c(1, 2, 3, 4, 5),
                   y1 = c(3, 8, 5, 2, 7),
                   y2 = c(6, 3, 9, 4, 2))

# Create a ggplot chart with multiple layers
ggplot(data, aes(x)) +
  geom_bar(aes(y = y1), stat = "identity", fill = "blue") +
  geom_line(aes(y = y2), color = "red") +
  labs(title = "Chart with Stacked Layers",
       x = "X-axis Label",
       y = "Y-axis Label")

