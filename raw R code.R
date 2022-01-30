# R demo | Rereared Measures One Way ANOVA

# install.packages("datarium")   # for selfesteem data
library(datarium)

# install.packages("tidyverse")  # for everything ;)
library(tidyverse)

View(selfesteem)

# make long format
d <- selfesteem %>%
  gather(key = "time", value = "score", t1, t2, t3) 

View(d)

# old hard way
hard <- afex::aov_ez(
  data   = d,
  id     = "id", 
  dv     = "score",  
  within = "time")
summary(hard)
residuals(hard) %>% shapiro.test()

# new easy way
# install.packages("ggstatsplot")
library(ggstatsplot)

set.seed(1)   # for Bayesian reproducibility
ggwithinstats(
  data = d,
  x    = time, 
  y    = score, 
  type = "p"
)

pairwise.t.test(d$score, d$time,
                paired=T, 
                p.adjust.method = "holm")

# install.packages("effectsize")
library(effectsize)

interpret_omega_squared(0.81)

?interpret_omega_squared












# R demo | Friedman Test

# install.packages("datarium")   # for marketing data
library(datarium)

# install.packages("tidyverse")  # for everything ;)
library(tidyverse)

View(marketing)

d <- marketing %>%
  rowid_to_column() %>% 
  gather(key = "channel", value = "score", youtube:sales) %>% 
  group_by(channel) %>% 
  slice(1:10) # looks better   

View(d)

# hard way
hard <- afex::aov_ez(
  data   = d,
  id     = "rowid", 
  dv     = "score",  
  within = "channel")

summary(hard)

residuals(hard) %>% shapiro.test()

# install.packages("ggstatsplot")
library(ggstatsplot)

ggwithinstats(
  data = d,
  x    = channel, 
  y    = score, 
  type = "np"
)


# install.packages("PMCMRplus")
library(PMCMRplus)
durbinAllPairsTest(
  y      = d$score, 
  groups = d$channel, 
  blocks = d$rowid,
  p.adjust.method = "holm") 


# install.packages("effectsize")
library(effectsize)

# Kendall’s coefficient of concordance
interpret_kendalls_w(0.44) 

?interpret_kendalls_w





