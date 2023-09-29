library(tidyverse)
library(ISLR)

theme_set(theme_test())

# Basic histogram
ggplot(Wage, aes(x = wage)) +
  geom_histogram()

# Change the number of bins
a <- ggplot(Wage, aes(x = wage)) +
  geom_histogram(bins = 4)

b <- ggplot(Wage, aes(x = wage)) +
  geom_histogram(bins = 100)

library(patchwork)
a + b

# Change the width of bins
a <- ggplot(Wage, aes(x = wage)) +
  geom_histogram(binwidth = 50)

library(plotly)
ggplotly(a)

table(between(Wage$wage, 75, 125))

a + stat_bin(binwidth = 50, geom='text', color = "red",
             aes(label=..count..), 
             position=position_stack(vjust=0.5))

# Add central tendency, SD, IQR, CIs
ggplot(Wage, aes(x = wage)) +
  geom_histogram() + 
  geom_vline(aes(xintercept = mean(wage)), color = "red")

ggplot(Wage, aes(x = wage)) +
  geom_histogram(fill = "blue", color = "white") + 
  geom_vline(aes(xintercept = mean(wage)), color = "red",
             size = 1, linetype="dashed")

wage_stats <- Wage %>% 
  summarise(
    mean_wage = mean(wage),
    SD_wage   = sd(wage),
    med_est   = median(wage),
    conf.25   = quantile(wage, 0.25 ),
    conf.75   = quantile(wage, 0.75 ),
    conf.low  = quantile(wage, 0.025),
    conf.high = quantile(wage, 0.975))

# 68.26% of the data are located between -1 and +1 SD
# 95.44% of the data are located between -2 and +2 SD

a <- ggplot(Wage, aes(x = wage)) +
  geom_histogram(fill = "blue", color = "white") + 
  # mean + SD + 95% CI
  geom_vline(data = wage_stats,         
             aes(xintercept=mean_wage), 
             size=1, color = "red")+
  geom_vline(data = wage_stats,         
             aes(xintercept=mean_wage + SD_wage),
             linetype="dashed", color = "red")+
  geom_vline(data = wage_stats,         
             aes(xintercept=mean_wage - SD_wage),
             linetype="dashed", color = "red")+
  geom_vline(data = wage_stats,         
             aes(xintercept=mean_wage + SD_wage*2),
             linetype="dotted", color = "red")+
  geom_vline(data = wage_stats,         
             aes(xintercept=mean_wage - SD_wage*2),
             linetype="dotted", color = "red")

b <- ggplot(Wage, aes(x = wage)) +
  geom_histogram(fill = "blue", color = "white") + 
  # median + IQR + 95% quantiles
  geom_vline(data = wage_stats,         
             aes(xintercept=med_est),
             size=1, color = "black")+
  geom_rect(aes(x = med_est, xmin = conf.low, 
                xmax = conf.high, ymin = 0, ymax = Inf), 
            data = wage_stats, alpha = 0.2, fill = "green") +
  geom_rect(aes(x = med_est, xmin = conf.25, 
                xmax = conf.75, ymin = 0, ymax = Inf), 
            data = wage_stats, alpha = 0.4, fill = "green") 

a + b

# Annotations
c <- a + geom_label(aes(x = 110, y = 450, size = 3, fontface = "bold", 
                        label = paste("Mean:", round(wage_stats$mean_wage) )))

d <- b + geom_label(aes(x = 110, y = 450, size = 3, fontface = "bold", 
                        label = paste("Median:", round(wage_stats$med_est) )))

c + d


# Combine histogram and density plots
meds <- iris %>% 
  group_by(Species) %>% 
  summarise(medians = median(Sepal.Length))

ggplot(iris, aes(x=Sepal.Length, color = Species)) + 
  geom_histogram(aes(y=..density..), fill = "white")+
  geom_density(aes(color = Species, fill = Species), alpha = .4)+ 
  geom_vline(data = meds,
             aes(xintercept=medians, color = Species),
             linetype="dashed", size=1)



# Pimp your plot
wage_stats <- Wage %>% 
  group_by(jobclass, education, health_ins) %>% 
  summarize(mean_wage  = mean(wage))

ggplot(Wage, aes(x=wage, color = jobclass)) + 
  geom_histogram(aes(y=..density..), fill = "white")+
  geom_density(aes(color = jobclass), size = 1)+ 
  geom_vline(data = wage_stats,
             aes(xintercept=mean_wage, color = jobclass),
             linetype="dashed", size=1)+
  facet_grid(health_ins~education)+
  theme_test()+
  xlim(0, 345)+ 
  theme(legend.position = "top") + 
  labs(
    title    = "American Salaries",
    subtitle = "Money Business",
    caption  = "Source: Secret Data Base Noone Knows About",
    x        = "Salary (in U.S. dollars)",
    y        = "Density"
  )+
  theme(
    plot.title    = element_text(color = "red", size = 15),
    plot.subtitle = element_text(face = "bold"),
    plot.caption  = element_text(face = "italic"),
    axis.title.x  = element_text(color = "red", size = 14, face = "bold"),
    axis.title.y  = element_text(size = 14, face = "italic")
  )
