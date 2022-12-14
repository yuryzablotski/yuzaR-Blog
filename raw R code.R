# create data
library(tidyverse)
d <- tibble(
  predictor = c(  1,   2,   3,  4,   5,   6,   7),
  outcome   = c(1.5, 2.3, 2.8,  4.1, 5.3, 0, 6.8)
)

# plot ordinary and median regressions
ggplot(d, aes(predictor, outcome))+
  geom_point()+
  geom_smooth(method = lm, se = F, color = "red", )+
  geom_quantile(quantiles = 0.5)

# model median (2nd quantile) regression
lr <- lm(outcome ~ predictor, data = d)
library(quantreg)
mr <- rq(outcome ~ predictor, data = d, tau = .5)

# compare models
AIC(lr, mr) # => the lower AIS the better

library(sjPlot) # I made a video on this 📦
theme_set(theme_bw())
plot_models(
  lr, mr, 
  show.values = TRUE, 
  m.labels = c("Linear model", "Median model"), 
  legend.title = "Model type")

# get heteroscedastic data
data(engel)
ggplot(engel, aes(income, foodexp))+
  geom_point()+
  geom_smooth(method = lm, se = F, color = "red")+
  geom_quantile(color = "blue", quantiles = 0.5)+
  geom_quantile(color = "gray", alpha = 0.3, 
                quantiles = seq(.05, .95, by = 0.05))

# compare models
lr <- lm(foodexp ~ income, data = engel)

library(performance) # I made a video on this 📦
check_heteroscedasticity(lr)

qm50 <- rq(foodexp ~ income, data = engel, tau = 0.5)

AIC(lr, qm50)

# get not-normal data
library(ISLR)
set.seed(1) # for reproducibility
salary <- Wage %>% 
  group_by(jobclass) %>% 
  sample_n(30)

# check more assumptions
lr <- lm(wage ~ jobclass, data = salary)

check_outliers(lr)
check_normality(lr) 
check_homogeneity(lr)

# tau = .5 - or median regression is a default
mr <- rq(wage ~ jobclass, data = salary) 

plot_models(
  lr, mr, show.values = T, 
  m.labels = c("Linear model", "Median model"), 
  legend.title = "Model type")

AIC(lr, mr)

# get more not-normal data
lr <- lm(wage ~ jobclass, data = Wage)
mr <- rq(wage ~ jobclass, data = Wage)

plot_models(
  lr, mr, show.values = T, 
  m.labels = c("Linear model", "Median model"), 
  legend.title = "Model type")

AIC(lr, mr)

check_normality(lr) 
check_heteroscedasticity(lr)

# visualize several quantiles
library(ggridges)
ggplot(Wage, aes(x = wage, y = jobclass, 
                 fill = factor(stat(quantile)))) +
  stat_density_ridges(
    geom ="density_ridges_gradient",calc_ecdf = TRUE,
    quantile_lines = TRUE, quantiles = c(.1, .5, .9)
  ) +
  scale_fill_viridis_d(name = "Quantiles")

# model several quantiles
lr   <- lm(wage ~ jobclass, data = Wage)
qm10 <- rq(wage ~ jobclass, data = Wage, tau = 0.10)
qm50 <- rq(wage ~ jobclass, data = Wage, tau = 0.50)
qm90 <- rq(wage ~ jobclass, data = Wage, tau = 0.90)

plot_models(
  lr, qm10, qm50, qm90,
  show.values = TRUE,
  m.labels = c("LR", "QR 10%", "QR 50%", "QR 90%"), 
  legend.title = "Model type")+
  ylab("Increase in wage after switch to IT")

qm20 <- rq(wage ~ jobclass, data = Wage, tau = 0.20)
qm30 <- rq(wage ~ jobclass, data = Wage, tau = 0.30)
qm70 <- rq(wage ~ jobclass, data = Wage, tau = 0.70)
qm80 <- rq(wage ~ jobclass, data = Wage, tau = 0.80)

plot_models(
  lr, qm10, qm20, qm30, qm50, qm70, qm80, qm90, 
  show.values = TRUE)+
  theme(legend.position = "none")+
  ylab("Increase in wage after switch to IT")

# model even more quantiles easily
q <- rq(wage ~ jobclass, data = Wage, 
        tau = seq(0.1, 0.9, by = 0.1))

seq(0.1, 0.9, by = 0.1)

# plot all modelled quantiles
summary(q) %>% 
  plot(parm = "jobclass2. Information")

# multivariable regression
q <- rq(wage ~ jobclass + age + race, data = Wage, 
        tau = seq(.05, .95, by = 0.05))

summary(q) %>% 
  plot(c("jobclass2. Information", "age", 
         "race2. Black", "race3. Asian"))

# non-linear quantile regression
library(quantregGrowth)
set.seed(1)
o <-gcrq(wage ~ ps(age), 
         data = Wage %>% sample_n(100), 
         tau=seq(.10,.90,l=3))

# par(mfrow=c(1,2)) # for several plots
plot(o, legend=TRUE, conf.level = .95, shade=TRUE, 
     lty = 1, lwd = 3, col = -1, res=TRUE) 

# create fancy table with results of quantiles
cars <- Auto %>% 
  select(mpg, cylinders, displacement, 
         horsepower, acceleration, origin)

l   <- lm(mpg ~ ., data = cars)
q10 <- rq(mpg ~ ., data = cars, tau = .1)
q50 <- rq(mpg ~ ., data = cars, tau = .5)
q90 <- rq(mpg ~ ., data = cars, tau = .9)

library(gtsummary) # I made a video on this 📦
tbl_merge(
  tbls = list(
    tbl_regression(l) %>% bold_p(),
    tbl_regression(q10, se = "nid") %>% bold_p(), 
    tbl_regression(q50, se = "nid") %>% bold_p(),
    tbl_regression(q90, se = "nid") %>% bold_p()
  ),
  tab_spanner=c("OLS", "QR 10%", "QR 50%", "QR 90%")
)

