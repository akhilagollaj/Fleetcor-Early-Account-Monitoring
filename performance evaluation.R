library(dplyr)
library(readxl)
library(ggplot2)

setwd("/Users/akhilagolla/Desktop/DBMS/GROUP 3 PROJECT/Fleetcor Project 1_Dataset")
# Load data
cross_sell <- read_excel("Cross_sell_data.xlsx")
cross_sell_revenue <- read_excel("Cross-Sell Acct.xlsx", sheet = "X-sell Revenue")
cross_sell_write_offs <- read_excel("Cross-Sell Acct.xlsx", sheet = "X-sell WO")

non_cross_sell_info <- read_excel("Non Cross-Sell Acct Info.xlsx")
segment_scores <- read_excel("All Acct Segment Score.xlsx")
write_offs <- read_excel("Non Cross-Sell Write-Off.xlsx")
revenue <- read_excel("Non Cross-Sell Revenue.xlsx")
spend <- read_excel("Non Cross-Sell Spend.xlsx")


colSums(is.na(cross_sell))
colSums(is.na(cross_sell_revenue))
colSums(is.na(cross_sell_write_offs))
colSums(is.na(non_cross_sell_info))
colSums(is.na(segment_scores))
colSums(is.na(revenue))
colSums(is.na(spend))

#  Replace NA with 0
cross_sell <- cross_sell %>% mutate_all(~replace(., is.na(.), 0))
cross_sell_revenue <- cross_sell_revenue %>% mutate_all(~replace(., is.na(.), 0))
cross_sell_write_offs <- cross_sell_write_offs %>% mutate_all(~replace(., is.na(.), 0))
non_cross_sell_info <- non_cross_sell_info %>% mutate_all(~replace(., is.na(.), 0))
segment_scores <- segment_scores %>% mutate_all(~replace(., is.na(.), 0))
revenue <- revenue %>% mutate_all(~replace(., is.na(.), 0))
spend <- spend %>% mutate_all(~replace(., is.na(.), 0))

# Merge Cross-Sell data with segment scores
cross_sell_full <- cross_sell %>%
  left_join(segment_scores, by = "FAKE_ACCTCODE")%>%
  left_join(cross_sell_revenue, by = "FAKE_ACCTCODE")%>%
  left_join(cross_sell_write_offs, by = "FAKE_ACCTCODE")

# Merge Non Cross-Sell data
non_cross_sell_full <- non_cross_sell_info %>%
  left_join(segment_scores, by = "FAKE_ACCTCODE") %>%
  left_join(revenue, by = "FAKE_ACCTCODE") %>%
  left_join(spend, by = "FAKE_ACCTCODE") %>%
  left_join(write_offs, by = "FAKE_ACCTCODE")

cross_sell_full$WO_AMOUNT[is.na(cross_sell_full$WO_AMOUNT)] <- 0
non_cross_sell_full$WO_AMOUNT[is.na(non_cross_sell_full$WO_AMOUNT)] <- 0

cross_sell_full$TOT_SPEND[is.na(cross_sell_full$TOT_SPEND)] <- 0
non_cross_sell_full$TOT_SPEND[is.na(non_cross_sell_full$TOT_SPEND)] <- 0

cross_sell_full$TOT_NET_REV[is.na(cross_sell_full$TOT_NET_REV)] <- 0
non_cross_sell_full$TOT_NET_REV[is.na(non_cross_sell_full$TOT_NET_REV)] <- 0

# Calculate metrics for Cross-Sell customers
cross_sell_metrics <- cross_sell_full %>%
  summarise(
    Total_Spend = sum(TOT_SPEND, na.rm = TRUE),
    Total_Revenue = sum(TOT_NET_REV, na.rm = TRUE),
    Total_WriteOffs = sum(WO_AMOUNT, na.rm = TRUE)
  )

print(cross_sell_metrics)

# Calculate metrics for Non Cross-Sell customers
non_cross_sell_metrics <- non_cross_sell_full %>%
  summarise(
    Total_Spend = sum(TOT_SPEND, na.rm = TRUE),
    Total_Revenue = sum(TOT_NET_REV, na.rm = TRUE),
    Total_WriteOffs = sum(WO_AMOUNT, na.rm = TRUE)
  )
print(non_cross_sell_metrics)

# Combine metrics
comparison <- data.frame(
  Category = c("Cross-Sell", "Non Cross-Sell"),
  Total_Spend = c(cross_sell_metrics$Total_Spend, non_cross_sell_metrics$Total_Spend),
  Total_Revenue = c(cross_sell_metrics$Total_Revenue, non_cross_sell_metrics$Total_Revenue),
  Total_WriteOffs = c(cross_sell_metrics$Total_WriteOffs, non_cross_sell_metrics$Total_WriteOffs)
)


print(comparison)


# Reshape data for visualization
library(tidyr)
library(ggplot2)

comparison_long <- comparison %>%
  pivot_longer(cols = c(Total_Spend, Total_Revenue, Total_WriteOffs),
               names_to = "Metric",
               values_to = "Value")

print(comparison_long)
options(scipen = 999)  # Turns off scientific notation

# Plot the metrics
ggplot(comparison_long, aes(x = Category, y = Value, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Cross-Sell vs Non Cross-Sell Performance",
       x = "Category", y = "Value", fill = "Metric") +
  theme_minimal()


ggplot(comparison_long, aes(x = Category, y = Value, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(trans = 'log10') +  # Log scale for y-axis
  labs(title = "Cross-Sell vs Non Cross-Sell Performance")
