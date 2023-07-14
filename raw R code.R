# ggplot2 is part of tidyverse
library(tidyverse)

# Create some data
df <- data.frame(
  category = c("A", "B", "C"),
  count = c(10, 20, 30)
)

df

# Basic bar plot
ggplot(df, aes(x = category, y = count)) +
  geom_col()

ggplot(data=df, aes(x=category, y=count)) +
  geom_bar(stat="identity")

# stat identity is needed when the categories were
# already counted








# Change the width of bars
ggplot(data=df, aes(x=category, y=count)) +
  geom_bar(stat="identity", width=0.5)

# Change colors / outlines and insides
ggplot(data=df, aes(x=category, y=count)) +
  geom_bar(stat="identity", color="blue", fill="orange")

# Change plot design with themes
p<-ggplot(data=df, aes(x=category, y=count)) +
  geom_bar(stat="identity")
p
p + theme_minimal()
p + theme_classic()
# p + theme_()

# by typing "theme_" and pressing "tab" you'll 
# be offered multiple themes, try them out

# Choose which items to display :
p + scale_x_discrete(limits=c("A", "B"))
# Reorder items
p + scale_x_discrete(limits=c("C", "A", "B"))

# Add labels
## Outside bars
p + 
  geom_text(aes(label=count), vjust=-0.3, size=3.5)+
  theme_void()
## Inside bars
p +
  geom_text(aes(label=count), vjust=1.6, color="white", size=3.5)+
  theme_minimal()

# Horizontal bar plot
p + coord_flip()

p + 
  coord_flip() + 
  geom_text(aes(label=c("bla", "blup", "blahhhh")), hjust=-0.5, color="black", size=3.5)+
  ylim(0, 37)+
  theme_bw()





# Count, then plot bars. In these examples, the height 
# of the bar will represent the count of cases.
mtcars <- mtcars %>%
  mutate_at(c("cyl", "am"), factor)
mtcars %>% head()
table(mtcars$cyl)

ggplot(mtcars, aes(cyl)) +
  geom_bar() # stat = "count"


# Change barplot line colors by groups
p<-ggplot(df, aes(x=category, y=count, color=category)) +
  geom_bar(stat="identity", fill="white")
p

# Use custom color palettes
p+scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9"))
# Use brewer color palettes
p+scale_color_brewer(palette="Dark2")
# Use grey scale
p + scale_color_grey() + theme_classic()

p<-ggplot(df, aes(x=category, y=count, fill=category)) +
  geom_bar(stat="identity")
p


# Use custom color palettes
p + scale_fill_manual(values=c("#999999", "orange", "violet"))
# Use brewer color palettes
p + scale_fill_brewer(palette="Dark2") + theme_light()
# Use grey scale
p + scale_fill_grey() + theme_test()



# Change the legend position
p <- p + scale_fill_grey() + theme_test()
p + theme(legend.position="top")
p + theme(legend.position="bottom")
# Remove legend
p + theme(legend.position="none")


# Include Titles, Subtitles, and Captions
ggplot(df, aes(x = category, y = count)) +
  geom_col(color = "#0099f9", fill = "#ffffff")+
  theme_classic()+
  labs(
    title = "Quarterly Profit (in million U.S. dollars)",
    subtitle = "A simple bar chart",
    caption = "Source: ImaginaryCo",
    x = "Quarter of 2020",
    y = "Profit in 2020"
  )+
  theme(
    plot.title = element_text(color = "#0099f9", size = 20),
    plot.subtitle = element_text(face = "bold"),
    plot.caption = element_text(face = "italic"),
    axis.title.x = element_text(color = "#0099f9", size = 15, face = "bold"),
    axis.title.y = element_text(size = 15, face = "italic")
  )



# Barplot with multiple groups

df2 <- data.frame(supp=rep(c("Oh", "yeah"), each=3),
                  dose=rep(c("A", "B", "C"),2),
                  len=c(6.8, 15, 33, 4.2, 10, 29.5))
head(df2)


# Stacked barplot with multiple groups
ggplot(data=df2, aes(x=dose, y=len, fill=supp)) +
  geom_bar(stat="identity")
# Use position=position_dodge()
ggplot(data=df2, aes(x=dose, y=len, fill=supp)) +
  geom_bar(stat="identity", position=position_dodge())


