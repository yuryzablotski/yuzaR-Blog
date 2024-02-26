library(tidyverse)      # laod & thank me later ;)
library(ISLR)           # provides Wage dataset
theme_set(theme_test()) # beautifies plots

# get and clean the data
set.seed(1)             # for reproducibility
d <- Wage %>% 
  filter(wage < 200 & 
         age  < 60 & 
         jobclass == "1. Industrial") %>% 
  sample_n(100)

# build the model
m <- lm(formula = wage ~ age, data = d)

# check model assumptions visually
library(performance)    # extra video on my channel
check_model(m)

# uncleaned data
m2 <- lm(formula = wage ~ age, data = Wage)
library(patchwork)      # extra video on my channel
check_posterior_predictions(m2)
a <- check_posterior_predictions(m2) %>% plot() 
b <- check_normality(m2) %>% plot()

a / b

# don't trust statistical tests to much
check_normality(m)

# visualize predictions
library(sjPlot)         # extra video on my channel
plot_model(m, type = "eff", terms = "age", show.data = T)

# visualize estimates
plot_model(m, show.values = TRUE, terms = "age")

# get model results
tab_model(m)

plot_model(m, type = "eff", terms = "age [0:70]", 
           show.data = T, jitter = T)

57.50 + 1.08 * 40

57.50 + 1.08 * 50

# get particular predictions
predict(m, data.frame(age = c(40, 50, 60)) )

library(emmeans)       # extra 2 videos on my channel ;)
emmeans(m, ~ age, at = list(age = c(40, 50, 60)))

# get effect sizes
library(effectsize)
?interpret_r2
# rules = "cohen1988" is a default

interpret_r2(0.139, rules = "cohen1988") 

ggplot(Wage, aes(x = age, y = wage, color = education))+
  geom_smooth(method = "lm")

library(report)   # extra video on my channel
report(m)

report(d)
