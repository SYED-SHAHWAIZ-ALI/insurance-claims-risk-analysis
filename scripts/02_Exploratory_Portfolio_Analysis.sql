/*
File Name: 02_Exploratory_Portfolio_Analysis.sql
Project: Insurance Portfolio Risk & Profitability Analysis
Author: Syed Shahwaiz Ali
Role: SQL Data Analyst
Created: 2026
Database: SQL Server (T-SQL)

Description:
This script performs exploratory analysis on the cleaned insurance dataset
to understand portfolio structure, revenue distribution, and farm-level
performance.

The goal of this analysis is to identify revenue concentration, risk
exposure, and profitability differences across farms.

Dataset Used:
dbo.MasterDataCleaned

Analysis Sections:
1. Portfolio Summary
2. Farm-Level Performance Analysis
3. Premium Share by Farm
4. Top 5 Revenue Contribution
5. Cumulative Premium Concentration
*/
/*
-----------------------------------------------------------
1. Portfolio Summary
-----------------------------------------------------------
Purpose:
Provides an overview of the entire insurance portfolio
including exposure, premium income, and claim levels.
*/

SELECT 
    COUNT(*) AS Total_animals,
    COUNT(DISTINCT FARM_NAME) AS Total_farms,
    SUM(CAST(Sum_Insured_Dated17 AS DECIMAL(18,2))) AS Total_Sum_Insured,
    SUM(CAST(Premium AS DECIMAL(18,2))) AS Total_Premium,
    SUM(CAST(Claim_amount AS DECIMAL(18,2))) AS Total_Claim,
    AVG(CAST(Sum_Insured_Dated17 AS DECIMAL(18,2))) AS Avg_Sum_Insured,
    AVG(CAST(Premium AS DECIMAL(18,2))) AS Avg_Premium,
    AVG(CAST(Claim_amount AS DECIMAL(18,2))) AS Avg_Claim,
    CAST(SUM(CAST(Claim_amount AS FLOAT)) / NULLIF(SUM(CAST(Premium AS FLOAT)), 0)AS DECIMAL(18,2) ) AS Loss_Ratio
FROM dbo.MasterDataCleaned;




/*
-----------------------------------------------------------
2. Farm-Level Performance Analysis
-----------------------------------------------------------
Purpose:
Evaluates financial performance and risk exposure across farms.
*/

SELECT FARM_NAME ,
       SUM(Premium) AS Premium_per_Farm,
       SUM(Claim_amount) As Claim_per_Farm,
       (SUM(Claim_amount)/NULLIF(SUM(Premium),0 )) AS Loss_Ratio_per_Farm,
       SUM(Premium) - SUM(Claim_amount) AS Net_Profit_or_Loss
FROM dbo.MasterDataCleaned
GROUP BY FARM_NAME;




/*
-----------------------------------------------------------
3. Premium Share by Farm
-----------------------------------------------------------
Purpose:
Calculates each farm's contribution to total portfolio revenue.
*/

SELECT FARM_NAME,
       SUM(Premium) AS Total_Premium,
       CAST( (SUM(Premium)/(SELECT SUM(Premium)
                     FROM dbo.MasterDataCleaned))*100.0 AS DECIMAL(18,2)) AS  Premium_Share_Percent
FROM dbo.MasterDataCleaned
GROUP BY FARM_NAME
ORDER BY Premium_share_percent DESC;




/*
-----------------------------------------------------------
4. Top 5 Revenue Contribution
-----------------------------------------------------------
Purpose:
Measures how much of the portfolio revenue is generated
by the top 5 farms.
*/

WITH farm_premium AS (
  SELECT FARM_NAME,
         SUM(Premium) AS Total_Premium,
         CAST( (SUM(Premium)/(SELECT SUM(Premium)
                     FROM dbo.MasterDataCleaned))*100.0 AS DECIMAL(18,2)) AS  Premium_Share_Percent
  FROM dbo.MasterDataCleaned
  GROUP BY FARM_NAME),
ranked_farm AS (
   SELECT *,ROW_NUMBER() OVER (ORDER BY Total_Premium DESC) AS rn
   FROM farm_premium
)
SELECT (SELECT SUM(Premium) FROM dbo.MasterDataCleaned) AS Portfolio_Total_Premium,
       SUM(Total_Premium) AS Top_5_Premium,
       SUM(Premium_Share_Percent) AS Top_5_Premium_Share_Percent
FROM ranked_farm
WHERE rn<=5;




/*
-----------------------------------------------------------
5. Cumulative Premium Concentration
-----------------------------------------------------------
Purpose:
Analyzes how premium revenue accumulates across farms
to identify portfolio dependency risk.
*/
 WITH farm_premium AS (SELECT FARM_NAME,
      SUM(Premium) AS Total_Premium,
      CAST( (SUM(Premium)/(SELECT SUM(Premium)
                     FROM dbo.MasterDataCleaned))*100.0 AS DECIMAL(18,2)) AS  Premium_Share_Percent
FROM dbo.MasterDataCleaned
GROUP BY FARM_NAME)
SELECT *,SUM(Premium_share_Percent) OVER(ORDER BY Total_Premium DESC) AS Cumulative_Premium_Share_Percent
FROM farm_premium
ORDER BY Total_Premium DESC;