# Add labels to a dodged barplot :
ggplot(data=df2, aes(x=dose, y=len, fill=supp)) +
  geom_bar(stat="identity", position=position_dodge())+
  geom_text(aes(label=len), vjust=1.6, color="white",
            position = position_dodge(0.9), size=3.5)+
  scale_fill_brewer(palette="Paired")+
  theme_minimal()


# Barplot with error bars
ggplot(mtcars, aes(cyl, mpg)) +
  stat_summary(fun = mean, geom = "col", alpha = 0.5) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               width = 0.5) +
  stat_summary(fun.data = mean_se, geom = "errorbar",
               width = 0.25, color = "red") +
  coord_cartesian(ylim = c(10, 40))+
  theme_minimal()+
  facet_wrap(~vs)


# library
library(ggplot2)

# create a dataset
specie <- c(rep("sorgho" , 3) , rep("poacee" , 3) , rep("banana" , 3) , rep("triticum" , 3) )
condition <- rep(c("normal" , "stress" , "Nitrogen") , 4)
value <- abs(rnorm(12 , 0 , 15))
data <- data.frame(specie,condition,value)

# Stacked + percent

###############
library(ggstats)
d <- as.data.frame(Titanic)
p <- ggplot(d) +
  aes(x = Class, fill = Survived, weight = Freq, by = Class) +
  geom_bar(position = "fill") +
  geom_text(stat = "prop", position = position_fill(.5))
p

p + facet_grid(cols = vars(Sex))

ggplot(d) +
  aes(x = Class, fill = Survived, weight = Freq, by = 1) +
  geom_bar() +
  geom_text(
    aes(label = scales::percent(after_stat(prop), accuracy = 1)),
    stat = "prop",
    position = position_stack(.5)
  )

d <- diamonds %>%
  dplyr::filter(!(cut == "Ideal" & clarity == "I1")) %>%
  dplyr::filter(!(cut == "Very Good" & clarity == "VS2")) %>%
  dplyr::filter(!(cut == "Premium" & clarity == "IF"))

p <- ggplot(d) +
  aes(x = clarity, fill = cut, by = clarity) +
  geom_bar(position = "fill")

p +
  geom_text(
    stat = "prop",
    position = position_fill(.5)
  )

# Adding complete = "fill" will generate “0.0%” labels where relevant.

p +
  geom_text(
    stat = "prop",
    position = position_fill(.5),
    complete = "fill"
  )



################

pl <- ggplot(data = mpg,aes(x= manufacturer, fill = class))
pl <- pl + geom_bar(stat="count", position ="fill")
pl <- pl + ggthemes::theme_economist()
pl <- pl  + theme(axis.text.x = element_text(angle = 90,hjust =0 ))
pl <- pl + labs(title ="My title")
pl <- pl + labs(subtitle ="My subtitle")
pl <- pl + labs(caption ="My caption")
pl <- pl  + labs(x ="Car Brand", y = "Percentage")
pl <- pl + scale_y_continuous(labels = scales::percent)
#pl <- pl + ggplot2::coord_flip()
pl

dt <- mpg%>%
  dplyr::group_by(manufacturer, class)%>%
  dplyr::tally()%>%
  dplyr::mutate(percent=n/sum(n))


pl <- ggplot(data = dt,aes(x= manufacturer, y = n,fill = class))
pl <- pl + geom_bar(stat="identity")
pl <- pl + geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
                     position=position_stack(vjust=0.5), colour="white", size = 2)


pl <- pl  + theme(axis.text.x = element_text(angle = 90,hjust =0 ))
pl

pl <- ggplot(data = dt,aes(x= manufacturer, y = n,fill = class))
pl <- pl + geom_bar(stat="identity", position ="fill")
pl <- pl + geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
                     position=position_fill(vjust=0.5), colour="white", size =2)

pl <- pl + theme_minimal()
pl <- pl + labs(title ="My title")
pl <- pl + labs(subtitle ="My subtitle")
pl <- pl + labs(caption ="My caption")
pl <- pl  + labs(x ="Car Brand", y = "Percentage")
pl <- pl  + theme(axis.text.x = element_text(angle = 90,hjust =0 ))
pl

pl <- ggplot(data = dt,aes(x= manufacturer, y = n,fill = class))
pl <- pl + geom_bar(stat="identity", position ="fill")
pl <- pl + geom_text(aes(label=paste0(sprintf("%1.1f", percent*100),"%")),
                     position=position_fill(vjust=0.5), colour="white")

