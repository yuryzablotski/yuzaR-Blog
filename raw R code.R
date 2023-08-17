# ggplot2 is part of tidyverse
library(tidyverse)

Wage <- ISLR::Wage
glimpse(Wage)

# Basic barplots 1: count
ggplot(data = Wage, aes(x = education)) +
  geom_bar()

# Basic barplots 2: identity
df <- tibble(
  category = c("A", "B", "C"),
  counts = c(10, 20, 30)
)

df

ggplot(data = df, aes(x = category, y = counts)) +
  geom_bar(stat = "identity", width = 0.4,
           fill = "white", color = "chocolate4")

# Color different bars
ggplot(data = df, aes(x = category, y = counts, 
                      fill = category, color = -counts))+
  geom_bar(stat = "identity", width = 0.777)
