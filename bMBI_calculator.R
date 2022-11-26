# Script for calculating the bMBI bacterial index for NZKS farms in the Marlborough Sounds NZ###############
# Javier Atalah ####
# November 2021 ####

rm(list = ls())
# setwd("C:/Users/javiera/Desktop") #change directory to where data files are

# Load libraries 
library(tidyverse)
# install.packages('tidyverse') # install if needed

# Load helper functions ----
source('helper_functions.R')

# read the Eco-Groups file-------
eg <- read_csv('eg_groups.csv')

# read the ASV data table and convert to presence/absence. The AVS are as columns and samples are as rows. The first column must be named 'ASV' otherwise rename (see code below to change from "feature-id' for example) ---
asv <-
  read_delim("ASV_table.txt", # change as needed 
             "\t",
             escape_double = FALSE,
             trim_ws = TRUE) %>%
  rename(ASV = 'feature-id') %>% # rename if first column is not named 'ASV' 
  mutate_at(vars(-ASV),~if_else(.>0,1,0)) # convert to presence / absence

# calculate the proportion of Eco_groups in the ASV data ----
eg_prop <- eg_prop_calc(data = asv, eg = eg)

# Calculate the bMBI index and save the data -----
bMBI_data <-  
  MBI_calc(eg_prop_data = eg_prop, weights = weights) %>% 
  write_csv('my_bMBI_data.csv') # change as needed 

# FIN ----