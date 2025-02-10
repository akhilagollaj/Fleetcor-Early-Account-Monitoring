library(dplyr)
library(readxl)
library(ggplot2)
library(lubridate)


# Define the file path and sheet names
file_path <- "/Users/akhilagolla/Desktop/DBMS/GROUP 3 PROJECT/Fleetcor Project 1_Dataset/Non Cross-Sell DNB Score.xlsx"
sheet_names <- c("22Q4", "23Q1", "23Q2", "23Q3", "23Q4")

# Initialize an empty list to store the data from each sheet
dnb_data_list <- list()

# Loop through the sheet names and load data from each sheet
for (sheet in sheet_names) {
  # Read each sheet and store it in the list
  dnb_data_list[[sheet]] <- read_excel(file_path, sheet = sheet)
}

# Combine all sheets into a single data frame
dnb_score <- do.call(rbind, dnb_data_list)

# View the structure of the combined data
str(dnb_score)

# Display the first few rows
head(dnb_score)

# Load the Excel files
# dnb_score <- read_excel("/Users/akhilagolla/Desktop/DBMS/GROUP 3 PROJECT/Fleetcor Project 1_Dataset/Non Cross-Sell DNB Score.xlsx")
vantage_score <- read_excel("/Users/akhilagolla/Desktop/DBMS/GROUP 3 PROJECT/Fleetcor Project 1_Dataset/Non Cross-Sell Vantage Score.xlsx")
nsf_payment <- read_excel("/Users/akhilagolla/Desktop/DBMS/GROUP 3 PROJECT/Fleetcor Project 1_Dataset/Non Cross-Sell NSF Payment.xlsx")
payment_data <- read_excel("/Users/akhilagolla/Desktop/DBMS/GROUP 3 PROJECT/Fleetcor Project 1_Dataset/Non Cross-Sell Payment.xlsx")
write_off_data <- read_excel("/Users/akhilagolla/Desktop/DBMS/GROUP 3 PROJECT/Fleetcor Project 1_Dataset/Non Cross-Sell Write-Off.xlsx")

# View the first few rows of each dataset to understand its structure
head(dnb_score)
head(vantage_score)
head(nsf_payment)
head(payment_data)
head(write_off_data)

# Handle missing values (replace NA with 0 or remove rows with NA)
dnb_score <- dnb_score %>% mutate_all(~replace(., is.na(.), 0))
vantage_score <- vantage_score %>% mutate_all(~replace(., is.na(.), 0))

colSums(is.na(dnb_score))
colSums(is.na(vantage_score))
colSums(is.na(nsf_payment))
colSums(is.na(payment_data))
colSums(is.na(write_off_data))

# Merge datasets using fake_acctcode
combined_data <- dnb_score %>%
  left_join(vantage_score, by = "FAKE_ACCTCODE") %>%
  left_join(nsf_payment, by = "FAKE_ACCTCODE") %>%
  left_join(payment_data, by = "FAKE_ACCTCODE") %>%
  left_join(write_off_data, by = "FAKE_ACCTCODE")

# Check the structure of the merged data
head(combined_data)

# Now that the data is merged, evaluate key risk factors:
# 1. Credit Scores (DNB and Vantage)
# Summary statistics for DNB and Vantage scores
summary(combined_data$CCS_GRADE)   # DNB Score
summary(combined_data$VANTAGE_SCORE)   # Vantage Score

# Visualize the distribution of credit scores
ggplot(combined_data, aes(x = CCS_GRADE)) +
  geom_bar(fill = "seagreen", color = "black", alpha = 0.7) +
  labs(title = "Distribution of DNB Scores", x = "DNB Score Grades", y = "Count")

ggplot(combined_data, aes(x = VANTAGE_SCORE)) +
  geom_histogram(binwidth = 10, fill = "red", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Vantage Scores", x = "Vantage Score", y = "Count") +
  theme_minimal()




# Create bins and summarize data
binned_data <- combined_data %>%
  mutate(score_bin = cut(VANTAGE_SCORE, breaks = seq(300, 850, by = 10))) %>%
  group_by(score_bin) %>%
  summarise(count = n())

# Plot aggregated data
ggplot(binned_data, aes(x = score_bin, y = count)) +
  geom_bar(stat = "identity", fill = "red", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Vantage Scores (Binned)", x = "Vantage Score Bins", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))






# 2. NSF Payments
# NSF payments are a key indicator of risk. Let’s examine NSF amounts and the frequency of NSF payments.
# Summary of NSF payments and amounts
summary(combined_data$NSF_AMOUNT)
summary(combined_data$NSF_PMTS)

# Visualize NSF payment behavior
ggplot(combined_data, aes(x = NSF_AMOUNT)) +
  geom_histogram(binwidth = 10, fill = "orange", color = "black", alpha = 0.7) +
  labs(title = "Distribution of NSF Amounts")

ggplot(combined_data, aes(x = NSF_PMTS)) +
  geom_histogram(binwidth = 1, fill = "purple", color = "black", alpha = 0.7) +
  labs(title = "Number of NSF Payments")


# 3. Payment Behavior
# Examine the overall payment amount and the number of payments made.
# Summary of payment behavior
summary(combined_data$PAYMENT_AMOUNT)
summary(combined_data$NO_OF_PAYMENT)

# Visualize payment amount distribution
ggplot(combined_data, aes(x = PAYMENT_AMOUNT)) +
  geom_histogram(binwidth = 1000, fill = "green", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Payment Amounts")

# Visualize the number of payments made
ggplot(combined_data, aes(x = NO_OF_PAYMENT)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Number of Payments")

# 4. Write-Off History
# Look at the customers with a history of write-offs.
# Summary of write-off amounts
summary(combined_data$WO_AMOUNT)

# Visualize write-off history
ggplot(combined_data, aes(x = WO_AMOUNT)) +
  geom_histogram(binwidth = 500, fill = "red", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Write-Off Amounts")


# Combine Risk Indicators to Assess Overall Risk
# You can create a composite risk score or use individual indicators to classify customers as high or low risk.
# Define a risk threshold for key indicators (e.g., Vantage score < 650 is high risk, NSF payments > 2 is high risk)
combined_data$risk_score <- with(combined_data, 
                                 ifelse(VANTAGE_SCORE < 650 | NSF_PMTS > 2 | WO_AMOUNT > 1000, "High", "Low")
)

# Check the distribution of risk
table(combined_data$risk_score)

# Summary Report
# After conducting the analysis, summarize the findings:
# High-Risk Customers: Customers with low credit scores (DNB or Vantage), high NSF payments, and previous write-offs.
# Low-Risk Customers: Customers with high credit scores, low NSF payments, and no history of write-offs.




