eg_prop_calc <- 
  function(data,eg) {
    require(tidyverse)
    data %>%
      gather(SampleID, abund, - ASV) %>%
      group_by(SampleID) %>%
      mutate(S = sum(abund)) %>% 
      inner_join(eg, by = 'ASV') %>%
      group_by(SampleID) %>%
      mutate(N = sum(abund),
             p_assign = sum(abund)/first(S)) %>% 
      group_by(SampleID, EG) %>%
      mutate(n = sum(abund) / N) %>%
      summarise(n = first(n) * 100, percent_assigned = first(p_assign), .groups = 'drop') %>%
      spread(EG, n) %>% 
      ungroup()
  }


MBI_calc <-
  function(eg_prop_data, weights) {
    require(dplyr)
    eg_prop_data %>%
      mutate(
        bMBI = (
          (if(exists("I")) 0.016863758 * I else 0) + 
            (if(exists("II")) 0.030708955 * II else 0) + 
            (if(exists("III")) 0.025045309 * III else 0)+ 
            (if(exists("IV")) 0.038874496 * IV else 0) + 
            (if(exists("V")) 0.066454741 * V else 0) + 
            (if(exists("VI")) 0.085 * VI else 0)
        )
      )
  }





