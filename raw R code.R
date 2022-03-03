# ------------ Cochran's Q Test ------------ #

# Performs the Cochran's Q test for unreplicated randomized 
# block design experiments with a binary response variable and 
# paired data. This test is analogue to the friedman.test() with 
# 0,1 coded response. It's an extension of the McNemar Chi-squared 


# get the data
set.seed(9)
data_wide <- data.frame(
  before    = sample(c("Positive",
                       "Negative",
                       "Positive"), 30, replace = TRUE),
  after     = sample(c("Negative",
                       "Positive",
                       "Negative"), 30, replace = TRUE),
  longtirm  = sample(c("Negative",
                       "Negative",
                       "Positive"), 30, replace = TRUE))

View(data_wide)

# install.packages("tidyverse")
library(tidyverse)

data_long <- data_wide %>% 
  mutate(id = 1:nrow(.)) %>% 
  gather(key = "time", value = "outcome", before:longtirm) %>% 
  mutate_all(factor)

View(data_long)

# test for comparing more than two paired proportions.
# install.packages(rstatix)
library(rstatix)
mcnemar_test(data_wide$before, data_wide$after, correct = F)

xtabs(~outcome + time, data_long)

# pairwise_mcnemar_test: performs pairwise McNemar's chi-squared test 
# between multiple groups. Could be used for post-hoc tests following a 
# significant Cochran's Q test.
cochran_qtest(data_long, outcome ~ time|id)
pairwise_mcnemar_test(data    = data_long, 
                      formula = outcome ~ time|id, 
                      correct = F, 
                      p.adjust.method = "holm")

library(ggstatsplot)
ggbarstats(
  data = data_wide,
  x    = after, 
  y    = before,
  paired = T, 
  label = "both"
)

ggbarstats(
  data = data_wide,
  x    = after, 
  y    = longtirm,
  paired = T, 
  label = "both"
)


mat <- table(data_wide$before, data_wide$after)
# bla <- epi.tests(mat)
# print(bla)
# summary(bla)
caret::confusionMatrix(as.table(mat))





# install.packages("exact2x2")
library(exact2x2)
powerPaired2x2(.5,.3,npairs=20)






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








