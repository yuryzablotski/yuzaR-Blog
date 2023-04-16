# install.packages("tidyverse")
library(tidyverse)

table2

# 1. Arrange

# this %>% is pipe from the 1. video
table2 %>%  
  arrange(year, count) 

table2 %>% 
  arrange(year, desc(count))

x <- tibble(y = c(1,2,NA,3,4))
x %>% arrange(y) 
x %>% arrange(desc(y))

# 2. Select

mtcars %>% 
  select(mpg, hp) %>% 
  glimpse()

mtcars %>% 
  select(hp:vs) %>% 
  glimpse()

mtcars %>% 
  select(-(mpg:disp), !wt, -(am:carb)) %>% 
  glimpse()

mtcars %>% 
  select(2:5, 7) %>% 
  glimpse()

mtcars %>% 
  select(-(2:5), -7) %>% 
  glimpse()

diamonds %>% 
  select(starts_with("c")) %>% 
  glimpse()

mtcars %>% 
  select(ends_with("c")) %>% 
  glimpse()

mtcars %>% 
  select(contains("c")) %>% 
  glimpse()

mtcars %>%
  select(!contains("a") & contains("c")) %>% 
  glimpse()

mtcars %>%
  select(
    starts_with("c") | 
      !ends_with(c("p","t"))) %>% 
  glimpse()

mtcars %>% 
  select(one_of(
    "weight", "wt", "wtf", "whatever"
    )) %>% 
  glimpse()

mtcars %>% 
  select(mpg, hp, everything()) %>% 
  glimpse()

mtcars %>% 
  relocate(mpg, hp) %>% 
  glimpse()

mtcars %>% 
  relocate(contains("c"), hp) %>% 
  glimpse()

mtcars %>% 
  select(last_col()) %>% 
  glimpse()

mtcars %>% 
  select(last_col(offset = 3)) %>% 
  glimpse()

glimpse(diamonds)

diamonds %>% 
  select_if(is.numeric) %>% 
  glimpse()

mtcars %>% 
  select_at(vars(mpg, hp), toupper) %>% 
  glimpse()

mtcars %>% pull(1)

mtcars %>% first()
mtcars %>% last()
mtcars %>% nth(9)

# 3. Mutate

mtcars %>% 
  select(1:3) %>% 
  add_column(new = 1:32) %>% 
  glimpse()

mtcars %>% 
  select(1:3) %>% 
  add_column(ID = 1:32, .before = T) %>% 
  glimpse()

mtcars %>% 
  select(1:3) %>% 
  mutate(ID = 1:32, .after = cyl) %>% 
  glimpse()

mtcars %>% 
  mutate(new_col = "whatever you want") %>% 
  mutate(mpg_hp  = mpg / hp) %>% 
  mutate(use_new = mpg_hp * 100) %>% 
  select(mpg_hp, use_new, everything()) %>% 
  glimpse()

mtcars %>% 
  transmute(mpg_hp = mpg / hp) %>% 
  glimpse()

mtcars %>% 
  mutate(mpg_hp = mpg / hp,
         .keep = "used") %>% 
  glimpse()

d <- tibble(
  a = 1:5,
  b = 6:10)
d

d %>% 
  mutate(substr  = b - mean(a),
         divide  = b * sum(a),
         rank    = rank(a),
         cummean = cummean(a), 
         cumsum  = cumsum(a),
         cumprod = cumprod(a),
         lag_a   = lag(a),  
         lead_a  = lead(a), 
         # or: <, <=, >, >=, !=, and == 
         logical = a > 3) %>%
  glimpse()

mtcars %>% 
  select(-1:4) %>% 
  rownames_to_column() %>% 
  head()   # "head" shows only first 6 rows

d %>% 
  column_to_rownames("b") 

mtcars %>%
  mutate_at(vars(cyl, am, gear), factor) %>% 
  glimpse()

mtcars %>%
  summarise_all(mean) 

iris %>%
  mutate_if(is.numeric, log) %>% 
  glimpse()

