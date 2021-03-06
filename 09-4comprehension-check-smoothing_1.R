# --------------------------------------------------------------------------------
#
# COmprehension check - Smoothing - Question 1
#
# --------------------------------------------------------------------------------

# Setup
library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
library(Lahman)
library(HistData)
library(caret)
library(e1071)
library(purrr)
library(pdftools)
library(lubridate)
library(stringr)

# In the Wrangling course of this series, PH125.6x, we used the following code
# to obtain mortality counts for Puerto Rico for 2015-2018:

fn <- system.file("extdata", "RD-Mortality-Report_2015-18-180531.pdf", package="dslabs")
dat <- map_df(str_split(pdf_text(fn), "\n"), function(s){
     s <- str_trim(s)
     header_index <- str_which(s, "2015")[1]
     tmp <- str_split(s[header_index], "\\s+", simplify = TRUE)
     month <- tmp[1]
     header <- tmp[-1]
     tail_index  <- str_which(s, "Total")
     n <- str_count(s, "\\d+")
     out <- c(1:header_index, which(n==1), which(n>=28), tail_index:length(s))
     s[-out] %>%
          str_remove_all("[^\\d\\s]") %>%
          str_trim() %>%
          str_split_fixed("\\s+", n = 6) %>%
          .[,1:5] %>%
          as_data_frame() %>% 
          setNames(c("day", header)) %>%
          mutate(month = month,
                 day = as.numeric(day)) %>%
          gather(year, deaths, -c(day, month)) %>%
          mutate(deaths = as.numeric(deaths))
}) %>%
     mutate(month = recode(month, "JAN" = 1, "FEB" = 2, "MAR" = 3, "APR" = 4, "MAY" = 5, "JUN" = 6, 
                           "JUL" = 7, "AGO" = 8, "SEP" = 9, "OCT" = 10, "NOV" = 11, "DEC" = 12)) %>%
     mutate(date = make_date(year, month, day)) %>%
     filter(date <= "2018-05-01")

# *** resulting data set dat ***

# A tibble: 1,205 x 5
#      day month year  deaths date      
#  <dbl> <dbl> <chr>    <dbl> <date>    
#  1     1     1 2015     107 2015-01-01
#  2     2     1 2015     101 2015-01-02
#  3     3     1 2015      78 2015-01-03
#  4     4     1 2015     121 2015-01-04
#  5     5     1 2015      99 2015-01-05
#  6     6     1 2015     104 2015-01-06
#  7     7     1 2015      79 2015-01-07
#  8     8     1 2015      73 2015-01-08
#  9     9     1 2015      90 2015-01-09
# 10    10     1 2015      75 2015-01-10
# ... with 1,195 more rows

# Note that dat$date is a vector of 1000 entries like these:
head(dat$date)
# [1] "2015-01-01" "2015-01-02" "2015-01-03" "2015-01-04" "2015-01-05" "2015-01-06"

# *** ASSIGNMENT *** 
# Use the loess function to obtain a smooth estimate of the expected number of
# deaths as a function of date. Plot this resulting smooth function. Make the
# span about two months long.

# See the video lecture and literally copy that code when they use the loess
# function, just change the variables to match your variable names.

# The first thing we find out when trying this is that dat$deaths has 1205 
# entries and fit$fitted has 1204. There is an # NA in the deaths column that 
# neesde to be removed.
dat <- dat[!is.na(dat$deaths),]

# Now we can follow the loess example in the prior lecture
total_days <- diff(range(as.numeric(dat$date)))
span <- 62/total_days

fit <- loess(deaths ~ as.numeric(date), degree=1, span = span, data=dat)

dat %>% mutate(smooth = fit$fitted, date) %>%
     ggplot(aes(as.numeric(date), deaths)) +
     geom_point(size = 3, alpha = .5, color = "grey") +
     geom_line(aes(as.numeric(date), smooth), color="red")

# Answer: the first of the 4 plots is the match
