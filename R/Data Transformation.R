## Prerequisites
# Focus on how to use the dplyr and tidyverse package. 
# We’ll illustrate the key ideas using data from the nycflights13 package,
# and use ggplot2 to help us understand the data.
install.packages("dplyr")
install.packages("tidyverse")
install.packages("nycflights13")
install.packages("ggplot2")

library(tidyverse)
library(dplyr)
library(nycflights13)
library(ggplot2)
View(flights)

flights
#Tibbles are data frames, but slightly tweaked to work better in the tidyverse.


# ------------------------------------------------------------------------
## Filter Rows with filter()
# Ex., we can select all flights on January 1st with:
filter(flights, month == 1, day == 1)
jan1 <- filter(flights, month == 1, day == 1)

# R either prints out the results, or saves them to a variable. 
# If you want to do both, you can wrap the assignment in parentheses:
(dec25 <- filter(flights, month == 12, day == 25))

# Comparisons
sqrt(2) ^ 2 == 2
1 / 49 * 49 == 1

# Computers  can’t store an infinite number of digits)
# so remember that every number you see is an approximation.
# Instead of relying on ==, use near():
near(sqrt(2) ^ 2,  2)
near(1 / 49 * 49, 1)

# -------------------------------------------------
## Logical Operators
# Use boolean operator &, |, xor
filter(flights, month == 11 | month == 12)

filter(flights, month == (11 | 12))
# You can’t write boolean like this bc if month == 11,12 it's return true = 1

# A useful short-hand for this problem is x %in% y
# This will select every row where x is one of the values in y.
nov_dec <- filter(flights, month %in% c(11, 12))

# Find flights that weren’t delayed (on arrival or departure)
# by more than two hours,
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# ------------------------------------------------------------------------
## Missing values
# R can make comparison tricky by missing values, or NAs (“not availables”). 
# NA is “contagious”: any operation involving an NAs will also be unknown.
# missing values
NA > 5
10 == NA
NA + 10
NA / 2
NA == NA

x <- NA
y <- NA
x == y

is.na(x)

# filter() only includes rows where the condition is TRUE;
# it excludes both FALSE and NA values.  
# If you want to preserve missing values, ask for them explicitly:
df <- tibble(x = c(1, NA, 3))

filter(df, x > 1)
filter(df, is.na(x) | x > 1)

# ------------------------------------------------------------------------
## Exercises 5.2.1, 
## 1.Find all flights that
# 1.1 Had an arrival delay of two or more hours
flights %>% 
  select(flight, arr_delay) %>% 
  filter(arr_delay >= 120)

# 1.2 Flew to Houston (IAH or HOU)
flights %>% 
  select(flight, dest) %>% 
  filter(dest %in% c("IAH", "HOU"))

# 1.3 Were operated by United, American, or Delta
flights %>% 
  select(flight, carrier) %>% 
  filter(carrier %in% c("AA", "UA", "DL"))

# 1.4 Departed in summer (July, August, and September)
flights %>% 
  select(flight, month) %>% 
  filter(month %in% c(7, 8, 9))

# 1.5 Arrived more than two hours late, but didn’t leave late
flights %>% 
  select(flight, arr_delay, dep_delay) %>% 
  filter(arr_delay >= 120 & dep_delay <=0 )

# 1.6 Were delayed by at least an hour, but made up over 30 minutes in flight
flights %>% 
  select(flight, dep_delay, arr_delay) %>% 
  filter(dep_delay >= 60 & dep_delay - arr_delay > 30)

# 1.7 Departed between midnight and 6am (inclusive)
flights %>% 
  select(flight, dep_time) %>% 
  filter(dep_time >= 0, dep_time <= 600)

## 2.Another useful dplyr filtering helper is between(). What does it do? 
## Can you use it to simplify the code needed to answer the previous challenges?
flights %>% 
  select(flight, month) %>% 
  filter(flights, between(month, 7, 9))

## 3.How many flights have a missing dep_time? 
## What other variables are missing? What might these rows represent?
summary(flights) # can count na

flights %>% 
  select(flight, dep_time) %>% 
  filter(is.na(dep_time))

filter(flights, is.na(dep_time))
# arr_time, air_time also missing so it might be cancelled flights

## 4.Why is NA ^ 0 not missing? Why is NA | TRUE not missing? 
## Why is FALSE & NA not missing? Can you figure out the general rule?
## (NA * 0 is a tricky counterexample!)
NA ^ 0 
NA | TRUE
# since for all numeric values x ^ 0 = 1 and TRUE = 1

