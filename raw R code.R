# ggplot2 is part of tidyverse
library(tidyverse)

Wage <- ISLR::Wage
glimpse(Wage)

# Basic barplots 1: count
ggplot(data = Wage, aes(x = education)) +
  geom_bar()

# Basic barplots 2: identity
df <- tibble(
  category = c("A", "B", "C"),
  counts = c(10, 20, 30)
)

df

ggplot(data = df, aes(x = category, y = counts)) +
  geom_bar(stat = "identity", width = 0.4,
           fill = "white", color = "chocolate4")

# Color different bars
p <- ggplot(data = df, aes(x = category, y = counts, 
                      fill = category, color = -counts))+
  geom_bar(stat = "identity", width = 0.777)
p

p + scale_fill_manual(
  values = c("#999999", "orange", "violet") )

p + scale_fill_brewer(palette = "Dark2") 

p <- ggplot(data = df, aes(x = category, y = counts, 
                           fill = category))+
  geom_bar(stat = "identity", width = 0.777) + 
  scale_fill_grey() 
p

p + theme_minimal()

p <- p + theme_classic()
p
p + theme_

# Add labels
p + geom_text(aes(label=counts))

# Pimp labels
p + geom_text(aes(label=counts), 
              size=10, vjust=2, color="orange")

# Determine labels
p + 
  geom_text(
    aes(label = c("BLACK", "IS THE NEW", "ORANGE")), 
    size = 7, vjust = 2, 
    color = "orange", fontface = "bold")

# Pimp the plot
p <- p + 
  geom_text(
    aes(label = c("BLACK", "IS THE NEW", "ORANGE")), 
    size = 7, hjust = -0.1, 
    color = "orange", fontface = "bold")+
  coord_flip()+
  ylim(0, 45)+
  scale_x_discrete(limits = c("A", "B", "C"))
p

# Move the legend, change it's name and labels
a <- p + theme(legend.position = "top")
b <- p + theme(legend.position = "bottom")
c <- p + theme(legend.position = "none")

p <- p + theme(legend.position = "bottom")+ 
  scale_fill_grey(name = "Quarter", 
                  labels = c("1", "2", "3"))

library(patchwork)
(a + b) / (c + p)

# labs & theme
p + 
  labs(
    title    = "Quarterly TV-show Profit 
                (in million U.S. dollars)",
    subtitle = "A simple bar chart with gray scaling,
                on colored issue",
    caption  = "Source: Secret Data Base Noone 
                Knows About",
    x        = "Quarter of 2020",
    y        = "Profit in 2020"
  )+
  theme(
    plot.title    = element_text(color = "#0099f9", 
                                 size = 15),
    plot.subtitle = element_text(face = "bold"),
    plot.caption  = element_text(face = "italic"),
    axis.title.x  = element_text(color = "#0099f9", 
                                 size = 14, 
                                 face = "bold"),
    axis.title.y  = element_text(size = 14, 
                                 face = "italic"),
    axis.text.y   = element_blank(),
    axis.ticks.y  = element_blank()
  )

# Let's summarize everything we've learned so far
ggplot(df, aes(category, y = counts, fill = category))+
  geom_bar(stat = "identity", width = 0.7)+ 
  scale_fill_grey(name = "NEW TV SHOW", labels = 
                    c("ORANGE", "IS THE NEW", "GRAY?"))+
  theme_classic()+
  scale_x_discrete(limits = c("C", "B", "A"))+
  geom_text(
    aes(label = c("DREAM BIG","START SMALL","ACT NOW")),
    color = "black", size = 5, hjust = -0.1)+ # vjust
  coord_flip() + ylim(0, 45)+ 
  theme(legend.position = "bottom") + 
  labs(
    title    = "Quarterly TV-show Profit (in MLN US $)",
    subtitle = "A simple bar chart with gray scaling",
    caption  = "Source: Secret Data Noone Knows About",
    x        = "Quarter of 2020",
    y        = "Profit in 2020"
  )+
  theme(
    plot.title = element_text(color = "blue", size = 15),
    plot.subtitle = element_text(face = "bold"),
    plot.caption = element_text(face = "italic"),
    axis.title.x = element_text(color = "blue", size=9),
    axis.title.y = element_text(size = 14),
    axis.text.y  = element_blank(),
    axis.ticks.y = element_blank())

# Save the plot in any format
ggsave(
  filename = "basic_plot.jpg",
  plot     = last_plot(), 
  device   = jpeg, 
  width    = 5, 
  height   = 3)

# Plot multiple categorical variables
library(ggstats) # for stat_prop
d <- as.data.frame(Titanic) %>%
  dplyr::mutate(percentage = Freq/sum(Freq))
str(d)

# Stacked barplot
ggplot(data=d, aes(x=Class, y=Freq, fill = Survived)) +
  geom_bar(stat = "identity", position = "stack")

# Dodged barplot
ggplot(data=d, aes(x=Class, y=Freq, fill=Survived)) +
  geom_bar(stat="identity", position="dodge")

ggplot(data=d, aes(x=Class, y=Freq, fill=Survived)) +
  geom_bar(stat="identity", position=position_dodge())+
  facet_grid(Age~Sex, scales = "free")+
  geom_text(aes(label=Freq), position=position_dodge(0.9),
            vjust=-.1, color="black", size=3.5)+
  scale_fill_brewer(palette="Paired")+
  theme_bw()

# Barplot With Error Bars: don't use them!
car <- mtcars %>% 
  rownames_to_column(var = "car_name") %>% 
  mutate(cylinders = factor(cyl))

library(ggstatsplot) # for the theme_...
ggplot(car, aes(x = cylinders, y = mpg)) +
  stat_summary(fun = mean, geom = "col", fill ="orange")+
  stat_summary(fun = mean, geom = "point", size = 5) +
  stat_summary(fun.data = mean_cl_normal, # mean_cl_boot
               geom = "errorbar", width = 0.5) + 
  theme_ggstatsplot()

# Percent stacked barplots
library(scales)
ggplot(data=d, aes(x=Class, y=Freq, fill=Survived)) +
  geom_bar(stat="identity", position="fill")+
  scale_y_continuous(labels=percent)

ggplot(data=d, aes(x=Class, weight=Freq, 
                   fill=Survived, by = Class))+
  geom_bar(position="fill")+  # stat="identity" removed
  scale_y_continuous(labels=percent)+
  facet_grid(~Sex)+
  geom_text(stat = "prop", position=position_fill(0.5))+
  theme_test()

grouped_ggbarstats(
  data = d, 
  x = Survived,
  y = Class, 
  count = Freq, 
  label = "both",
  grouping.var = Sex
)
