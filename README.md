# Fleetcor Project-3: Cross-Sell Early Account Monitoring

## Overview
This repository contains the analysis and models developed for Fleetcor's Cross-Sell Early Account Monitoring project. The primary goal of this project is to evaluate the financial performance and risks associated with customers transitioning from Fuel-Only Cards to Universal Cards under the Cross-Sell Program. The analysis aims to identify transaction patterns, key risk indicators, and performance metrics to predict financial distress and evaluate the potential for future cross-sell opportunities.

## Project Goals
1. **Performance and Transaction Patterns**: Analyze the financial behaviors of customers transitioning to Universal Cards and identify clusters of customers based on their financial performance.
2. **Risk Indicators and Metrics**: Evaluate key risk factors such as credit scores, NSF payments, and write-offs to predict financial distress.
3. **Future Cross-Sell Targeting**: Identify high-value customers and develop strategies to boost their spending and revenue while managing risks.

## Key Insights
- **Customer Segmentation**: Customers were segmented into three clusters using K-Means clustering:
  - **Cluster 1**: Indicates financial distress with high risks of delinquency.
  - **Cluster 2**: Demonstrates growth potential.
  - **Cluster 3**: Reflects stable financial behaviors.
- **Risk Assessment**: High-risk customers were identified based on Vantage Scores (< 650), NSF payments (> 2), and write-offs (> $1,000).
- **Performance Evaluation**: Non-Cross-Sell customers contribute significantly higher revenues but exhibit higher risks in terms of write-offs and delinquency compared to Cross-Sell customers.

## Data Cleaning Process
The data cleaning process was a critical step to ensure the accuracy and reliability of the analysis. Below are the key steps taken to clean and prepare the data:

1. **Handling Missing Values**:
   - Missing values in key financial features (e.g., `PAYMENT_AMOUNT`, `CURRENT_BALANCE`, `UNBILLED_BALANCE`, aging balances) were replaced with `0` to ensure no gaps in the data during analysis.
   - For datasets like Non Cross-Sell Spend and Non Cross-Sell Payment, missing values were handled by replacing all `NA` values with `0`.

2. **Data Integration**:
   - Datasets from multiple sources (e.g., Non Cross-Sell Spend, Non Cross-Sell Payment, credit scores, NSF payments, write-offs) were merged using common keys like `FAKE_ACCTCODE` and `YEARMONTH`.
   - This ensured that all relevant financial and behavioral data was available for each customer.

3. **Standardization**:
   - Financial features were standardized to ensure comparability across variables. This was particularly important for K-Means clustering, as the algorithm is sensitive to the scale of features.

4. **Outlier Detection and Handling**:
   - Outliers in `Total Spend` and other financial metrics were identified using boxplots and the `boxplot.stats` function.
   - Extreme values were addressed using log transformation to normalize the data and reduce skewness.

5. **Feature Engineering**:
   - New features were created to support the analysis, such as:
     - **Risk Score**: Customers were categorized as "High Risk" or "Low Risk" based on thresholds for Vantage Scores (< 650), NSF payments (> 2), and write-offs (> $1,000).
     - **High-Value Accounts**: Accounts with `Total Spend` above the 95th percentile were segmented as "High" spenders.

6. **Data Validation**:
   - After cleaning and preprocessing, the data was validated to ensure consistency and completeness.
   - Missing values in critical columns (e.g., `Spend`, `Revenue`, `Write-Offs`) were checked and replaced with `0` before aggregation.

## Models and Tools Used
- **K-Means Clustering**: Used for customer segmentation based on financial metrics.
- **Linear Regression**: Modeled the relationship between payment amounts, total spend, and credit limits.
- **Threshold-Based Classification**: Categorized customers into high- or low-risk based on credit scores, NSF payments, and write-offs.
- **Log Transformation and Outlier Detection**: Normalized spending data and identified extreme spending behaviors.

## Dashboard Insights  
### **Power BI Visuals**  
The dashboards prepared for this analysis serve as powerful tools for visualizing and interpreting the model’s results. Below are the key features and insights provided by the dashboards:

### **Risk Score Distribution and Influencers**
- **Pie Chart**: Customers are categorized into **Safe**, **Medium Risk**, and **High Risk** segments, enabling quick identification of high-priority cases.
- **Key Influencers**: Factors such as high-risk levels, low credit scores, and frequent NSF payments are displayed, helping the company understand what drives risk scores.

### **Delinquency Metrics and Conversion Rates**
- **Bar Charts**: Delinquency balances are detailed across different lock types and reasons, highlighting areas requiring intervention.
- **Conversion Rates**: The impact of the Cross-Sell program is quantified by showing conversion rates from Non-Cross-Sell to Cross-Sell customers, demonstrating improvements in financial behavior.

### **Financial Performance Over Time**
- **Line Charts**: Trends in key financial metrics such as **Total Spend**, **Payment Amounts**, and **Credit Balances** are tracked over time, providing a longitudinal view of customer performance.
- **Scatterplots and Histograms**: Pre- and post-transition behaviors are compared, offering data-driven insights into the efficacy of the Cross-Sell program.

### Visualizations Included
The repository includes pre-generated visualizations in the form of **PNG images** stored in the `Visualizations` folder. These include:
- **Pie Charts**: Risk score distribution.
- **Bar Charts**: Delinquency metrics and conversion rates.
- **Line Charts**: Financial performance trends.
- **Scatterplots and Histograms**: Behavioral comparisons.

- **Risk Indicators**: Identifies high-risk customers.

  ![dashboard2](https://github.com/user-attachments/assets/b27aecf2-f10b-400f-8da2-34f857bff36e)
  

- **Financial Performance Dashboard**: Compares pre- and post-cross-sell behaviors.  

  ![dashboard1](https://github.com/user-attachments/assets/42309909-0ec8-40bb-8d64-2fe2b53b6d12)


## R Files and Workflow
The analysis was conducted using R, and the repository includes the following R scripts:

1. **Data Cleaning**: The cleaned dataset is provided in the repository 
   - `Cross-Sell Early Account Monitoring.csv`: The cleaned dataset is provided in the repository
    
2. **Customer Segmentation**:
   - `kmeans_clustering.R`: Performs K-Means clustering to segment customers into three clusters based on financial metrics.

3. **Transaction Pattern Analysis**:
   - `transaction_pattern_analysis.R`: Analyzes transaction patterns using linear regression, log transformation, and quantile-based segmentation.

4. **Risk Assessment**:
   - `risk_assessment.R`: Classifies customers into high- or low-risk categories using threshold-based logic and visualizes risk distributions.

5. **Performance Evaluation**:
   - `performance_evaluation.R`: Calculates and compares aggregated performance metrics (e.g., Total Spend, Revenue, Write-Offs) for Cross-Sell and Non Cross-Sell customers.



## How to Use This Repository
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/fleetcor-project-3.git
   cd fleetcor-project-3
   ```
2. **Install Dependencies**:
   - Ensure R is installed on your system.
   - Install required R packages by running:
     ```R
     install.packages(c("dplyr", "ggplot2", "tidyverse", "caret", "cluster"))
     ```
3. **Run the R Scripts**:
   - Execute the R scripts in the `R_Scripts` directory in the following order:
     1. `k-means_clustering.R`
     2. `transaction_pattern_analysis.R`
     3. `risk_assessment.R`
     4. `performance_evaluation.R`
    
4. **Explore the Reports**:
   - Check the `Reports` directory for detailed insights and visualizations.

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments
- Fleetcor for providing the data and project context.
- The data science team for their contributions to the analysis and modeling.

---

For any questions or further information, please contact akhilagolla2622@gmail.com.
