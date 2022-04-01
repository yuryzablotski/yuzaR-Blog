# Mann–Whitney U Test

set.seed(5)
d <- ISLR::Wage %>% 
  group_by(jobclass) %>% 
  sample_n(15) %>% 
  ungroup()

# set.seed(15)
# d <- ISLR::Wage %>% 
#   group_by(jobclass) %>% 
#   slice(10:35)

d %>% 
  group_by(jobclass) %>% 
  normality(wage)

ggbetweenstats(
  data = d,
  x    = jobclass, 
  y    = wage, 
  type = "nonparametric")

ggbetweenstats(
  data = d,
  x    = jobclass, 
  y    = wage, 
  type = "parametric",
  var.equal = T)



d %>% 
  mutate(rank = rank(wage)) %>%          # mutate means - create new column
  group_by(jobclass) %>%
  summarise(n           = n(), 
            rank_sum    = sum(rank)) %>%
  mutate(W = rank_sum - (n * (n + 1)) / 2) 





ggwithinstats(
  data = d,
  x    = jobclass, 
  y    = wage, 
  type = "nonparametric")










# simpsons paradox :) I can make a video about it + iris

ggbetweenstats(
  data = Simpson,
  x    = gender, 
  y    = gpa, 
  type = "nonparametric"
)

grouped_ggbetweenstats(
  data = Simpson,
  x    = gender, 
  y    = gpa, 
  type = "nonparametric",
  grouping.var = "sport"
)


# ------------------------------------------

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


library(modelStudio)
library(DALEX)
library(tidyverse)
library(tidymodels)




# ----- fisher and pairwise fisher tests - pipe fisher tests ---- #

library(rstatix)
fisher_test()
pairwise_fisher_test()

# library(tidyverse)
# diamonds %>% 
#   group_by(color) %>%
#   summarize(pvalue=fisher.test(matrix(c(cut, clarity), nrow =2))$p)

# ------- multinom test and multinomial model  ----------- #

library(rstatix)
multinom_test()

# nonparametric regression fucking finally!!!
## found it here

# 1. Kendall–Theil Sen Siegel nonparametric linear regression

library(mblm) # Median-Based Linear Models
ts = mblm(mpg ~ hp, data = mtcars)
plot_model(ts, type = "pred", show.data = T)
tab_model(ts)

# 2. Rank-based estimation regression uses estimators and inference that are robust to outliers.

library(Rfit)
rb = rfit(mpg ~ hp, data = mtcars)
#plot_model(rb, type = "pred", show.data = T)
summary(rb)

# 3. Quantile regression models the conditional median or other quantile. 
#  25th , 50th, 75th or 95th percentiles, could be investigated simultaneously.
# Quantile regression makes no assumptions about the distribution of the
# underlying data, and is robust to outliers in the dependent variable. 
# It does assume the dependent variable is continuous. However, there are
# functions for other types of dependent variables in the qtools package.
# The model assumes that the terms are linearly related. Quantile 
# regression is sometimes considered “semiparametric”.

library(quantreg)

qr = rq(mpg ~ hp, data = mtcars, tau = 0.5 )
plot_model(qr, type = "pred", show.data = T)
tab_model(qr)
library(rcompanion)
nagelkerke(qr)

# 3. Local regression


localr = loess(mpg ~ hp, data = mtcars,
                span = 0.75,        ### higher numbers for smoother fits
                degree=2,           ### use polynomials of order 2
                family="gaussian")  ### the default, use least squares to fit

summary(localr)

# 5. GAMS

library(mgcv)

gam_m = gam(mpg ~ hp, data = mtcars, family=gaussian())

compare_performance(ts, rb, qr, localr, gam_m, rank = T)
compare_performance(ts, gam_m, rank = T)




# --------- Meta-analysis in R -------------- #

# setup
set.seed(123)
library(metaplus)
#> Error in library(metaplus): there is no package called 'metaplus'

# renaming to what the function expects
df <- dplyr::rename(mag, estimate = yi, std.error = sei, term = study)
#> Error in dplyr::rename(mag, estimate = yi, std.error = sei, term = study): object 'mag' not found

# plot
ggcoefstats(
  x = df,
  meta.analytic.effect = TRUE,
  bf.message = TRUE,
  meta.type = "parametric",
  title = "parametric random-effects meta-analysis"
)



#################################################

# R package review - radiant

library(radiant)

radiant()


library(irr)
data(video)

video <- video %>%
  pivot_longer(cols = 1:4) %>%
  mutate(groups = case_when(
    name %in% c("rater1", "rater2") ~ "control",
    name %in% c("rater4") ~ "treatment"
  ))


ggbetweenstats(
  data = video,
  x    = groups,
  y    = value,
  type = "nonparametric")
# 
# ggbetweenstats(
#   data = video %>% filter(name %in% c("rater2", "rater4")),
#   x    = name, 
#   y    = value, 
#   type = "nonparametric")
