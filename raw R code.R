library(tidyverse) # it's the only package you need

x <- tibble(A = c("1", "1", "2"), B = c("a", "b", "a"))
y <- tibble(A = c("1", "2"), B = c("a", "b"))
z <- tibble(
  A = c("3", "2", "1"), 
  C = c("a", "b", "c"), 
  D = c("here", "you", "go"))