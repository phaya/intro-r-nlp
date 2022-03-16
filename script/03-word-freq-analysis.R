## ----setup, include=FALSE------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(here)
library(tidyverse)
library(tidytext)
library(forcats)


## ----eval=FALSE, echo=TRUE, message=FALSE--------------------------------------------------------
## reviews <- read_csv(here("data/employee_reviews_10000.csv"))
## 
## tidy_reviews <- reviews %>%
##   select(company, summary) %>%
##   unnest_tokens(word, summary)
## 
## tidy_reviews


## ----echo=FALSE, message=FALSE-------------------------------------------------------------------
reviews <- read_csv(here("data/employee_reviews_10000.csv"))

tidy_reviews <- reviews %>% 
  select(company, summary) %>% 
  unnest_tokens(word, summary)

tidy_reviews


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------------
## reviews_words <- tidy_reviews %>%
##   count(company, word, sort = TRUE)
## 
## total_words <- reviews_words %>%
##   group_by(company) %>%
##   summarize(total = sum(n))
## 
## reviews_words <- left_join(reviews_words, total_words)
## 
## reviews_words


## ----echo=FALSE----------------------------------------------------------------------------------
reviews_words <- tidy_reviews %>%
  count(company, word, sort = TRUE)

total_words <- reviews_words %>% 
  group_by(company) %>% 
  summarize(total = sum(n))

reviews_words <- left_join(reviews_words, total_words)

reviews_words


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------------
## ggplot(reviews_words, aes(n/total, fill = company)) +
##   geom_histogram(show.legend = FALSE) +
##   xlim(NA, 0.0009) +
##   facet_wrap(~company, ncol = 2, scales = "free_y")


## ----echo=FALSE, message=FALSE, warning=FALSE----------------------------------------------------
ggplot(reviews_words, aes(n/total, fill = company)) +
  geom_histogram(show.legend = FALSE) +
  xlim(NA, 0.0009) +
  facet_wrap(~company, ncol = 2, scales = "free_y")


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------------
## freq_by_rank <- reviews_words %>%
##   group_by(company) %>%
##   mutate(rank = row_number(),
##          `term frequency` = n/total) %>%
##   ungroup()
## 
## freq_by_rank


## ----echo=FALSE----------------------------------------------------------------------------------
freq_by_rank <- reviews_words %>% 
  group_by(company) %>% 
  mutate(rank = row_number(), 
         `term frequency` = n/total) %>%
  ungroup()

freq_by_rank


## ----echo=FALSE----------------------------------------------------------------------------------
freq_by_rank %>% 
  ggplot(aes(rank, `term frequency`, color = company)) + 
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) + 
  scale_x_log10() +
  scale_y_log10()


## ----echo=TRUE-----------------------------------------------------------------------------------
rank_subset <- freq_by_rank %>% 
  filter(rank < 500,
         rank > 10)

lm(log10(`term frequency`) ~ log10(rank), 
                             data = rank_subset)


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------------
## freq_by_rank %>%
##   ggplot(aes(rank, `term frequency`, color = company)) +
##   geom_abline(intercept = -0.56, slope = -1.1,
##               color = "gray50", linetype = 2) +
##   geom_line(size = 1.1, alpha = 0.8,
##             show.legend = FALSE) +
##   scale_x_log10() +
##   scale_y_log10()


## ----echo=FALSE----------------------------------------------------------------------------------
freq_by_rank %>% 
  ggplot(aes(rank, `term frequency`, color = company)) + 
  geom_abline(intercept = -0.56, slope = -1.1, 
              color = "gray50", linetype = 2) +
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) + 
  scale_x_log10() +
  scale_y_log10()


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------------
## reviews_tf_idf <- reviews_words %>%
##   filter(company != 'facebook', company != 'netflix') %>%
##   bind_tf_idf(word, company, n)
## 
## reviews_tf_idf

## ----echo=FALSE----------------------------------------------------------------------------------
reviews_tf_idf <- reviews_words %>%
  filter(company != 'facebook', company != 'netflix') %>%
  bind_tf_idf(word, company, n)

print(reviews_tf_idf, n=6)


## ----echo=TRUE-----------------------------------------------------------------------------------
reviews_tf_idf %>%
  select(-total) %>%
  arrange(desc(tf_idf))


## ----eval=FALSE, echo=TRUE-----------------------------------------------------------------------
## reviews_tf_idf %>%
##   group_by(company) %>%
##   slice_max(tf_idf, n = 15) %>%
##   ungroup() %>%
##   ggplot(aes(tf_idf, reorder_within(word, tf_idf, company), fill = company)) +
##   geom_col(show.legend = FALSE) +
##   facet_wrap(~company, ncol = 2, scales = "free") +
##   scale_y_reordered() +
##   labs(x = "tf-idf", y = NULL)


## ----echo=FALSE----------------------------------------------------------------------------------
reviews_tf_idf %>%
  group_by(company) %>%
  slice_max(tf_idf, n = 15) %>%
  ungroup() %>%
  ggplot(aes(tf_idf, reorder_within(word, tf_idf, company), fill = company)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~company, ncol = 2, scales = "free") +
  scale_y_reordered() +
  labs(x = "tf-idf", y = NULL)

