# --------------------------------------------------------------------------------
#
# Comprehension Check - Linear regression for prediction - Question 6
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

# Create a data set using the following code

set.seed(1)
n <- 1000
Sigma <- matrix(c(1.0, 0.75, 0.75, 0.75, 1.0, 0.25, 0.75, 0.25, 1.0), 3, 3)
dat <- MASS::mvrnorm(n = 100, c(0, 0, 0), Sigma) %>%
     data.frame() %>% setNames(c("y", "x_1", "x_2"))

x <- cor(dat)
# Note that y is correlated with both x_1 and x_2 but the two predictors are
# independent of each other, as seen by cor(dat).

# Use the caret package to partition into a test and training set of equal size.
# Compare the RMSE when using just x_1, just x_2 and both x_1 and x_2. Train a
# linear model for each.

# Which of the three models performs the best (has the lowest RMSE)? [Note:
# after working the problem, the assumptions are NO REPLICATIONS]
     
# -----------------------------------------------------------------
# x_1
# -----------------------------------------------------------------
set.seed(1)
n <- 1000 # Note that this become irrelevant because there are 0 replications
Sigma <- matrix(c(1.0, 0.75, 0.75, 0.75, 1.0, 0.25, 0.75, 0.25, 1.0), 3, 3)
dat <- MASS::mvrnorm(n = 100, c(0, 0, 0), Sigma) %>%
     data.frame() %>% setNames(c("y", "x_1", "x_2"))

set.seed(1)
results <- {
     
     # Partition the dataset into test and training sets of equal size
     train_index <- createDataPartition(dat$y, p = .5, list = FALSE, times = 1)
     train_set <- dat[-train_index,]
     test_set <- dat[train_index,] 
     
     # Train the model
     model <- lm(y ~ x_1, data = train_set)
     model_prediction <- predict(model, test_set) 
     
     # Calculate the RMSE
     model_result <- test_set$y - model_prediction
     model_rmse <- sqrt(mean(model_result^2))
}
mean(results) # two decimal places are sufficient
# [1] 0.600666

# -----------------------------------------------------------------
# x_2
# -----------------------------------------------------------------
set.seed(1)
n <- 1000 # Note that this become irrelevant because there are 0 replications
Sigma <- matrix(c(1.0, 0.75, 0.75, 0.75, 1.0, 0.25, 0.75, 0.25, 1.0), 3, 3)
dat <- MASS::mvrnorm(n = 100, c(0, 0, 0), Sigma) %>%
     data.frame() %>% setNames(c("y", "x_1", "x_2"))

set.seed(1)
results <- {
     
     # Partition the dataset into test and training sets of equal size
     train_index <- createDataPartition(dat$y, p = .5, list = FALSE, times = 1)
     train_set <- dat[-train_index,]
     test_set <- dat[train_index,] 
     
     # Train the model
     model <- lm(y ~ x_2, data = train_set)
     model_prediction <- predict(model, test_set) 
     
     # Calculate the RMSE
     model_result <- test_set$y - model_prediction
     model_rmse <- sqrt(mean(model_result^2))
}
mean(results) # two decimal places are sufficient
# [1]0.630699

# x_1 and x_2
set.seed(1)
n <- 1000 # Note that this become irrelevant because there are 0 replications
Sigma <- matrix(c(1.0, 0.75, 0.75, 0.75, 1.0, 0.25, 0.75, 0.25, 1.0), 3, 3)
dat <- MASS::mvrnorm(n = 100, c(0, 0, 0), Sigma) %>%
     data.frame() %>% setNames(c("y", "x_1", "x_2"))

set.seed(1)
results <- {
     
          # Partition the dataset into test and training sets of equal size
     train_index <- createDataPartition(dat$y, p = .5, list = FALSE, times = 1)
     train_set <- dat[-train_index,]
     test_set <- dat[train_index,] 
     
     # Train the model
     model <- lm(y ~ x_1 + x_2, data = train_set)
     model_prediction <- predict(model, test_set) 
     
     # Calculate the RMSE
     model_result <- test_set$y - model_prediction
     model_rmse <- sqrt(mean(model_result^2))
}
mean(results) # two decimal places are sufficient
# [1] 0.3070962