pl <- pl + theme_minimal()
pl <- pl + labs(title ="My title")
pl <- pl + labs(subtitle ="My subtitle")
pl <- pl + labs(caption ="My caption")
pl <- pl  + labs(x ="Car Brand", y = "Percentage")
pl <- pl + coord_flip()
pl

####################

ggplot(data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar(position="fill", stat="identity")

mtcars %>%
  dplyr::group_by(cyl, am) %>%
  dplyr::summarise(n = n()) %>%
  dplyr::mutate(prop = n / sum(n)) %>%
  dplyr::ungroup()  -> data_ggplot



ggplot(data_ggplot, aes(x = cyl, y = prop, fill = am)) +
  geom_bar(position="fill", stat = "identity") +
  geom_text(aes(label = paste0(am, "\n", n, "\n", "(", round(prop) * 100, "%)" )), 
            position = position_stack(vjust = 0.5)) +
  theme(legend.position = "none",
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank())

ggplot(data_ggplot, aes(x = cyl, y = prop, fill = am)) +
  geom_bar(position="fill", stat = "identity") +
  geom_text(aes(label = paste0(n, "\n", "(", round(prop) * 100, "%)" )), 
            position = position_stack(vjust = 0.5))+
  theme(legend.position = "top")


library(scales)
# Generate data
set.seed(1234)
school_quality <-
  tibble(
    id = seq(1, 300, 1),
    school = rep(c(
      "Sabin", "Vernon", "Faubion", "Irvington", "Alameda", "Beverly Cleary"
    ), 50),
    opinion = sample(c("Very bad", "Bad", "Good", "Very Good"), 300, replace = TRUE)
  )
school_quality

school_quality_summary <- school_quality %>% 
  group_by(school, opinion) %>% 
  count(name = "n_answers") %>% 
  group_by(school) %>% 
  mutate(percent_answers = n_answers / sum(n_answers)) %>% 
  ungroup() %>% 
  mutate(percent_answers_label = percent(percent_answers, accuracy = 1))
school_quality_summary

school_quality_summary %>%
  ggplot(aes(x = school, 
             y = percent_answers,
             fill = opinion)) +
  geom_col() +
  geom_text(aes(label = percent_answers_label),
            position = position_stack(vjust = 0.5),
            color = "white",
            fontface = "bold") +
  coord_flip() +
  scale_x_discrete() +
  scale_fill_viridis_d() +
  labs(title = "How good is the education at your school?",
       x = NULL,
       fill = NULL) +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "top")

# Basic Diverging Bar Chart
school_quality_summary_diverging <- school_quality_summary %>%
  mutate(percent_answers = if_else(opinion %in% c("Very Good", "Good"), percent_answers, -percent_answers)) %>% 
  mutate(percent_answers_label = percent(percent_answers, accuracy = 1))
school_quality_summary_diverging

school_quality_summary_diverging %>%
  ggplot(aes(x = school, 
             y = percent_answers,
             fill = opinion)) +
  geom_col() +
  geom_text(aes(label = percent_answers_label),
            position = position_stack(vjust = 0.5),
            color = "white",
            fontface = "bold") +
  coord_flip() +
  scale_x_discrete() +
  scale_fill_viridis_d() +
  labs(title = "How good is the education at your school?",
       x = NULL,
       fill = NULL) +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "top")

# Positive/Negative Labels
school_quality_summary_diverging_good_labels <- school_quality_summary_diverging %>%
  mutate(percent_answers_label = abs(percent_answers)) %>% 
  mutate(percent_answers_label = percent(percent_answers_label, accuracy = 1))
school_quality_summary_diverging_good_labels

school_quality_summary_diverging_good_labels %>% 
  ggplot(aes(x = school, 
             y = percent_answers,
             fill = opinion)) +
  geom_col() +
  geom_text(aes(label = percent_answers_label),
            position = position_stack(vjust = 0.5),
            color = "white",
            fontface = "bold") +
  coord_flip() +
  scale_x_discrete() +
  scale_fill_viridis_d() +
  labs(title = "How good is the education at your school?",
       x = NULL,
       fill = NULL) +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "top")

