library(tidyverse)

mtcars %>%
  select(mpg, hp, wt) %>%
  summarise(mean(mpg))
