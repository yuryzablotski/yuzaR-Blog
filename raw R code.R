# install.packages("tidyverse") # only once
library(tidyverse)

diamonds
table2

# 1
glimpse(table2)

# 2
view(table2)

# 3
table2

table2 %>% 
  arrange(year)

table2 %>% 
  arrange(year, type)

# 4
table1 %>% 
  select(country, population)

table1 %>% 
  select(-cases, -year)

# 5
table1 %>% 
  filter(year == 2000)

table1 %>% 
  filter(year != 2000)

table1 %>% 
  select(year, population) %>% 
  filter(year == 2000)

# 6 %>% - pipe operator

# 7 
table1 %>% 
  mutate(fill_it = "with a smile ;)") %>% 
  mutate(popul_per_case = population / cases)

# 8 
table1 %>% 
  mutate(fill_it = "with a smile ;)") %>%
  rename(much_better_name = fill_it)

# 1 glimpse
# 2 view
# 3 arrange
# 4 select
# 5 filter
# 6 %>% - pipe operator
# 7 mutate
# 8 rename

view(diamonds)

# 9
table1 %>% 
  summarise(counting = n())

table1 %>% 
  summarise(sum = sum(population))

table1 %>% 
  summarise(average = mean(population))

table1 %>% 
  summarise(avr_popul = mean(population),
            all_cases = sum(cases),
            how_many  = n())

# 10
mtcars %>% 
  group_by(cyl, am) %>% 
  summarise(avr_mpg = mean(mpg),
            avr_hp  = mean(hp),
            count   = n())

fancy_table = diamonds %>% 
  select(-x, -y, -z, -table) %>%
  filter(color == c("E", "I"), clarity == "SI2") %>%
  mutate(price_carat = price / carat) %>% 
  rename(new_name    = depth) %>% 
  group_by(cut, color, clarity) %>% 
  summarise(avg_price = mean(price, na.rm = TRUE),
            count     = n()) 

fancy_table

# 11 what's next? ;)
library(dlookr)
mtcars %>% 
  group_by(cyl, am) %>% 
  describe(-cyl, -am) %>% view()
