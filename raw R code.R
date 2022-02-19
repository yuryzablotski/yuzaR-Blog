# R demo | Friedman Test

# install.packages("datarium")   # for marketing data
library(datarium)

# install.packages("tidyverse")  # for everything ;)
library(tidyverse)

View(marketing)

# x <- c("facebook", 'newspaper', 'sales', "youtube")
# utils::combn(x = x, m = 2) %>% t()
# 
# diffs <- marketing %>% 
#   mutate(
#     f_n = facebook - newspaper,
#     f_s = facebook - sales,
#     f_y = facebook - youtube,
#     n_s = newspaper - sales,
#     n_y = newspaper - youtube,
#     s_y = sales - youtube)

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

residuals(hard) %>% shapiro.test()

# install.packages("ggstatsplot")
library(ggstatsplot)

ggwithinstats(
  data = d,
  x    = channel, 
  y    = score, 
  type = "nonparametric"
)

# customise the result
ggwithinstats(
  data = d,
  x    = channel, 
  y    = score, 
  type = "nonparametric", 
  p.adjust.method = "bonferroni", 
  pairwise.display = "all",
  # pairwise.comparisons = FALSE,   
  results.subtitle = F,
  bf.message = F
) + 
  ylab("sales score")+
  theme_classic()+
  theme(legend.position = "top")

?ggwithinstats


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


# ---------------------

## two-way RM-ANOVA

d2 <- selfesteem2 %>%
  gather(key = "time", value = "score", t1, t2, t3) 

library(afex)
two_way_rma <- afex::aov_ez(
  data   = jobsatisfaction %>% 
    group_by(education_level) %>%  slice(1:5),
  id     = "id", 
  dv     = "score",  
  within = c("education_level"))

summary(two_way_rma)

residuals(two_way_rma) %>% shapiro.test()

# ------------------------------------------

library(lme4)
library(lmerTest)

m <- lmer(score ~ time + (1|id), d,
          control=lmerControl(
            optimizer="Nelder_Mead",
            optCtrl = list(maxfun = 100000),
            check.conv.singular = .makeCC(action = "ignore",  tol = 1e-6)))
plot_model(m, type = "pred")
tab_model(m)


