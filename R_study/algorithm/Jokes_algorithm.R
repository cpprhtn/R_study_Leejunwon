library(recommenderlab)
library(tidyverse)
library(stringr)

data(Jester5k)

1. recommenderlab 팩키지를 통한 비개인화 추천

recommenderRegistry$get_entry("POPULAR", type ="realRatingMatrix")

joke_recom <- Recommender(Jester5k, method = "POPULAR")

joke_pred <- predict(joke_recom, Jester5k[1:3,])
(joke_pred_list <- as(joke_pred, "list"))
cat(JesterJokes[joke_pred_list$u2841[1:3]], sep = "\n\n")


2. 인기도가 높은 농담 추천

joke_avg_top3 <- Jester5k %>% 
  normalize %>% 
  colMeans %>% 
  sort(decreasing = TRUE) %>% 
  head(3)

cat(JesterJokes[names(joke_avg_top3)], sep = "\n\n")


3. 평가가 많은 농담 추천

joke_freq_top3 <- Jester5k %>% 
  normalize %>% 
  colCounts %>% 
  sort(decreasing = TRUE) %>% 
  head(3)

cat(JesterJokes[names(joke_freq_top3)], sep = "\n\n")


4. 평가수와 평점을 조합하여 추천

joke_avg_freq_top3 <- Jester5k %>% 
  normalize %>% 
  binarize(minRating = 5) %>% 
  colCounts() %>% 
  sort(decreasing = TRUE) %>% 
  head(3)

cat(JesterJokes[names(joke_avg_freq_top3)], sep = "\n\n")