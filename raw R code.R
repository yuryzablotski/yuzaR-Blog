library(ISLR)            # for Wage data
library(emmeans)         # unleash the power results!
library(tidyverse)       # for everything good in R
theme_set(theme_test())  # beautifies plots 

set.seed(1)              # for reproducibility
salary <- Wage %>% 
  mutate(age_cat = case_when(
    age < 40 ~ "1. young",
    TRUE     ~ "2. old"
  )) %>% 
  group_by(education) %>% 
  sample_n(40)

# Interaction between two categorical predictors
m  <- lm(wage ~ age_cat * jobclass, salary)
m1 <- lm(wage ~ age_cat + jobclass, salary)

library(gtsummary) # I made a video on this 📦
tbl_regression(m1)

emmeans(m1, pairwise ~ age_cat | jobclass)$contrasts
emmeans(m1, pairwise ~ jobclass| age_cat)$contrasts

a <- emmip(m1, age_cat ~ jobclass, CIs = TRUE)+
  theme(legend.position = "top")+
  ggtitle("NO INTERACTION")+
  ylab("SALARY [1000$]")+ 
  labs(color = "AGE")+
  scale_color_manual(values=c('blue','black'))

b <- emmip(m, age_cat ~ jobclass, CIs = TRUE)+
  theme(legend.position = "top")+
  ggtitle("INTERACTION")+
  ylab("SALARY [1000$]")+ 
  labs(color = "AGE")+
  scale_color_manual(values=c('blue','black'))

library(patchwork)
a + b

# save your fancy image ;)
ggsave("interaction.png", plot = last_plot(), 
       width = 5, height = 3)

emmeans(m, pairwise ~ jobclass | age_cat)$contrasts
emmeans(m, pairwise ~ age_cat | jobclass)$contrasts

emmeans(m, pairwise ~ age_cat)

emmeans(m, ~ age_cat | jobclass) %>%
  pairs(reverse = TRUE)

emmeans(m, pairwise ~ age_cat | jobclass, 
        infer = TRUE)$contrasts

# Interactions with covariates
## Linear relationship

set.seed(1)              # for reproducibility
salary <- Wage %>% 
  group_by(education) %>% 
  sample_n(100)

m <- lm(wage ~ health * age, salary)

library(sjPlot) # I made a video on this 📦
plot_model(m, type = "pred",terms = c("age","health"))

emtrends(m, pairwise ~ health, var = "age", infer = T)

emmeans(m, pairwise ~ health|age, cov.reduce = range)

## Non-Linear relationship
m <- lm(wage ~ health * poly(age, 2), salary)

emmip(m, health ~ age, CIs = TRUE, 
      cov.reduce = FALSE, ylab = "Salary  [1000 $]")

emmip(m, health ~ age, CIs = TRUE, 
      at = list(age = c(25, 45, 65)), 
      dodge = 5, ylab = "Salary  [1000 $]")

# get contrasts
emmeans(m, pairwise ~ age|health,  
        at = list(age = c(25, 45, 65)))
emmeans(m, pairwise ~ health|age,  
        at = list(age = c(25, 45, 65)))

# Two numeric predictors
m <- lm(mpg ~ poly(hp, 2) * poly(qsec, 2), mtcars)

emmip(m, hp ~ qsec, cov.reduce = FALSE, 
      ylab = "Miles per gallon")

emmip(m, hp ~ qsec, CIs = TRUE, dodge = 1,
      at = list(hp   = c(50, 150, 250), 
                qsec = c(14, 17, 20)),
      ylab = "Miles per gallon")

emmeans(m, pairwise ~ qsec | hp,  
        at = list(hp   = c(50, 150, 250), 
                  qsec = c(14, 17, 20)))

# Higher order interactions
m <- lm(wage ~ poly(age, 2) * jobclass * health, Wage)

emmip(m, health ~ age|jobclass, CIs = TRUE, 
      at = list(age = c(25, 45, 65)), 
      dodge = 5, ylab = "Salary  [1000 $]")

ref_grid(m, at = list(age = c(25, 45, 65))) @grid 

emmeans(m, pairwise ~ health|jobclass,  by = "age",
        at = list(age = c(25, 45, 65)))$contrasts

emmeans(m, pairwise ~ age|jobclass,  by = "health",
        at = list(age = c(25, 45, 65)))$contrasts

# Matrix results
m  <- lm(wage ~ education * jobclass, salary)

emm <- emmeans(m, pairwise ~ education | jobclass, 
               adjust = "bonferroni")
emm

pwpm(emm[[1]], adjust = "bonferroni")

plot(emm, comparisons = TRUE)

pwpp(emm[[1]])+     # by = "health"
  geom_vline(xintercept = 0.05, linetype = 2)
