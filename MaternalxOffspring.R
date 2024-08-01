# creating initial figure for queensland presentation.
# first step: connect waypoint info with the survey observations. 
# second step: create new data frame with id, average depth use for offspring, maternal average depth use
# third step: create scatterplot with x-axis as mom depth, and y-axis as offspring depth. 
library(dplyr)
library(tidyverse)
library(ggplot2)
waypoint <- read.csv("Waypoints_20240502.csv")
survey <- read.csv("SurveyDolphin_20240321.csv")
lifehistory <- read.csv("LifeHistory_20240604.csv")
# Step One
waypoint <- waypoint %>%
  rename(Observation.ID = Related.Obs.ID)
joint_df <- merge(survey, waypoint, by = 'Observation.ID', all = FALSE)
# Step Two 
id_depth_obs <- joint_df[c('Observation.ID', 'Observation.Date', 'Dolphin.ID', 'Latitude', 'Longitude', 'Depth')]
avg_id_depth_obs <- id_depth_obs %>% # average depth for each ID
  group_by(Dolphin.ID) %>%
  summarise(average_depth = mean(Depth, na.rm = TRUE))
maternal_id <- lifehistory[c('Dolphin.ID', 'Mother.ID')]
maternal_depth <- merge(maternal_id, avg_id_depth_obs, by.x = 'Mother.ID', by.y = 'Dolphin.ID')
maternal_depth <- maternal_depth %>%
  rename(maternal_depth = average_depth)
avg_id_mat <- merge(avg_id_depth_obs, maternal_depth, by ='Dolphin.ID', all = FALSE) # add maternal id 
# Step 3 
ggplot(avg_id_mat, aes(x = maternal_depth, y = average_depth)) +
  geom_point(colour = 'lightblue', size = 1) + 
  geom_smooth(method = "lm", se = FALSE, colour = 'blue4') +
  labs(x = "Maternal Average Depth", y = "Offspring Average Depth") +
  theme_classic() +
  theme(axis.text = element_text(size = 12),
        legend.text = element_text(size = 14),
        axis.title = element_text(size = 14),
        legend.title = element_text(size = 12),
        legend.position = "bottom",
        plot.margin = margin(15, 15, 30, 30),
        axis.title.y = element_text(vjust = 5, face = 'bold'),
        axis.title.x = element_text(vjust = -1, face = 'bold'),
        plot.tag = element_text(size = 22,
                                face = "bold"))


