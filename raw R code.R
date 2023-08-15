# ggplot2 is part of tidyverse
library(tidyverse)

# Create some data
df <- tibble(
  category = c("A", "B", "C"),
  count    = c( 10,  20,  30)
)

df

# Basic bar plot

# Two ways to plot categories: 
# 1) already counted, 2) not yet counted

# stat=(bourne)"identity" is needed for counted categories
ggplot(data=df, aes(x=category, y=count)) +
  geom_bar(stat="identity")

# we have nice wide bars, but if they are too wide ...

# Change the width of bars
ggplot(data=df, aes(x=category, y=count)) +
  geom_bar(stat="identity", width=0.4)

# we can bring some color into the game, to make things less boring
# We can change colors in 2 ways: outside and inside of bars
# if you look at the shocko-cake, it's brown outside, 
# but it's often different color inside
ggplot(data=df, aes(x=category, y=count)) +
  geom_bar(stat="identity", width=0.4, 
           fill="white", color = "black")

# if we wont different colors for different bars, 
# you can specify fill and color inside of ascetics
ggplot(data=df, aes(x=category, y=count, 
                    fill = category, color = -count)) +
  geom_bar(stat="identity")

# By the way, we can save our plot as an object in order
# to reduce typing and use that object for further manupulation
p <- ggplot(data=df, aes(x=category, y=count, fill = category)) +
  geom_bar(stat="identity", width=0.777)
p

p + scale_fill_manual(values=c("#999999", "orange", "violet"))

p + scale_fill_brewer(palette="Dark2") 

p <- p + scale_fill_grey() 
p

p + theme_minimal()

p <- p + theme_classic()
p
# p + theme_()






## Inside bars
p + geom_text(aes(label=count))


p + geom_text(aes(label=count), 
              size=7, vjust=2, color="orange")
p + 
  geom_text(
    aes(label=c("ORANGE", "IS THE NEW", "BLACK")), 
    vjust=2, size=5, color="orange", fontface = "bold")

# Horizontal bar plot
p + 
  geom_text(
    aes(label=c("ORANGE", "IS THE NEW", "BLACK")), 
    vjust=2, size=5, color="orange", fontface = "bold")+
  coord_flip()

# now we can horizontally adjust text 
p + 
  geom_text(
    aes(label=c("ORANGE", "IS THE NEW", "BLACK")), 
    hjust=-0.5, size=5, color="orange", fontface = "bold")+
  coord_flip()


# Change the legend position


p <- p + 
  geom_text(
    aes(label=c("ORANGE", "IS THE NEW", "BLACK")), 
    hjust=-0.25, size=5, color="orange", fontface = "bold")+
  coord_flip()+
  ylim(0, 45)+
  scale_x_discrete(limits=c("C", "B", "A"))
p


p + 
  labs(
    title    = "Quarterly TV-show Profit (in million U.S. dollars)",
    subtitle = "A simple bar chart with gray scaling, on colored issue",
    caption  = "Source: Secret Data Base Noone Knows About",
    x        = "Quarter of 2020",
    y        = "Profit in 2020"
  )+
  theme(
    plot.title = element_text(color = "#0099f9", size = 15),
    plot.subtitle = element_text(face = "bold"),
    plot.caption = element_text(face = "italic"),
    axis.title.x = element_text(color = "#0099f9", size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "italic"),
    axis.text.y  = element_blank(),
    axis.ticks.y = element_blank()
  )

# let's summarize what we have learned so far:
# first final plot: might look like a lot of code, but
# it's kind of intuitive if going step by step, for instance
df
ggplot(data=df, aes(x=category, y=count, fill = category)) +
  geom_bar(stat="identity", width=0.7)+ 
  scale_fill_grey(name = "NEW TV SHOW", 
                  labels = c("ORANGE", "IS THE NEW", "GRAY???"))+
  theme_classic()+
  scale_x_discrete(limits=c("C", "B", "A"))+
  coord_flip()+
  geom_text(
    aes(label=c("DREAM BIG","START SMALL","ACT NOW")),
    color="black", size=5, hjust=-0.1)+ # vjust
  ylim(0, 45)+ 
  theme(legend.position="bottom") + 
  labs(
    title    = "Quarterly TV-show Profit (in million U.S. dollars)",
    subtitle = "A simple bar chart with ca. 50 shades of gray",
    caption  = "Source: Secret Data Base Noone Knows About",
    x        = "CREATIVITY",
    y        = "INVEST IN YOURSELF"
  )+
  theme(
    plot.title = element_text(color = "orange", size = 15),
    plot.subtitle = element_text(face = "bold"),
    plot.caption = element_text(face = "italic"),
    axis.title.x = element_text(color = "orange", size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "italic"),
    axis.text.y  = element_blank(),
    axis.ticks.y = element_blank()
  )

# and before we loose all the changes, we can save this plot
# using ggsave command
ggsave(
  filename = "basic_plot.jpg",
  plot = last_plot(), 
  device = jpeg, 
  width = 5, height = 3)
















# Barplot with multiple groups + Stacked + Dodged + Percented

library(ggstats) # for stat_prop
d <- as.data.frame(Titanic) %>%
  dplyr::mutate(percent=Freq/sum(Freq))
str(d)

# Stacked barplot with multiple groups
ggplot(data=d, aes(x=Class, y=Freq, fill=Survived)) +
  geom_bar(stat="identity", position = "stack")

ggplot(data=d, aes(x=Class, y=Freq, fill=Survived)) +
  geom_bar(stat="identity", position="dodge")

# Add labels to a dodged barplot as we just learned :
ggplot(data=d, aes(x=Class, y=Freq, fill=Survived)) +
  geom_bar(stat="identity", position=position_dodge())+
  facet_grid(Age~Sex, scales = "free")+
  geom_text(aes(label=Freq), position = position_dodge(0.9),
            vjust=-.1, color="black", size=3.5)+
  scale_fill_brewer(palette="Paired")+
  theme_void()


ggplot(data=d, aes(x=Class, y=Freq, fill=Survived)) +
  geom_bar(stat="identity", position="fill")+
  scale_y_continuous(labels=percent)

ggplot(data=d, aes(x=Class, weight=Freq, fill=Survived)) +
  geom_bar(position="fill")+
  scale_y_continuous(labels=percent)+
  geom_text(stat = "prop", position = position_fill(.5))

ggplot(data=d, aes(x=Class, weight=Freq, fill=Survived, by = Class)) +
  geom_bar(position="fill")+
  scale_y_continuous(labels=percent)+
  geom_text(stat = "prop", position = position_fill(.5))

ggplot(data=d, aes(x=Class, weight=Freq, fill=Survived, by = Class)) +
  geom_bar(position="fill")+
  scale_y_continuous(labels=percent)+
  geom_text(stat = "prop", position = position_fill(.5))+
  facet_wrap(~Sex)+
  scale_fill_brewer(palette="Paired")+
  theme_test()


grouped_ggbarstats(
  data = d, 
  x = Survived,
  y = Class, 
  count = Freq, 
  label = "both",
  grouping.var = Sex
)






######### Barplot with error bars ####################

car <- mtcars %>% 
  rownames_to_column(var = "car_name") %>% 
  mutate(cylinders = factor(cyl))

ggplot(car, aes(x = cylinders, y = mpg)) +
  stat_summary(fun = mean, geom = "col", alpha = 0.5) +
  stat_summary(fun = mean, geom = "point", size = 4) +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.5) + # mean_cl_boot
  theme_bw()


