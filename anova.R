## ----setup, include=FALSE-----------------------------------
knitr::opts_chunk$set(echo = T, warning = F, message = F)


## ---- eval=T, echo=F----------------------------------------
vembedr::embed_youtube("JDGtLG0Tceo")


## -----------------------------------------------------------
# install.packages("tidyverse")  # for everything ;)
library(tidyverse)

#install.packages("ISLR")
library(ISLR)

set.seed(4)  # for reproducibility
d <- Wage %>% 
  group_by(education) %>% 
  sample_n(30)


## -----------------------------------------------------------
# install.packages("dlookr")
library(dlookr)
d %>% 
  group_by(education) %>% 
  normality(wage) 


## -----------------------------------------------------------
#install.packages("car")
library(car)
leveneTest(wage ~ education, d)


## ----fig.height=7-------------------------------------------
# install.packages("ggstatsplot")
library(ggstatsplot)

set.seed(4)   # for Bayesian reproducibility of 95% CIs
ggbetweenstats(
  data = d,
  x    = education, 
  y    = wage, 
  type = "parametric", 
  var.equal = FALSE)

# you can save the picture in the format and size of your choice
ggsave(filename = "anova.jpg", plot = last_plot(), width = 8, height = 7)


## -----------------------------------------------------------
# install.packages("effectsize")
library(effectsize)

interpret_omega_squared(0.34)
# ?interpret_omega_squared


## ----eval=FALSE---------------------------------------------
## interpret_r2(0.27)
## # ?interpret_r2


## -----------------------------------------------------------
interpret_bf(exp(-17.13))
# ?interpret_bf


## ----fig.height=7-------------------------------------------
ggbetweenstats(
  data = d,
  x    = education, 
  y    = wage, 
  outlier.tagging = T,
  type = "robust")
  
ggbetweenstats(
  data = d,
  x    = education, 
  y    = wage, 
  outlier.tagging = T,
  type = "robust", 
  p.adjust.method = "bonferroni", 
  pairwise.display = "all",
  results.subtitle = F,
  bf.message = F
) + 
  ylab("pay check")+
  theme_classic()+
  theme(legend.position = "top")

?ggbetweenstats


## ----fig.height=7-------------------------------------------
set.seed(1)   # for Bayesian reproducibility of 95% CIs
ggwithinstats(
    data = d,
    x    = education, 
    y    = wage, 
    type = "parametric", 
    var.equal = FALSE)


## -----------------------------------------------------------
# overall sums of squares
d %>% 
  ungroup() %>% 
  mutate(squares = (wage - mean(d$wage))^2) %>% 
  summarise(overall_ss   = sum(squares))

means <- d %>% 
  group_by(education) %>% 
  summarise(n = n(), 
            means = mean(wage))

d <- left_join(d, means)

# wgss - within groups sum of squares
wgvar <- d %>% 
  mutate(squares = (wage - means)^2) %>% 
  #group_by(education) %>% # already grouped before
  summarise(wgss   = sum(squares)) %>%    # wgss - within groups sum of squares
  summarise(ss_total = sum(wgss)) %>% 
  mutate(df = dim(d)[1] - length(unique(d$education))) %>% 
  mutate(var = ss_total / df ) %>% 
  mutate(variance_type = "withing groups variance") # wgvar - within group or residual variance

## between groups sums of squares
bgvar <- means %>% 
  mutate(sample_mean = mean(d$wage)) %>% 
  mutate(ss = n*(sample_mean - means)^2) %>% 
  summarise(ss_total = sum(ss)) %>% 
  mutate(df = length(unique(d$education))-1) %>% 
  mutate(var = ss_total / df ) %>% 
  mutate(variance_type = "between groups variance")
  

# actually it goes easies
var(means$means)*30

rbind(bgvar, wgvar) %>% 
  mutate(F_value = var[1]/var[2])


## -----------------------------------------------------------
aov(wage ~ education, d) %>% summary()

oneway.test(wage ~ education, d, var.equal = FALSE) 


## -----------------------------------------------------------
t.test(wage ~ jobclass, d) # square t-value to get F value
aov(wage ~ jobclass, d) %>% summary()
lm(wage ~ jobclass, d) %>% summary()

