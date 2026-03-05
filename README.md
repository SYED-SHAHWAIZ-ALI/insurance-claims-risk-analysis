# Insurance-claims-risk-analysis
End-to-end SQL and Spreadsheet pipeline for cleaning and risk-modeling 22,000+ insurance records to identify portfolio loss-ratios


# Insurance Portfolio Risk & Profitability Analysis

End-to-end data analysis project evaluating insurance portfolio performance using SQL and spreadsheet-based ETL on **22,090+ insurance records**.


## Executive Summary
Analyzed a dataset of **22,090 insurance records** with 104 attributes to evaluate portfolio health.  
The analysis transformed raw, unstructured operational data into a structured format to identify **revenue concentration, portfolio risk exposure, and operational inefficiencies**.

Key objective was to provide actionable insights to help management understand profitability drivers and potential risk areas within the insurance portfolio.



## Technology Stack
- **SQL** – Data transformation, aggregation, and risk modeling
- **Spreadsheets (Excel / Google Sheets)** – Initial ETL and data cleaning
- **Documentation** – Project report summarizing analysis and insights



## Business Problem
The insurance company maintained a large dataset across multiple branches with limited analytical visibility into:

1. Which farms generate the highest premium revenue
2. Which farms or branches carry the highest claims risk
3. Data integrity issues such as inconsistent tag numbers and missing insured values

The goal was to clean the dataset and produce insights that support better portfolio management decisions.



## Data Engineering Pipeline

### Data Cleaning
- Standardized `Tag Number` formats using SQL logic
- Handled missing values in **Sum Insured**
- Removed **40+ redundant columns** to optimize analysis
- Structured raw operational data into analysis-ready format

### Risk Modeling
Implemented SQL calculations to evaluate portfolio performance:

- **Premium Calculation**
  Applied a standard **3% premium rate** on `Sum Insured`

- **Claims-to-Premium Ratio**
  Identified farms where:
claim > premium

- **Year-over-Year Analysis**
  Compared portfolio performance between **2024 and 2025**


## Key Insights

**Revenue Concentration**
- Top **5 farms generate 68% of total premium income**

**Portfolio Efficiency**
- Identified the most efficient farm based on **lowest claims-to-premium ratio**

These insights highlight concentration risk and help identify high-performing and high-risk portfolio segments.


## Project Structure
insurance-claims-risk-analysis
│
├── data
│   └── insurance_raw_sample_100_rows.csv
│
├── scripts
│
├── docs
│   └── insurance-claims-risk-analysis-report.pdf
│
└── README.md




## Project Report

📄 **Full project documentation and analysis report**

[View Report](docs/insurance-claims-risk-analysis-report.pdf)



## Author
**Syed Shahwaiz Ali**

Data Analyst | SQL | Data Analytics | Risk Modeling