NA | FALSE
# The value is unknown since TRUE | FALSE == TRUE, but FALSE | FALSE == FALSE.

NA & TRUE
# The value is unknown since FALSE & TRUE== FALSE, but TRUE & TRUE == TRUE.

NA * 0
# x*0 = 0 but 0 × ∞ are undefined so it's NA

# ------------------------------------------------------------------------
## Arrange rows with arrange() 
# arrange() works similarly to filter() except that instead of selecting rows, 
# it changes their order.

arrange(flights, year, month, day)
arrange(flights, desc(dep_delay))

# Missing values are always sorted at the end:
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

## Exercise 5.3.1,
# 1.How could you use arrange() to sort all missing values to the start? 
# (Hint: use is.na()).
arrange(df, desc(is.na(df))) 
arrange(flights, desc(is.na(dep_time)))
arrange(flights, desc(is.na(dep_time)), dep_time)

# 2.Sort flights to find the most delayed flights. 
# Find the flights that left earliest.
arrange(flights, desc(dep_delay))
arrange(flights, dep_delay)

flights %>% 
  select(flight, dep_delay) %>%
  arrange(dep_delay)
# 3.Sort flights to find the fastest (highest speed) flights.
arrange(flights, desc(distance / air_time))

flights %>% 
  select(flight, distance, air_time) %>% 
  arrange(desc(distance / air_time))

# 4.Which flights travelled the farthest? Which travelled the shortest?
# by distance
arrange(flights, desc(distance))
arrange(flights, distance)

# by time
arrange(flights, desc(air_time))
arrange(flights, air_time)

# ------------------------------------------------------------------------
## Select columns with select()
# select()allows you to rapidly zoom in on a useful subset 
# using operations based on the names of the variables.

## 5.4.1 Exercises
# 1.Brainstorm as many ways as possible to select dep_time, dep_delay, 
# arr_time, and arr_delay from flights.
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, 1, 2, 3, 4)
select(flights, all_of(c("dep_time", "dep_delay", "arr_time", "arr_delay")))
select(flights, any_of(c("dep_time", "dep_delay", "arr_time", "arr_delay")))
variables <- c("dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, all_of(variables))

select(flights, starts_with("dep_"), starts_with("arr_"))
select(flights, matches("^(dep|arr)_(time|delay)$"))
transmute(flights, dep_time, dep_delay, arr_time, arr_delay)

# 2.What happens if you include the name of a variable multiple times 
# in a select() call?
select(flights, dep_time)
select(flights, dep_time, dep_time, dep_time)

select(flights, year, month, day)
select(flights, year, month, day, year, year)
# The select() call ignores the duplication
# It's not gonna dupe the data inside tibble

# 3.What does the any_of() function do? 
# Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, any_of(vars))
select(flights, vars)
# We didn't have to type all column everytime, just put it in R object

# 4.Does the result of running the following code surprise you? 
# How do the select helpers deal with case by default? 
# How can you change that default?
select(flights, contains("TIME"))
# It ignore case (lower case and upper case)

# Change that default by contains function it has ignore.case parameter
select(flights, contains("TIME", ignore.case = FALSE))


# ------------------------------------------------------------------------
## Add new variables with mutate() 
# mutate() always adds new columns at the end of your dataset
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

# If you only want to keep the new variables, use transmute():
transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)
select(flights, )

## 5.5.2 Exercises
# 1.Currently dep_time and sched_dep_time are convenient to look at, 
# but hard to compute with because they’re not really continuous numbers. 
# Convert them to a more convenient representation of number of minutes 
# since midnight.

# It have to convert deptime and scheddeptime from 1504(15:04) to minute
1504 %/% 100
1504 %% 100
1504 %/% 100 * 60 + 1504 %% 100

flights_times <- mutate(flights,
                        dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
                        sched_dep_time_mins = (sched_dep_time %/% 100 * 60 + 
                                                 sched_dep_time %% 100) %% 1440)

select(flights_times, 
       dep_time, dep_time_mins, sched_dep_time,sched_dep_time_mins)

# 2.Compare air_time with arr_time - dep_time. 
# What do you expect to see? What do you see? What do you need to do to fix it?

