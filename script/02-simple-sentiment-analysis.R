## ----setup, include=FALSE------------------------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)
library(here)
library(tidyverse)
library(tidytext)
library(reshape2)


## ---- echo = TRUE--------------------------------------------------------------------------
get_sentiments("afinn")


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------
## reviews <- read_csv(here("data/employee_reviews_10000.csv"))
## 
## tidy_reviews <- reviews %>%
##   select(summary) %>%
##   unnest_tokens(word, summary)
## 
## tidy_reviews

## ----echo=FALSE, message=FALSE-------------------------------------------------------------
reviews <- read_csv(here("data/employee_reviews_10000.csv"))

tidy_reviews <- reviews %>% 
  select(summary) %>% 
  unnest_tokens(word, summary)

print(tidy_reviews, n=6)


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------
## nrc_joy <- get_sentiments("nrc") %>%
##   filter(sentiment == "joy")
## 
## nrc_joy


## ----echo=FALSE----------------------------------------------------------------------------
nrc_joy <- get_sentiments("nrc") %>% 
  filter(sentiment == "joy")

print(nrc_joy, n=6)


## ----echo=TRUE-----------------------------------------------------------------------------
tidy_reviews %>%
  inner_join(nrc_joy) %>%
  count(word, sort = TRUE)


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------
## tidy_reviews <- reviews %>%
##   select(company, summary) %>%
##   mutate(id_review = row_number()) %>%
##   unnest_tokens(word, summary)
## 
## tidy_reviews


## ----echo=FALSE----------------------------------------------------------------------------
tidy_reviews <- reviews %>% 
  select(company, summary) %>%
  mutate(id_review = row_number()) %>%
  unnest_tokens(word, summary)

print(tidy_reviews, n=10)


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------
## reviews_sentiment <- tidy_reviews %>%
##   inner_join(get_sentiments("bing"))  %>%
##   count(company, id_review, sentiment) %>%
##   pivot_wider(names_from = sentiment,
##               values_from = n,
##               values_fill = 0) %>%
##   mutate(sentiment = positive - negative)
## 
## reviews_sentiment


## ----echo=FALSE----------------------------------------------------------------------------
reviews_sentiment <- tidy_reviews %>%
  inner_join(get_sentiments("bing"))  %>%
  count(company, id_review, sentiment) %>%
  pivot_wider(names_from = sentiment, 
              values_from = n, 
              values_fill = 0) %>% 
  mutate(sentiment = positive - negative)

reviews_sentiment


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------
## ggplot(reviews_sentiment, aes(sentiment, fill = company)) +
##   geom_histogram(show.legend = FALSE)  +
##   facet_wrap(~company, ncol = 2, scales = "free_x")


## ----echo=FALSE, message=FALSE-------------------------------------------------------------
ggplot(reviews_sentiment, aes(sentiment, fill = company)) +
  geom_histogram(show.legend = FALSE)  +
  facet_wrap(~company, ncol = 2, scales = "free_x")


## ----echo=TRUE-----------------------------------------------------------------------------
bing_word_counts <- tidy_reviews %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_word_counts


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------
## bing_word_counts %>%
##   group_by(sentiment) %>%
##   slice_max(n, n = 10) %>%
##   ungroup() %>%
##   mutate(word = reorder(word, n)) %>%
##   ggplot(aes(n, word, fill = sentiment)) +
##   geom_col(show.legend = FALSE) +
##   facet_wrap(~sentiment, scales = "free_y") +
##   labs(x = "Contribution to sentiment",
##        y = NULL)


## ----echo=FALSE----------------------------------------------------------------------------
bing_word_counts %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>% 
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(x = "Contribution to sentiment",
       y = NULL)


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------
## library(wordcloud)
## 
## tidy_reviews %>%
##   anti_join(stop_words) %>%
##   count(word) %>%
##   with(wordcloud(word, n, max.words = 50))


## ----echo=FALSE, message=FALSE-------------------------------------------------------------
library(wordcloud)

tidy_reviews %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 50))


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------
## custom_stop_words <- bind_rows(tibble(
##                                 word = c("company"),
##                                 lexicon = c("propio")
##                                ),
##                                stop_words)
## custom_stop_words

## ----echo=FALSE----------------------------------------------------------------------------
custom_stop_words <- bind_rows(tibble(
                                word = c("company"),  
                                lexicon = c("propio")
                               ), 
                               stop_words)
print(custom_stop_words, n=6)


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------
## tidy_reviews %>%
##   anti_join(custom_stop_words) %>%
##   count(word) %>%
##   with(wordcloud(word, n, max.words = 50))


## ----echo=FALSE, message=FALSE-------------------------------------------------------------
tidy_reviews %>%
  anti_join(custom_stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 50))


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------
## tidy_reviews %>%
##   inner_join(get_sentiments("bing")) %>%
##   count(word, sentiment, sort = TRUE) %>%
##   acast(word ~ sentiment, value.var = "n", fill = 0) %>%
##   comparison.cloud(colors = c("red", "green"),
##                    max.words = 50)


## ----echo=FALSE, message=FALSE-------------------------------------------------------------
tidy_reviews %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red", "green"),
                   max.words = 50)

