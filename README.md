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

## Models and Tools Used
- **K-Means Clustering**: Used for customer segmentation based on financial metrics.
- **Linear Regression**: Modeled the relationship between payment amounts, total spend, and credit limits.
- **Threshold-Based Classification**: Categorized customers into high- or low-risk based on credit scores, NSF payments, and write-offs.
- **Log Transformation and Outlier Detection**: Normalized spending data and identified extreme spending behaviors.

## Repository Structure
- **Data**: Contains the datasets used for analysis.
- **Notebooks**: Jupyter notebooks with the code for data preprocessing, modeling, and visualization.
- **Reports**: Detailed reports and dashboards summarizing the findings.
- **Scripts**: R and Python scripts for data processing and model training.

## How to Use This Repository
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/fleetcor-project-3.git
   cd fleetcor-project-3
   ```
2. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
3. **Run the Notebooks**:
   - Open the Jupyter notebooks in the `Notebooks` directory to explore the data analysis and modeling steps.
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

For any questions or further information, please contact [your-email@example.com].