# Reorder Bars
school_quality_summary_diverging_right_order <- school_quality_summary_diverging_good_labels %>% 
  mutate(opinion = fct_relevel(opinion,
                               "Bad", "Very bad", "Good", "Very Good"),
         opinion = fct_rev(opinion)) 

school_quality_summary_diverging_right_order


school_quality_summary_diverging_right_order %>%
  ggplot(aes(x = school, 
             y = percent_answers,
             fill = opinion)) +
  geom_col() +
  geom_text(
    aes(label = percent_answers_label),
    position = position_stack(vjust = 0.5),
    color = "white",
    fontface = "bold"
  ) +
  coord_flip() +
  scale_x_discrete() +
  scale_fill_viridis_d() +
  labs(title = "How good is the education at your school?",
       x = NULL,
       fill = NULL) +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "top")

# Make Legend Order Match
school_quality_summary_diverging_right_order %>%
  ggplot(aes(x = school, 
             y = percent_answers,
             fill = opinion)) +
  geom_col() +
  geom_text(aes(label = percent_answers_label),
            position = position_stack(vjust = 0.5),
            color = "white",
            fontface = "bold") +
  coord_flip() +
  scale_x_discrete() +
  scale_fill_viridis_d(breaks = c("Very bad", "Bad", "Good", "Very Good")) +
  labs(title = "How good is the education at your school?",
       x = NULL,
       fill = NULL) +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "top")

# Improve Colors
school_quality_summary_diverging_right_order %>%
  ggplot(aes(x = school, 
             y = percent_answers,
             fill = opinion)) +
  geom_col() +
  geom_text(aes(label = percent_answers_label),
            position = position_stack(vjust = 0.5),
            color = "white",
            fontface = "bold") +
  coord_flip() +
  scale_x_discrete() +
  scale_fill_manual(breaks = c("Very bad", "Bad", "Good", "Very Good"),
                    values = c(
                      "Very bad" = "darkorange3",
                      "Bad" = "orange",
                      "Good" = "deepskyblue",
                      "Very Good" = "deepskyblue4"
                    )) +
  labs(title = "How good is the education at your school?",
       x = NULL,
       fill = NULL) +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid = element_blank(),
        legend.position = "top")










bla <- mtcars %>% 
  group_by(cyl, am) %>% 
  summarise(mean_mpg = mean(mpg)) %>% 
  ungroup() %>% 
  mutate_if(is.numeric, ~round(., 1))

# Add Labels to Individual Bars
ggplot(mtcars, aes(x = cyl, y = mpg, fill = am)) +
  geom_col(position = position_dodge())+
  geom_text(aes(label = mean(mpg)), 
            position = position_dodge(0.9), 
            vjust = 2, size = 4, color = "#ffffff")+ 
  geom_hline(yintercept = mean(mtcars$mpg, na.rm = T), 
             linetype = "dashed", size = 1)






# totally fancy bar plot
# load libraries
# devtools::install_github("tidyverse/ggplot2")
library(ggplot2)
library(ggchicklet)
library(ggtext)
library(dplyr)
library(forcats)
library(grid)

# import data
dat <- dat <- data.frame(
  Sport = c("NFL", "NFL", "NFL", "MLB", "MLB", "MLB", "NBA", "NBA",
            "NBA", "NHL", "NHL", "NHL", "EPL", "EPL", "EPL"),
  Type = c("Game Action", "Nonaction", "Commercials", "Game Action",
           "Nonaction", "Commercials", "Game Action", "Nonaction", "Commercials",
           "Game Action", "Nonaction", "Commercials", "Game Action", "Nonaction",
           "Commercials"),
  Time = c(18, 140.6, 49.9, 22.5, 150.9, 51.8, 49.6, 61.8,
           33.5, 63, 56.6, 37.4, 58.7, 47.8, 10.1),
  stringsAsFactors = FALSE)

# refactor levels
dat <- dat %>% group_by(Sport) %>% mutate(Percent = Time/sum(Time)) %>% ungroup() %>%
  mutate(Sport = fct_relevel(
    Sport,
    rev(c("NFL", "MLB", "NBA", "NHL", "EPL")))
  ) %>%
  mutate(Type = fct_relevel(
    Type,
    c("Commercials","Nonaction","Game Action"))
  )