# Expect to see clear air_time = arr_time - dep_time but arrtime and deptime
# is currently in a form of am pm 1504 deptime = 15.04pm
flights_airtime <- mutate(flights,
                          dep_time = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
                          arr_time = (arr_time %/% 100 * 60 + arr_time %% 100) %% 1440,
                          air_time_diff = air_time - arr_time + dep_time
)
select(flights_airtime, dep_time, arr_time, air_time_diff)
nrow(filter(flights_airtime, air_time_diff != 0))
# shit gone down we still not know where air_time coming from 
# but from doc flights data does not contain the variables TaxiIn, TaxiOff
# It appears that the air_time variable refers to flight time, 
# which is defined as the time between wheels-off and wheels-in (landing).
# so ans is air_time <= arr_time - dep_time
# air_time + taxioff - taxiin = arr_time - dep_time

# 3.Compare dep_time, sched_dep_time, and dep_delay. 
#How would you expect those three numbers to be related?

# Expect (dep_delay) to be equal to the difference between 
# dep_time - sched_dep_time = dep_delay.
flights_dep_delay <- mutate(flights,
                            dep_time_min = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
                            sched_dep_time_min = (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %% 1440,
                            dep_delay_diff = dep_delay - dep_time_min + sched_dep_time_min)

filter(flights_dep_delay, dep_delay_diff != 0)
# Bro it's not all 0 bc All of these discrepancies are exactly equal to 1440 
# (24 hours), and these flights were scheduled to depart later in the day.
# View with
ggplot(
  filter(flights_deptime, dep_delay_diff > 0),
  aes(y = sched_dep_time_min, x = dep_delay_diff)
) +
  geom_point()

# 4.Find the 10 most delayed flights using a ranking function. 
# How do you want to handle ties? 
# Carefully read the documentation for min_rank().

flights_delayed <- mutate(flights, 
                          dep_delay_min_rank = min_rank(desc(dep_delay)),
                          dep_delay_row_number = row_number(desc(dep_delay)))

flights_delayed <- filter(flights_delayed, !(dep_delay_min_rank > 10 | 
                                               dep_delay_row_number > 10)) 

print(select(flights_delayed, flight, dep_delay, dep_delay_min_rank, 
             dep_delay_row_number), n = Inf)
# It's wierd tho why it wasn't rank 1 to 10

# 5.What does 1:3 + 1:10 return? Why?
1:3 + 1:10
# When adding two vectors, R recycles the shorter vector’s values 
# to create a vector of the same length as the longer vector. 

## ---------------------------------------------------------------------------
## Grouped summaries with summarise()
# Remove NA with na.rm = TRUE
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))


by_dest <- group_by(flights, dest)

delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")
delay

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(count = n(), dist = mean(distance, na.rm = TRUE), 
            delay = mean(arr_delay, na.rm = TRUE)) %>% 
  filter(count > 20, dest != "HNL")
delays

# Remove NA and use new object to calculation
# We’ll save this dataset so we can reuse it in the next few examples.
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

## Count
# Whenever you do any aggregation, it’s always a good idea to do a count.
# That way you can check that you’re not drawing conclusions based on 
# very small amounts of data.
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay))

ggplot(data = delays, mapping = aes(x = delay)) + geom_freqpoly(binwidth = 10)

# draw a scatterplot of number of flights vs. average delay:
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE), n = n())

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

## Useful summary functions
# Measures of location: we’ve use mean(x), but median(x)is also useful. 
# The mean is the sum divided by the length; 
# the median is a value where 50% of`x`is above it, and 50% is below it.

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(avg_delay1 = mean(arr_delay),
            avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

# Measures of spread:sd(x),IQR(x),mad(x). 
# Why is distance to some destinations more variable than to others?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

# Measures of rank: min(x), quantile(x, 0.25), max(x). 
# Quantiles are a generalisation of the median. 
# When do the first and last flights leave each day?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(first = min(dep_time), last = max(dep_time))

# Measures of position: first(x), nth(x, 2), last(x). 
# These work similarly to x[1], x[2], and x[length(x)] 
# but let you set a default value if that position does not exist
# For example, we can find the first and last departure for each day:
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(first_dep = first(dep_time), last_dep = last(dep_time))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

# To count the number of non-missing values, usebsum(!is.na(x)). 
# To count the number of distinct (unique) values, use n_distinct(x).
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

not_cancelled %>% 
  count(dest)

# You can optionally provide a weight variable. For example, 
# you could use this to “count” (sum) the total number of miles a plane flew:
not_cancelled %>% 
  count(tailnum, wt = distance)

## Counts and proportions of logical values: sum(x > 10), mean(y == 0). 
# When used with numeric functions, TRUE is converted to 1 and FALSE to 0. 
# This makes sum() and mean() useful: sum(x) gives the number of TRUEs in x,
# and mean(x) gives the proportion.

# How many flights left before 5am? (these usually indicate delayed
# flights from the previous day)
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

# What proportion of flights are delayed by more than an hour?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60))


## Grouping by multiple variables
# When you group by multiple variables, each summary peels off one level of the 
# grouping. That makes it easy to progressively roll up a dataset:
daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year  <- summarise(per_month, flights = sum(flights)))

