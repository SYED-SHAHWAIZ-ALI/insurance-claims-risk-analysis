# Insurance Portfolio Risk & Profitability Analysis
End-to-end SQL and spreadsheet pipeline for cleaning and analyzing **22,000+ insurance records** to evaluate portfolio risk, profitability, and revenue concentration.


## Executive Summary
Analyzed a dataset of **22,090 insurance records** with 104 attributes to evaluate portfolio health.  
The analysis transformed raw operational insurance data into a structured analytical dataset **revenue concentration, portfolio risk exposure, and operational inefficiencies**.

Key objective was to provide actionable insights to help management understand profitability drivers and potential risk areas within the insurance portfolio.




## Technology Stack
- **SQL** – Data transformation, aggregation, and portfolio risk modeling
- **Spreadsheets (Excel / Google Sheets)** – Preliminary data exploration and early ETL
- **Documentation** – Project report summarizing analysis and insights




## Project Workflow

The project follows a structured data analytics pipeline:

Raw Operational Data  
→ Data Cleaning & Standardization  
→ Exploratory Portfolio Analysis  
→ Risk Modeling & Performance Metrics  
→ Business Insights & Documentation

This workflow mirrors a typical **analytics pipeline used in production environments**, where raw operational data is transformed into decision-support insights.




## Business Problem
The insurance company maintained a large dataset across multiple branches with limited analytical visibility into portfolio performance:

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
  Identified farms where `Claim Amount > Premium`

- **Year-over-Year Analysis**
  Compared portfolio performance between **2024 and 2025**




## Key Insights

### Portfolio Overview
- The portfolio contains **22,088 insured animals** across **10 farms**.
- Total insured exposure exceeds **278M**, highlighting substantial financial liability.
- Total premium income is approximately **8.35M**, while total claims exceed **298M**.
- The portfolio-level **loss ratio is 35.72**, indicating that claims are far higher than premium income.

### Farm-Level Risk & Profitability
- Financial performance varies significantly across farms, with some generating strong premium income while others contribute disproportionately to claims.
- **Hi Cattle Farm** is one of the highest premium-generating farms in the portfolio.
- **SK Oasis Feedlot Farms** shows one of the highest farm-level loss ratios, indicating elevated risk exposure.
- **Organic Farm** demonstrates comparatively stronger profitability and lower loss pressure than several other farms.

### Revenue Concentration
- Premium revenue is highly concentrated across a small number of farms.
- The **top 3 farms contribute 48.95%** of total premium income.
- The **top 5 farms contribute 67.95%** of total premium income.
- The **top 7 farms contribute 85.21%** of total premium income.
- This indicates strong dependency risk, where the portfolio relies heavily on a limited number of farms for revenue generation.
  



## Business Value

This analysis provides several operational and financial insights:

- Highlights **revenue concentration risk**, where a large share of premium income depends on a small number of farms.
- Identifies **high-claim farms** that may require underwriting review.
- Improves **data quality visibility** by identifying missing values and inconsistent identifiers.
- Provides a **structured portfolio view** that supports risk management and pricing decisions.

These insights help insurance managers better understand portfolio exposure and improve decision-making.




## Project Structure

```
insurance-claims-risk-analysis
│
├── data
│   ├── insurance_raw_sample_100_rows.csv
│   └── insurance_clean_sample_100_rows.csv
│
├── scripts
│   ├── 01_Cleaning_Pipeline.sql
│   ├── 02_Exploratory_Portfolio_Analysis.sql
│   └── 03_Risk_Modeling.sql
│
├── docs
│   └── insurance-claims-risk-analysis-report.pdf
│
├── README.md
└── LICENSE
```
### Scripts Overview

- **01_Cleaning_Pipeline.sql** – Data cleaning, tag standardization, missing value handling, premium calculation.
- **02_Exploratory_Portfolio_Analysis.sql** – Initial data exploration and summary metrics.
- **03_Risk_Modeling.sql** – Profitability and claims-to-premium risk analysis.




## Exploratory Portfolio Analysis

The exploratory analysis stage was implemented in **`02_Exploratory_Portfolio_Analysis.sql`** to understand portfolio structure, revenue distribution, and farm-level performance.

The analysis was structured around five core SQL investigations:

1. **Portfolio Summary**
   - Measured total animals, farms, total insured value, premium income, total claims, and portfolio-level loss ratio.

2. **Farm-Level Performance Analysis**
   - Compared premium, claims, loss ratio, and net profitability across farms.

3. **Premium Share by Farm**
   - Calculated each farm’s contribution to total premium revenue.

4. **Top 5 Revenue Contribution**
   - Measured how much of the portfolio’s premium income comes from the top five farms.

5. **Cumulative Premium Concentration**
   - Evaluated how revenue accumulates across farms to identify dependency concentration and concentration risk.




## Project Documentation

📄 **Portfolio Analysis Report**

A supporting project report developed during the early exploratory stage of the analysis using spreadsheet-based ETL and preliminary portfolio evaluation.

The report documents:
- Initial dataset exploration
- Early portfolio observations
- Preliminary business insights prior to the SQL-based analytical pipeline

The final insights and validated metrics presented in this repository were produced through the **SQL data pipeline and analytical queries included in the `scripts` directory**.

[View Portfolio Analysis Report](docs/insurance-claims-risk-analysis-report.pdf)




## How to Run the Project

1. Import the raw dataset into SQL Server.
2. Run the cleaning pipeline:
   `scripts/01_Cleaning_Pipeline.sql`
3. Run exploratory analysis:
   `scripts/02_Exploratory_Portfolio_Analysis.sql`
4. Run risk modeling queries:
   `scripts/03_Risk_Modeling.sql`




## Dataset

A sample of the raw dataset (100 rows) used in the analysis is available below.

📊 **Download Sample Dataset**

[insurance_raw_sample_100_rows.csv](data/insurance_raw_sample_100_rows.csv)




## Author
**Syed Shahwaiz Ali**

Data Analyst | SQL | Data Analytics | Risk Analysis | Portfolio Analytics | Data Cleaning
