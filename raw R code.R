library(tidyverse)
library(gtsummary)

d <- trial %>% select(trt, age, grade, response)

# 1. Summarize data
tbl_summary(d, by = trt)

d %>%
  tbl_strata(
    strata = grade, 
    ~.x %>% 
      tbl_summary(by = trt))

# 2. Summarize statistical tests
d %>% 
  tbl_summary(by = trt) %>% 
  add_p() %>% 
  add_q() %>% 
  add_overall() %>% 
  add_n() %>% 
  add_ci() %>% 
  add_stat_label(
    label = all_continuous() ~ "Median (IQR)") 

trial %>%
  tbl_summary(
    by        = trt,
    statistic = all_continuous()~"{mean} ({sd})") %>%
  add_p(test  = list(
    all_continuous()  ~ "t.test", 
    all_categorical() ~ "fisher.test"))

trial %>% 
  tbl_summary(
    by = trt,
    statistic = list(
      age    ~ "{mean} ({sd})",
      marker ~ "{mean} ({min}, {p25}, {p75}, {max})",
      stage  ~ "{n} / {N} ({p}%)")) %>% 
  add_p(test = list(
    age    ~ "t.test",
    marker ~ "wilcox.test",
    stage  ~ "fisher.test")) %>% 
  separate_p_footnotes()

trial_paired <-
  trial %>%
  select(trt, marker, response) %>%
  group_by(trt) %>%
  mutate(id = row_number()) %>%
  ungroup()

trial_paired %>%
  filter(complete.cases(.)) %>%
  group_by(id) %>%
  filter(n() == 2) %>%
  ungroup() %>%
  tbl_summary(by = trt, include = -id) %>%
  add_p(test = list(
    marker   ~ "paired.t.test",
    response ~ "mcnemar.test"), 
    group    = id)

trial %>%
  tbl_summary(
    by           = trt,
    statistic    = age   ~ "{mean} ({sd})", 
    label        = grade ~ "New Name - Tumor Grade",
    digits       = all_continuous() ~ 1,
    # missing    = "no", 
    missing_text = "Missing values",
    type         = list(response ~ "categorical",
                        death    ~ "categorical"),
    sort         = everything()  ~ "frequency", 
    percent      = "cell", 
    include      = - ttdeath
  ) %>%
  add_p(pvalue_fun = ~style_pvalue(.x, digits = 3))

# 3. Summarize regression models
bm <- arm::bayesglm(
  response ~ trt + age + grade, 
  data = trial, family = binomial)

bm_table <- tbl_regression(bm, exponentiate = TRUE) 

bm_table

library(survival)
cm <- coxph(
  Surv(ttdeath, death) ~ trt + age + grade, 
  data = trial)

cm_table <- tbl_regression(cm, exponentiate = TRUE) 

cm_table

# several univariate models
uvlm_table <- trial %>%
  select(response, trt, age, grade) %>%
  tbl_uvregression(
    method       = glm,
    y            = response,
    method.args  = list(family = binomial),
    exponentiate = TRUE
  ) 

uvlm_table

uvcm_table <- tbl_uvregression(
  trial %>% 
    # could be 300+ predictors
    select(ttdeath, death, trt, age, grade),
  method       = coxph,
  y            = Surv(ttdeath, death),
  exponentiate = TRUE
) 

uvcm_table

## Side-by-side Regression Models
fancy_table <-
  tbl_merge(
    tbls        = list(bm_table, cm_table),
    tab_spanner = c("Tumor Response","Time to Death")
  )

fancy_table

uni_multi <- tbl_merge(
  tbls        = list(
    tbl_summary(d), uvlm_table, bm_table),
  tab_spanner = c(
    "**Describe**", 
    "**Univariate Models**", 
    "**Multivariate Model**")
)

uni_multi