View(per_day)
View(per_month)

# Ungrouping: If you need to remove grouping, 
# and return to operations on ungrouped data, use ungroup().
daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())  # all flights

## 5.6.7 Exercises
# 1.Which is more important: arrival delay or departure delay?

# In many scenarios, arrival delay is more important. 
# In most cases, being arriving late is more costly to the passenger since 
# it could disrupt the next stages of their travel, 
# such as connecting flights or scheduled meetings.

# 2. Come up with another approach that will give you the same output as 
not_cancelled %>% 
  count(dest) 
# Ans
not_cancelled %>% 
  group_by(dest) %>%
  summarise(flights = n())

not_cancelled %>% 
  count(tailnum, wt = distance) #(without using count())
# Ans
View(flights)

not_cancelled %>% 
  group_by(tailnum) %>%
  summarise(n = sum(distance))

# 3.Which carrier has the worst delays?
flights %>%
  group_by(carrier) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(arr_delay))

# 4.What does the sort argument to count() do? When might you use it?
# The sort argument to count() sorts the results in order of n. 
# You could use this anytime you would run count() followed by arrange().
flights %>%
  count(dest, sort = TRUE)

## ---------------------------------------------------------------------------
## Grouped mutates (and filters)
# Find the worst members of each group:
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

# Find all groups bigger than a threshold:
popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dests

# Standardise to compute per group metrics:
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

# 5.7.1 Exercises
# 1.Refer back to the lists of useful mutate and filtering functions. 
# Describe how each operation changes when you combine it with grouping.
mean()
lead()
lag()
min_rank()
row_number()
group_by()
mutate()
filter()

# 2.Which plane (tailnum) has the worst on-time record?
flights %>%
  filter(!is.na(tailnum), is.na(arr_time) | !is.na(arr_delay)) %>%
  mutate(on_time = !is.na(arr_time) & (arr_delay <= 0)) %>%
  group_by(tailnum) %>%
  summarise(on_time = mean(on_time), n = n()) %>%
  filter(n >= 20) %>% # at least 20 flight
  filter(min_rank(on_time) == 1)

# 3.What time of day should you fly if you want to avoid delays 
# as much as possible?
flights %>%
  group_by(hour) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(arr_delay)

# 4.For each destination, compute the total minutes of delay. 
# For each flight, compute the proportion of the total delay for its destination. 
flights %>%
  filter(arr_delay > 0) %>%
  group_by(dest) %>%
  mutate(
    arr_delay_total = sum(arr_delay),
    arr_delay_prop = arr_delay / arr_delay_total
  ) %>%
  select(dest, month, day, dep_time, carrier, flight,
         arr_delay, arr_delay_prop) %>%
  arrange(dest, desc(arr_delay_prop))

# 5.Find all destinations that are flown by at least two carriers. 
# Use that information to rank the carriers.
flights %>%
  # find all airports with > 1 carrier
  group_by(dest) %>%
  mutate(n_carriers = n_distinct(carrier)) %>%
  filter(n_carriers > 1) %>%
  # rank carriers by numer of destinations
  group_by(carrier) %>%
  summarize(n_dest = n_distinct(dest)) %>%
  arrange(desc(n_dest))

# 6.For each plane, count the number of flights before the first delay 
# of greater than 1 hour.
flights %>%
  # sort in increasing order
  select(tailnum, year, month,day, dep_delay) %>%
  filter(!is.na(dep_delay)) %>%
  arrange(tailnum, year, month, day) %>%
  group_by(tailnum) %>%
  # cumulative number of flights delayed over one hour
  mutate(cumulative_hr_delays = cumsum(dep_delay > 60)) %>%
  # count the number of flights == 0
  summarise(total_flights = sum(cumulative_hr_delays < 1)) %>%
  arrange(total_flights)