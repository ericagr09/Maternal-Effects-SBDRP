#File for cleaning life history data
# Start by getting sample size 
library(dplyr)
df <- read.csv("LifeHistory_20240604.csv")
# create df that includes only offspring born after the heatwave. 
df$Birth.Date <- as.Date(df$Birth.Date, format="%Y-%m-%d") # convert column to date format
start_date <- as.Date("2011-01-01") # define start date as 2011 - year of MHW 
end_date <- as.Date("2013-12-31") # define end date as three years after MHW
df_postMHW <- df %>% filter(Birth.Date >= start_date & Birth.Date <= end_date)
df_postMHW <- df_postMHW %>% filter(is.na(Death.Date) | Death.Date == "") # remove calves who died. We have 68 offspring born 2011-2013 who are still alive.
# figure out sibling pairs pre heatwave
Mother.ID <- "Mother.ID"
mom_list <- df_postMHW %>% select(all_of(Mother.ID)) # create list of moms who had offspring post MHW
df_moms <- df %>% semi_join(mom_list, by = "Mother.ID") # filter dataset to only include those moms
start_date_preMHW <- as.Date("1955-01-01") # start datw for pre MHW = start of data collection 
end_date_preMHW <- as.Date("2010-12-31") #  end date as before MHW
df_preMHW <- df_moms %>% filter(Birth.Date >= start_date_preMHW & Birth.Date <= end_date_preMHW) # 93 offspring born before 2011 to moms who also had offspring post MHW. 