glm(response ~ trt + age + marker + ttdeath + grade, 
    data = trial, family = binomial) %>% 
  tbl_regression(
    #pvalue_fun   = ~style_pvalue(.x, digits = 3),
    exponentiate = TRUE
  ) %>% 
  # add_* helpers
  add_n(location = "level") %>%
  add_nevent(location = "level") %>%  
  add_global_p() %>%   
  add_q() %>%        
  add_significance_stars(
    hide_p = F, hide_se = T, hide_ci = F) %>% 
  add_vif() %>% 
  # modify_* helpers
  modify_header(label = "**Predictor**") %>% 
  modify_caption("Table 1. Cool looking table!") %>% 
  modify_footnote(
    ci = "CI = Credible Intervals are incredible ;)", 
    abbreviation = TRUE) %>%
  sort_p() %>% 
  # aesthetics helpers
  bold_p(t = 0.10, q = TRUE) %>% 
  bold_labels() %>%    #bold_levels() 
  italicize_levels()   #italicize_labels() 

trial %>%
  tbl_cross(
    row = stage,
    col = trt,
    percent = "cell", # or column, row, none
    missing = "ifany", 
  ) %>%
  add_p()

# loading the api data set
data(api, package = "survey")

svy_apiclus1 <- 
  survey::svydesign(
    id = ~dnum, 
    weights = ~pw, 
    data = apiclus1, 
    fpc = ~fpc
  ) 

svy_apiclus1 %>%
  tbl_svysummary(
    # stratify summary stats by the "both" column
    by = both, 
    # summarize a subset of the columns
    include = c(api00, api99, both),
    # adding labels to table
    label = list(api00 ~ "API in 2000",
                 api99 ~ "API in 1999")
  ) %>%
  add_p() %>%   # comparing values by "both" column
  add_overall() %>%
  # adding spanning header
  modify_spanning_header(c("stat_1", "stat_2") ~ 
                           "**Met Both Targets**")

theme_gtsummary_compact()

library(ISLR)    # for Auto dataset
m <- lm(mpg ~ origin * horsepower, data = Auto)

tbl_regression(m) %>% 
  modify_caption("Compact theme")

reset_gtsummary_theme()

library(gt)
trial %>%
  # create a gtsummary table
  tbl_summary(by = trt) %>%
  # convert from gtsummary object to gt object
  as_gt() %>%
  # modify with gt functions
  tab_header("Table 1: Baseline Characteristics") %>% 
  tab_spanner(
    label = "Randomization Group",  
    columns = starts_with("stat_")
  ) %>% 
  tab_options(
    table.font.size = "small",
    data_row.padding = px(1)) 

library(flextable)

fancy_table %>%
  as_flex_table() %>% 
  save_as_image(path = "fancy_table.png")

fancy_table %>%
  as_flex_table() %>%
  save_as_docx(path = "fancy_table.docx") 



theme_gtsummary_compact()

compact_table <- glm(response ~ trt + age + grade, 
    data = trial, family = binomial) %>% 
  tbl_regression(
    #pvalue_fun   = ~style_pvalue(.x, digits = 3),
    exponentiate = TRUE
  ) %>% 
  # add_* helpers
  add_n(location = "level") %>%
  add_nevent(location = "level") %>%  
  add_global_p() %>%   
  add_q() %>%        
  add_significance_stars(
    hide_p = F, hide_se = T, hide_ci = F) %>% 
  add_vif() %>% 
  # modify_* helpers
  modify_header(label = "**Predictor**") %>% 
  modify_caption("Table 1. Cool looking table!") %>% 
  modify_footnote(
    ci = "CI = Credible Intervals are incredible ;)", 
    abbreviation = TRUE) %>%
  sort_p() %>% 
  # aesthetics helpers
  bold_p(t = 0.10, q = TRUE) %>% 
  bold_labels() %>%    #bold_levels() 
  italicize_levels()   #italicize_labels() 

compact_table %>%
  as_flex_table() %>% 
  save_as_image(path = "compact_table.png")

reset_gtsummary_theme()