# keep trailing zeroes and add "min" to first bar value labels
dat$Label <- as.character(sprintf("%.1f", dat$Time))
dat$Label <- ifelse(dat$Type == "Game Action", paste0(dat$Label, " min"), dat$Label)

# generate plot
gg <- ggplot(dat, aes(Sport, Percent,  fill = Type, label = Label)) +
  geom_chicklet(width = 1,radius = unit(6,units = "pt"), position = ggplot2::position_stack(reverse = FALSE)) +
  geom_text(size = 4, fontface= "bold", position = position_stack(vjust = 0.5)) +
  scale_y_continuous(limits = c(0,1),expand = c(0, 0)) +  coord_flip() +
  theme_minimal() +
  theme(
    legend.position = "top",
    plot.title = element_markdown(hjust =0.5),
    plot.subtitle = element_markdown(hjust = 0.5),
    plot.caption = element_markdown(hjust = 0, size = 11, margin = unit(c(0, 0, 0, 0), "cm"), color = "#718c9e"),
    legend.text = element_markdown(size = 11),
    axis.text = element_text(face = "bold", size = 11),
    axis.text.x = element_blank(),
    axis.title.y = element_markdown(hjust = 0, size = 20, margin = unit(c(0, 0, 0, 0), "cm"), color = "#718c9e"),
    panel.grid = element_blank(),
    axis.title.x = element_markdown(
      halign = 0,
      margin = margin(2, 0, 15, 0),
      fill = "transparent"
    )
    
  ) +
  scale_fill_manual(
    name = NULL,
    values = c(`Game Action` = "#FA759F", Nonaction = "#B5BEC9", Commercials = "#72D4DB"),
    labels = c(
      # `Game Action` = "<strong style='color:#FA759F'>GAME ACTION</strong> (BALL OR PUCK IN PLAY)",
      # Nonaction = "<strong style='color:#B5BEC9'>NONACTION</strong> (GAME STOPPAGE, COMMENTARY, ETC.)",
      # Commercials = "<strong style='color:#72D4DB'>COMMERCIALS</strong>")
      `Game Action` = "<strong>GAME ACTION</strong> (BALL OR PUCK IN PLAY)",
      Nonaction = "<strong>NONACTION</strong> (GAME STOPPAGE, COMMENTARY, ETC.)",
      Commercials = "<strong>COMMERCIALS</strong>"),
    guide = guide_legend(reverse = TRUE)
  ) +
  labs(
    y = "<span style='font-size:13pt;'>The average share of broadcast time showing <strong style='color:#FA759F'>GAME ACTION</strong> is highest in<br>the English Premier League - but there is more total action in an average<br>National Hockey League game, which lasts longer.</span>",    x = NULL, fill = NULL,
    title = "<b>NFL and MLB games are long, slow affairs</b>",
    subtitle = "Minutes by broadcast by what is shown on screen across five major men's sports leagues",
    caption = "Games that we included: 10 NFL regular-season games between Nov. 7 amd Nov. 18, 2019. 17 MLB postseason games, including all the games in the 2019
        ACLS, NLCS, and World<br>Series; 10 NBA regular-season games between Nov. 6 and Nov. 15, 2019; 10 NHL regular-season games between Nov. 5 and Nov. 19, 2019, including three overtime games;
        and<br>seven English Premier League games between Nov. 9 and Nov. 23, 2019. NBA game action includes free throws, so the action time exceeds the game time.<br>
        <br>
        FiveThirtyEight SOURCE: UNIVERSITY OF TEXAS AT AUSTIN SPORTS ANALYTICS COURSE"
  )


alignTitles <- function(ggplot, title = NULL, subtitle = NULL, caption = NULL) {
  # grab the saved ggplot2 object
  g <- ggplotGrob(ggplot)
  
  
  # find the object which provides the plot information for the title, subtitle, and caption
  if(!is.null(title)) {
    g$layout[which(g$layout$name == "title"),]$l <- title
  }
  if(!is.null(subtitle)) {
    g$layout[which(g$layout$name == "subtitle"),]$l <- subtitle
  }
  if(!is.null(caption)) {
    g$layout[which(g$layout$name == "caption"),]$l <- caption
  }
  g
}

# align caption to y axis value labels
gg2 <- alignTitles(gg, caption = 2)
grid.draw(gg2)

