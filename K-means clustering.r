# Load necessary libraries
library(dplyr)
library(readr)
library(cluster)
library(readxl)
library(ggplot2)
library(tidyr)

data <- read_excel("F:\\UNH\\BANL-6430-01 - DBMS\\SQL\\DBMS- Group Project\\Dataset.xlsx")

cols_to_update <- c("PAYMENT_AMOUNT", "NO_OF_PAYMENT", "CLI_AMOUNT")
data[cols_to_update] <- lapply(data[cols_to_update], function(x) { 
  x[is.na(x)] <- 0
  return(x)
})

# Select relevant features for clustering
clustering_data <- data %>%
  select(PAYMENT_AMOUNT, CURRENT_BALANCE, UNBILLED_BALANCE, BAL_1_30, BAL_31_60, BAL_61_90, BAL_90_PLUS) %>%
  na.omit()

str(data)

# Normalize the data
clustering_data_scaled <- scale(clustering_data)

# Determine the optimal number of clusters using the Elbow Method
wss <- (nrow(clustering_data_scaled) - 1) * sum(apply(clustering_data_scaled, 2, var))
for (i in 2:10) {
  wss[i] <- sum(kmeans(clustering_data_scaled, centers = i)$tot.withinss)
}
plot(1:10, wss, type = "b", xlab = "Number of Clusters", ylab = "Within Sum of Squares")

set.seed(123)  # For reproducibility
kmeans_result <- kmeans(clustering_data_scaled, centers = 3)  # Use the optimal number of clusters (e.g., 4)
# Add cluster labels to the original dataset
data$Cluster <- kmeans_result$cluster
pca_result <- prcomp(clustering_data_scaled)
pca_data <- data.frame(pca_result$x)
pca_data$Cluster <- as.factor(kmeans_result$cluster)

ggplot(pca_data, aes(PC1, PC2, color = Cluster)) + geom_point() + ggtitle("Cluster Distribution based on PCA")

# Load the factoextra library for visualization
library(factoextra)
# Visualize the clusters using only the rows used in clustering
fviz_cluster(kmeans_result, data = clustering_data_scaled, geom = "point", stand = FALSE, ellipse = TRUE) +
  ggtitle("Customer Segmentation")

data_long <- data %>%
  select(Cluster, PAYMENT_AMOUNT, CURRENT_BALANCE) %>%  # Add other features as needed
  pivot_longer(
    cols = c(PAYMENT_AMOUNT, CURRENT_BALANCE),  # Features to reshape
    names_to = "Feature",  # Column for feature names
    values_to = "Value"    # Column for feature values
  )

# Apply log transformation first
data_long$Value <- log1p(data_long$Value)
# Then standardize the log-transformed data
data_long$Value <- scale(data_long$Value)

# Plot the transformed and standardized data
ggplot(data_long, aes(x = Cluster, y = Value, fill = Feature)) +
  geom_boxplot(outlier.size = 3, outlier.colour = "red") +
  facet_wrap(~ Feature, scales = "free_y") +  # Facets to separate the features
  labs(title = "Boxplot of PAYMENT_AMOUNT and CURRENT_BALANCE by Cluster", 
       x = "Cluster", 
       y = "Log-transformed and Standardized Value") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

kmeans_result <- kmeans(clustering_data_scaled, centers = 3)
data$cluster <- kmeans_result$cluster
str(data)

# Assign risk scores based on cluster labels
data$risk_score <- ifelse(data$cluster == 1, 3,  # High Risk
                          ifelse(data$cluster == 2, 2,  # Moderate Risk
                                 1))  # Safe

head(data)

write.csv(data, "F:\\UNH\\BANL-6430-01 - DBMS\\SQL\\DBMS- Group Project\\Clustered_Data.csv", row.names = FALSE)