mtcars %>%
  mutate(across(c(mpg, wt), round)) %>% 
  glimpse()

iris %>%
  group_by(Species) %>%
  summarise(
    across(
      starts_with("Sepal"), 
      list(mean = mean, sd = sd) ) )


# 4. Filter

mtcars %>% 
  filter(mpg < 30, hp <= 200, am == 0) %>% 
  glimpse()


mtcars %>% 
  filter(vs > 0, cyl >= 6)


mtcars %>% 
  filter( gear != 4, cyl == 4)


mtcars %>% 
  filter(cyl == 6 & vs == 0 & gear == 4)


mtcars %>% 
  filter(mpg > 30 | hp < 90)


mtcars %>% 
  filter(cyl %in% c(4,6) & gear %in% c(3,5))

mtcars %>% 
  slice(1:3)

mtcars %>% 
  slice_sample(n = 4)

mtcars %>% 
  slice_sample(prop = .1)

mtcars %>% 
  slice_head(n = 2)

mtcars %>% 
  slice_tail(n = 3)

mtcars %>% 
  group_by(am) %>% 
  slice_min(mpg, n = 2)

mtcars %>% 
  group_by(am) %>% 
  slice_max(hp, n = 2)

mtcars %>% 
  group_by(cyl) %>% 
  slice_max(mpg, prop = 0.1)

mtcars %>% 
  distinct(cyl) 

mtcars %>% 
  distinct(cyl, am) 

mtcars %>% 
  distinct(cyl, am, .keep_all = TRUE) 

mtcars %>% 
  count(cyl, am) 

bla <- tibble(y = c(2,2,NA,3,4,4),
              y2 = c(2,2,2,NA,4,4))

distinct_all(bla)

unique(bla)

bla %>% 
  add_row(y = 100, y2 = 999)

# Bonus chapter: Common Mistakes

# 1. "=" vs. "=="
mtcars |>        # |> is similar to %>% 
  filter(am = 1)

# 2. "|" wrong
mtcars |> 
  filter(mpg == 14.7 | 16.4) %>% 
  glimpse()

# correct
mtcars |> 
  filter(mpg == 14.7 | cyl == 16.4)

# 3. "na.rm"
x <- tibble(
  y  = c(2,2,NA,3,4,4), y2 = c(2,2,2,NA,4,4)) 

x %>% summarise(mean(y), mean(y2))

x %>% summarise(mean(y,  na.rm = TRUE), 
                mean(y2, na.rm = TRUE))


# 5. Group by

mtcars %>% 
  group_by(am) %>% 
  top_n(2, mpg)

blup <- tibble(y = c(2,2,NA,3,4,4),
               y2 = c(2,2,2,NA,4,4)) %>% 
  group_by_all() %>% 
  count() %>% 
  arrange(desc(n))

blup

blup %>% 
  summarise(mean(n)) 

blup %>% 
  ungroup() %>% 
  summarise(mean(n)) 

mtcars %>% 
  mutate_at(vars(cyl, gear, am), factor) %>% 
  group_by_if(is.factor) %>% 
  summarise(avg = mean(mpg))

# 6. Summarise

iris %>% 
  group_by(Species) %>% 
  summarise(total_length = sum(Sepal.Length))

mtcars %>% 
  group_by(am) %>% 
  summarise_at(vars(mpg, hp, wt), mean)

mtcars %>% 
  group_by(cyl) %>% 
  summarise_if(is.numeric, mean, na.rm = TRUE)

mtcars %>% 
  group_by(vs) %>% 
  summarise_all(list(med = median))

mtcars %>% 
  group_by(cyl) %>% 
  summarise(count     = n(), 
            aver_mpg  = mean(mpg),
            sd_mpg    = sd(mpg),
            Q_0.5     = quantile(hp, 0.5), 
            n_of_strong_cars = sum(hp > 100))


DataExplorer::create_report(iris,y="Species")







d <- tibble(
  mean_of_this = 1:5,
  mean_of_that = 6:10,
  mean_of_blah = 6:10,
  mean_of_blup = 6:10)
d
