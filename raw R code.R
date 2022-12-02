# 1. create data
library(tidyverse)
d <- tibble(
  predictor = c(  1,   2,   3,  4,   5, 6, 7),
  outcome   = c(1.5, 2.3, 2.8,  4.1, 5.3, 0, 6.8)
)

# 2. plot normal and median regressions
ggplot(d, aes(predictor, outcome))+
  geom_point()+
  geom_smooth(method = lm, se = F)+
  geom_quantile(color = "red", quantiles = 0.5)

# 3. model median based quantile regression
# How do we know QR is relly better?

library(quantreg)
mr <- rq(outcome ~ predictor, data = d, tau = .5)
lr <- lm(outcome ~ predictor, data = d)

# AIC estimates the relative amount of information
# lost by a given model: the less information a 
# model loses, the higher the quality of that model.

AIC(lr, mr) # => the lower AIS the better

# Moreover, taking a wrong regression could cost you
# an important discovery

library(sjPlot) # I did a video on this 📦
theme_set(theme_bw())
plot_models(lr, mr, show.values = TRUE)

# 5. model several quantiles

# like a box-plot
qm25 <- rq(outcome ~ predictor, data = d, tau = 0.25)
qm50 <- rq(outcome ~ predictor, data = d, tau = 0.5)
qm75 <- rq(outcome ~ predictor, data = d, tau = 0.75)

plot_models(lr, qm25, qm50, qm75,
            show.values = TRUE)

AIC(lr, qm25, qm50, qm75)

# 6. get model results in table form
qm <- rq(outcome ~ predictor, data = d, 
         tau = seq(.25, .75, by = 0.25))
library(gtsummary) # I did a video on this 📦
tbl_regression(qm, se="nid", level = 0.95)

summary(qm, se="nid") %>% plot()

# 7. model a lot of quantiles in a real data
data("engel")
qm <- rq(foodexp ~ income, data = engel, 
         tau = seq(.05, .95, by = 0.05))  # median regression

ggplot(engel, aes(income, foodexp))+
  geom_point()+
  geom_quantile(color = "red", 
                quantiles = seq(.05, .95, by = 0.05))


summary(qm, se="nid") %>% plot()


# like a box-plot
lr   <- lm(foodexp ~ income, data = engel)
qm05 <- rq(foodexp ~ income, data = engel, tau = 0.05)
qm25 <- rq(foodexp ~ income, data = engel, tau = 0.25)
qm50 <- rq(foodexp ~ income, data = engel, tau = 0.5)
qm75 <- rq(foodexp ~ income, data = engel, tau = 0.75)
qm95 <- rq(foodexp ~ income, data = engel, tau = 0.95)

AIC(lr, qm05, qm25, qm50, qm75, qm95)

plot_models(lr, qm05, qm25, qm50, qm75, qm95,
            show.values = TRUE)

# ?
library(performance) # I did a video on this 📦
compare_performance(
  lr, qm05, qm25, qm50, qm75, qm95, 
  rank = T)








