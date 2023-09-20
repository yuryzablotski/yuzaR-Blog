library(tidyverse)
library(readxl)
theme_set(theme_bw())

d <- read_excel("compounding_growth_10_percent.xlsx") %>% 
  mutate(month = factor(month, 
                        levels = c("Jan", "Feb", "Mär", "Apr", "Mai", "Jun",
                                   "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"))) %>% 
  mutate(projected = round(projected))

ggplot(d %>% 
         filter(year == 2023) %>% 
         mutate(adds = round(adds, 1)), 
       aes(x = month, y = adds))+
  geom_bar(stat = "identity", fill = "black")+
  geom_text(aes(label = adds), vjust = -.1) +
  geom_bar(aes(x = month, y = projected), 
           stat = "identity", 
           fill = "red", alpha = 0.7)


ggplot(d %>% filter(year == 2023))+
  geom_bar(aes(x = month, y = projected), 
           stat = "identity", fill = "black")+
  geom_bar(aes(x = month, y = total_earnings), 
           stat = "identity", 
           fill = "red", alpha = 0.5)


ggplot(d %>% filter(year %in% c(2023:2027)))+
  geom_bar(aes(x = month, y = projected), 
           stat = "identity", fill = "black")+
  facet_grid(.~year)




# 
# result <- vector("numeric", 1) # prepare a container
# i <- 15
# while (i < 10000) {
#   print( i )
#   i = i*1.1
#   result[i] = i
# }
# 
# res <- result %>% 
#   as_tibble() %>% 
#   filter( !is.na(value) ) %>% 
#   mutate(value = case_when(
#     value == 0 ~ 15,
#     TRUE ~ value
#   )) %>% 
#   rename(projected = value) %>% 
#   rowid_to_column() %>% 
#   rename(month = rowid) %>% 
#   mutate(year = case_when(
#     between(month, 1, 12)  ~ 2023,
#     between(month, 13, 24) ~ 2024,
#     between(month, 25, 36) ~ 2025,
#     between(month, 37, 48) ~ 2026,
#     between(month, 49, 60) ~ 2027,
#     between(month, 61, 72) ~ 2028
#   )) 
