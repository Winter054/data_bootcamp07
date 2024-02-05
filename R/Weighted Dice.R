## Project 1: Weigthed Dice ---------------

## Create a dice.
die <- c(1:6)
args(sample)
sample(x = die, size = 2, replace = TRUE)

## Here's the dice!
die <- c(1:6)
dice <- c(sample(x = die, size = 2, replace = TRUE))
sum(dice)

## Put it in fx to re-roll everytime.
roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)
  sum(dice)
}

## We can fix size of the dice.
roll2 <- function(bones = 1:6) {
  dice <- sample(bones, size = 2, replace = TRUE)
  sum(dice)
}


## ----------------------------
## Download R package to Visualize the dice roll.
install.packages("ggplot2")
library("ggplot2")


## Test quick plot using scatterplot and histogram.
qplot

x <- c(-1, -0.8, -0.6, -0.4, -0.2,0, 0.2, 0.4, 0.6, 0.8, 1)
x
y <- x^3
y
qplot(x, y)

z <- c(1, 2, 2, 2, 3, 3)
qplot(z, binwidth = 1)

z2 <- c(1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4)
qplot(z2, binwidth = 1)

z3 <- c(0, 1, 1, 2, 2, 2, 3, 3, 4)
qplot(z3, binwidth = 1)

 
## Use replicate function to simulate dice roll results.
args(replicate)

rolls <- replicate(10000, roll())
qplot(rolls, binwidth = 1)

# Get help in sample to know how to use prob.
?sample
help(sample)

## Time to cheese! We have to weight our dice by prob.
## Rewrite the roll function.

# This will cause roll to pick 1 through 5 with 
# probability 1/8 and 6 with probability 3/8.
roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE,
                 prob = c(1/8, 1/8, 1/8, 1/8, 1/8, 3/8))
  sum(dice)
}

## Now we cheated let's see the result.
rolls <- replicate(10000, roll())
qplot(rolls, binwidth = 1)