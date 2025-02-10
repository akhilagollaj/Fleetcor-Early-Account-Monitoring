library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyverse)

install.packages("readxl")
library(readxl)

# Load transaction data
non_X_sell_spend_data <- read_excel("/Users/akhilagolla/Desktop/DBMS/GROUP 3 PROJECT/Fleetcor Project 1_Dataset/Non Cross-Sell Spend.xlsx")
non_X_sell_payment_data <- read_excel("/Users/akhilagolla/Desktop/DBMS/GROUP 3 PROJECT/Fleetcor Project 1_Dataset/Non Cross-Sell Payment.xlsx")

# View the structure of the datasets
str(non_X_sell_spend_data)
str(non_X_sell_payment_data)

# Handle missing values (replace NA with 0 or remove rows with NA)
non_X_sell_spend_data <- non_X_sell_spend_data %>% mutate_all(~replace(., is.na(.), 0))
non_X_sell_payment_data <- non_X_sell_payment_data %>% mutate_all(~replace(., is.na(.), 0))

colSums(is.na(non_X_sell_spend_data))
colSums(is.na(non_X_sell_payment_data))

# Join data(merging) on FAKE_ACCTCODE and YEARMONTH
combined_data <- left_join(non_X_sell_payment_data, non_X_sell_spend_data, by = c("FAKE_ACCTCODE", "YEARMONTH"))

# Summary statistics
summary(combined_data)

# Scatterplot: Payment amount vs. Total spend
ggplot(combined_data, aes(x = TOT_SPEND, y = PAYMENT_AMOUNT)) +
  geom_point() +
  labs(title = "Payment Amount vs. Total Spend", x = "Total Spend", y = "Payment Amount") +
  theme_minimal()

# Correlation analysis
cor(combined_data$TOT_SPEND, combined_data$PAYMENT_AMOUNT, use = "complete.obs")

# Linear regression model
model <- lm(PAYMENT_AMOUNT ~ TOT_SPEND + CREDIT_LIMIT, data = combined_data)
summary(model)

###################################
# Detect outliers using boxplots
ggplot(combined_data, aes(x = "", y = TOT_SPEND)) +
  geom_boxplot() +
  labs(title = "Outliers in Total Spend", y = "Total Spend") +
  theme_minimal()

# 1. examine outliers
# Plot the data to visualize outliers
boxplot(combined_data$TOT_SPEND, main = "Boxplot of Total Spend", ylab = "Total Spend")

# Identify the outliers
outliers <- boxplot.stats(combined_data$TOT_SPEND)$out
print("Outliers:")
print(outliers)

# Inspect rows with outliers
outlier_rows <- combined_data[combined_data$TOT_SPEND %in% outliers, ]
print(outlier_rows)

# 2. access distribution
# Histogram to view the distribution
ggplot(combined_data, aes(x =TOT_SPEND)) +
  geom_histogram(binwidth = 0.5, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Total Spend", x = "Total Spend", y = "Frequency") +
  theme_minimal()

# Density plot to view skewness
ggplot(combined_data, aes(x =TOT_SPEND)) +
  geom_density(fill = "blue", alpha = 0.5) +
  labs(title = "Density Plot of Total Spend", x = "Total Spend", y = "Density") +
  theme_minimal()

# 3. compute summary statistics
# Summary statistics (with outliers)
summary_with_outliers <- summary(combined_data$TOT_SPEND)
print("Summary (with outliers):")
print(summary_with_outliers)

# Remove outliers
no_outliers <- combined_data[!combined_data$TOT_SPEND %in% outliers, ]

# Summary statistics (without outliers)
summary_without_outliers <- summary(no_outliers$TOT_SPEND)
print("Summary (without outliers):")
print(summary_without_outliers)

# 4. transform the combined_data
# Log transformation (add small constant to avoid log(0))
combined_data$LogTOT_SPEND <- log1p(combined_data$TOT_SPEND)

# Visualize log-transformed data
ggplot(combined_data, aes(x = LogTOT_SPEND)) +
  geom_histogram(binwidth = 0.5, fill = "seagreen", color = "black", alpha = 0.7) +
  labs(title = "Histogram of Log-Transformed Total Spend", x = "Log(Total Spend)", y = "Frequency") +
  theme_minimal()

# Compare original vs transformed density
ggplot(combined_data, aes(x = TOT_SPEND)) +
  geom_density(fill = "blue", alpha = 0.5) +
  geom_density(aes(x = exp(LogTOT_SPEND)), fill = "red", alpha = 0.5) +
  labs(title = "Density Plot: Original vs Log-Transformed", x = "Total Spend", y = "Density") +
  theme_minimal()

# 5. segment high-value accounts
# Define a threshold for high spenders (e.g., top 5% quantile)
# Calculate the 95th percentile threshold, ignoring missing values
threshold <- quantile(combined_data$TOT_SPEND, 0.95, na.rm = TRUE)


# Create a new column to flag high-value accounts
combined_data$HighSpender <- ifelse(combined_data$TOT_SPEND >= threshold, "High", "Normal")


# Summarize high-value accounts
high_spenders <- combined_data[combined_data$HighSpender == "High", ]
print("High Spenders:")
print(high_spenders)

# Count and visualize segmentation
ggplot(combined_data, aes(x = HighSpender)) +
  geom_bar(fill = "orange", alpha = 0.7) +
  labs(title = "Segmentation of Accounts", x = "Account Type", y = "Count") +
  theme_minimal()



