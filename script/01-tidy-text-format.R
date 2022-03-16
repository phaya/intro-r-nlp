## ----setup, include=FALSE------------------------------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)
library(here)
library(tidyverse)
library(tidytext)


## ---- echo = TRUE--------------------------------------------------------------------------------
text <- c('A company culture that encourages dissent, discourse, transparency, and fairness.',
          'Strong compensation, from benefits, to perks, to base pay.',
          'Decent internal mobility opportunities.',
          'Employees are proud to work on globally impactful products, leading.'
          )
text


## ---- echo = TRUE--------------------------------------------------------------------------------
text_df <- tibble(line = 1:4, text = text)

text_df


## ---- echo = TRUE--------------------------------------------------------------------------------
text_df %>%
  unnest_tokens(word, text)


## ---- echo = TRUE--------------------------------------------------------------------------------
text_df %>%
  unnest_tokens(ngram, text, token="ngrams", n=2)


## ----echo=TRUE, message=FALSE, warning=FALSE-----------------------------------------------------
reviews <- read_csv(here("data/employee_reviews_10000.csv"))

head(reviews$summary)


## ---- eval=FALSE, echo = TRUE--------------------------------------------------------------------
## tidy_reviews <- reviews %>%
##   select(summary) %>%
##   unnest_tokens(word, summary)
## 
## tidy_reviews

## ---- echo = FALSE-------------------------------------------------------------------------------
tidy_reviews <- reviews %>% 
  select(summary) %>%
  unnest_tokens(word, summary)

print(tidy_reviews, n=5)


## ---- echo = TRUE--------------------------------------------------------------------------------
tidy_reviews %>%
  count(word, sort = TRUE) 


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------------
## data(stop_words)
## 
## stop_words


## ---- echo = FALSE-------------------------------------------------------------------------------
data(stop_words)

print(stop_words, n=6)


## ----  eval=FALSE, echo = TRUE-------------------------------------------------------------------
## tidy_reviews <- tidy_reviews %>%
##   anti_join(stop_words)
## 
## tidy_reviews

## ---- echo = FALSE-------------------------------------------------------------------------------
tidy_reviews <- tidy_reviews %>%
  anti_join(stop_words)

print(tidy_reviews, n=6)


## ---- echo = TRUE--------------------------------------------------------------------------------
tidy_reviews %>%
  count(word, sort = TRUE) 


## ---- eval=FALSE, echo = TRUE--------------------------------------------------------------------
## data(stop_words)
## 
## stop_words_snowball <- stop_words %>%
##                        filter(lexicon == "snowball")
## 
## tidy_reviews <- reviews %>%
##                 select(summary) %>%
##                 unnest_tokens(word, summary) %>%
##                 anti_join(stop_words_snowball)
## 
## tidy_reviews


## ---- echo = FALSE-------------------------------------------------------------------------------
data(stop_words)

stop_words_snowball <- stop_words %>%
                       filter(lexicon == "snowball")

tidy_reviews <- reviews %>% 
                select(summary) %>%
                unnest_tokens(word, summary) %>%
                anti_join(stop_words_snowball)

print(tidy_reviews, n=10)


## ---- echo = TRUE--------------------------------------------------------------------------------
tidy_reviews %>%
  count(word, sort = TRUE) 


## ---- eval=FALSE, echo = TRUE--------------------------------------------------------------------
## tidy_reviews %>%
##   count(word, sort = TRUE) %>%
##   filter(n > 10) %>%
##   mutate(word = reorder(word, n)) %>%
##   ggplot(aes(n, word)) +
##     geom_col() +
##     labs(y = NULL)


## ---- echo = FALSE-------------------------------------------------------------------------------
tidy_reviews %>%
  count(word, sort = TRUE) %>%
  filter(n > 300) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
    geom_col() +
    labs(y = NULL)

