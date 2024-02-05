## Web scraping homework
## Homework 1: IMDB scrape Top50 video game names, rating
library(rvest)
library(dplyr)

url_hw1 <- "https://www.imdb.com/search/title/?title_type=video_game&view=simple&sort=user_rating,desc"

game_name <- url_hw1 %>%
  read_html() %>%
  html_elements("span.lister-item-header") %>%
  html_text2()

game_vote <- url_hw1 %>%
  read_html() %>%
  html_elements("div.col-imdb-rating") %>%
  html_text2() %>%
  as.numeric()

imdb_top50_games <- data.frame(game_name, game_vote)
View(imdb_top50_games)

## Homework 2: Scrape from static website
## The world's  50 best restaurants 2022

url_hw2 <- "https://edition.cnn.com/travel/article/worlds-50-best-restaurants-2022/index.html"

top50_restaurant_name <- url_hw2 %>%
  read_html() %>%
  html_elements("p.paragraph.inline-placeholder") %>%
  html_text2() %>%
  tail(50)

data.frame(top50_restaurant_name)