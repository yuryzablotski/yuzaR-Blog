result <- vector("numeric", 1) # prepare a container
i <- 15
while (i < 10000) {
  print( i )
  i = i*1.1
  result[i] = i
}

result <- result %>% 
  as_tibble() %>% 
  filter( !is.na(value) ) %>% 
  mutate(value = case_when(
    value == 0 ~ 15,
    TRUE ~ value
  )) %>% 
  rowid_to_column() %>% 
  rename(month = rowid) %>% 
  mutate(year = case_when(
    between(month, 1, 12)  ~ 1,
    between(month, 13, 24) ~ 2,
    between(month, 25, 36) ~ 3,
    between(month, 37, 48) ~ 4,
    between(month, 49, 60) ~ 5,
    between(month, 61, 72) ~ 6,
  )) 

ggplot(result)+
  geom_point(aes(month, value))