# add arrow
x <- rev(c(0.25, 0.25, 0.28, 0.28))
y <- rev(c(0.2, 0.15, 0.15, 0.15))
grid.bezier(x, y, gp=gpar(lwd=1.5, fill="black"),
            arrow=arrow(type="open",length = unit(0.1, "inches")))


# Circular bar plots

# library
library(tidyverse)
library(viridis)

# Create dataset
data <- data.frame(
  individual=paste( "Mister ", seq(1,60), sep=""),
  group=c( rep('A', 10), rep('B', 30), rep('C', 14), rep('D', 6)) ,
  value1=sample( seq(10,100), 60, replace=T),
  value2=sample( seq(10,100), 60, replace=T),
  value3=sample( seq(10,100), 60, replace=T)
)

# Transform data in a tidy format (long format)
data <- data %>% gather(key = "observation", value="value", -c(1,2)) 

# Set a number of 'empty bar' to add at the end of each group
empty_bar <- 2
nObsType <- nlevels(as.factor(data$observation))
to_add <- data.frame( matrix(NA, empty_bar*nlevels(data$group)*nObsType, ncol(data)) )
colnames(to_add) <- colnames(data)
to_add$group <- rep(levels(data$group), each=empty_bar*nObsType )
data <- rbind(data, to_add)
data <- data %>% arrange(group, individual)
data$id <- rep( seq(1, nrow(data)/nObsType) , each=nObsType)

# Get the name and the y position of each label
label_data <- data %>% group_by(id, individual) %>% summarize(tot=sum(value))
number_of_bar <- nrow(label_data)
angle <- 90 - 360 * (label_data$id-0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)
label_data$hjust <- ifelse( angle < -90, 1, 0)
label_data$angle <- ifelse(angle < -90, angle+180, angle)

# prepare a data frame for base lines
base_data <- data %>% 
  group_by(group) %>% 
  summarize(start=min(id), end=max(id) - empty_bar) %>% 
  rowwise() %>% 
  mutate(title=mean(c(start, end)))

# prepare a data frame for grid (scales)
grid_data <- base_data
grid_data$end <- grid_data$end[ c( nrow(grid_data), 1:nrow(grid_data)-1)] + 1
grid_data$start <- grid_data$start - 1
grid_data <- grid_data[-1,]

# Make the plot
p <- ggplot(data) +      
  
  # Add the stacked bar
  geom_bar(aes(x=as.factor(id), y=value, fill=observation), stat="identity", alpha=0.5) +
  scale_fill_viridis(discrete=TRUE) +
  
  # Add a val=100/75/50/25 lines. I do it at the beginning to make sur barplots are OVER it.
  geom_segment(data=grid_data, aes(x = end, y = 0, xend = start, yend = 0), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 50, xend = start, yend = 50), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 100, xend = start, yend = 100), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 150, xend = start, yend = 150), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  geom_segment(data=grid_data, aes(x = end, y = 200, xend = start, yend = 200), colour = "grey", alpha=1, size=0.3 , inherit.aes = FALSE ) +
  
  # Add text showing the value of each 100/75/50/25 lines
  ggplot2::annotate("text", x = rep(max(data$id),5), y = c(0, 50, 100, 150, 200), label = c("0", "50", "100", "150", "200") , color="grey", size=6 , angle=0, fontface="bold", hjust=1) +
  
  ylim(-150,max(label_data$tot, na.rm=T)) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.margin = unit(rep(-1,4), "cm") 
  ) +
  coord_polar() +
  
  # Add labels on top of each bar
  geom_text(data=label_data, aes(x=id, y=tot+10, label=individual, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=5, angle= label_data$angle, inherit.aes = FALSE ) +
  
  # Add base line information
  geom_segment(data=base_data, aes(x = start, y = -5, xend = end, yend = -5), colour = "black", alpha=0.8, size=0.6 , inherit.aes = FALSE )  +
  geom_text(data=base_data, aes(x = title, y = -18, label=group), hjust=c(1,1,0,0), colour = "black", alpha=0.8, size=4, fontface="bold", inherit.aes = FALSE)


p



# Barplots with statistical tests
d <- ISLR::Auto %>% 
  filter(origin != 2) %>% 
  mutate_at(vars(cylinders, year, origin), factor)

library(ggstatsplot)
grouped_ggbarstats(
  data = d, 
  x = cylinders, 
  y = year, 
  grouping.var = origin
)
