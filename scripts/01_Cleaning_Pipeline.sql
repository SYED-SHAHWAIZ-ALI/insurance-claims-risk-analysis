/*
File Name: 01_Cleaning_Pipeline.sql
Project: Insurance Portfolio Risk & Profitability Analysis
Author: Syed Shahwaiz Ali
Role: Data Engineering / Data Analysis
Created: 2026
Database: SQL Server (T-SQL)

Description:
This script performs the initial data cleaning and transformation of the
raw farm insurance dataset. The goal is to standardize tag numbers, handle
missing values, and prepare the dataset for downstream analysis and risk
modeling.

Key Cleaning Steps:
- Standardize tag number fields using COALESCE across retag and replacement columns
- Handle missing sale dates using LAG() fallback logic
- Replace null claim values with zero
- Calculate premium as 3% of Sum Insured
- Generate gross profit per animal (Premium - Claim Amount)
- Filter invalid rows (missing tags or zero premium)

Output:
Produces a cleaned dataset ready for exploratory analysis and risk modeling.

Dataset:
dbo.farm_insurance_data

Pipeline Order: 01_Cleaning → 02_Analysis → 03_Risk_Modeling

Related Scripts:
02_Exploratory_Analysis.sql
03_Risk_Modeling.sql
*/
/* 
Step 1: Prepare raw data for cleaning
- Handle missing sale dates using LAG() as fallback
- Convert tag-related columns to text for standardization
- Keep required columns for downstream analysis
*/
WITH cleaning_datatype AS ( 
    SELECT
        b.REPORTING_UNIT,
        b.FARM_NAME,
        COALESCE(Retagging_Date1, Replaced_Tag_Number1, Tag_Number1) AS Final_Tag_Number,
        0.03 * b.Sum_Insured_Dated17 AS Premium,
        b.Sum_Insured_Dated17,
        COALESCE(sale_date, fallback_sale_date, '2025-01-01') AS Sale_Date,
        COALESCE(MONTH(sale_date), MONTH(fallback_sale_date), 1) AS sale_month,
        COALESCE(b.Net_Payment, 0) AS Claim_amount
    FROM (
        SELECT
            *,
            LAG(Sale_Date) OVER (ORDER BY Sale_Date) AS fallback_sale_date,
            CAST(Retagging_Date AS NVARCHAR) AS Retagging_Date1,
            CAST(Replaced_Tag_Number AS NVARCHAR) AS Replaced_Tag_Number1,
            CAST(Tag_Number AS NVARCHAR) AS Tag_Number1
        FROM dbo.farm_insurance_data
    ) AS b
)

/* 
Step 2: Generate final cleaned output
- Calculate gross profit per animal
- Remove rows with missing final tag number
- Keep only records with positive premium
*/
SELECT
    *,
    Premium - Claim_amount AS Gross_profit_per_animal
FROM cleaning_datatype
WHERE Final_Tag_Number IS NOT NULL
  AND Premium > 0

/* 
Step 3: Sort results
- First by highest premium
- If premium ties occur, sort by the alphanumeric tag number component
*/
ORDER BY 
    Premium DESC,
    REPLACE(
        Final_Tag_Number,
        REPLACE(
            TRANSLATE(Final_Tag_Number, '-0123456789', '###########'),
            '#',
            ''
        ),
        ''
    );
