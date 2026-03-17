/*
File Name: 03_Risk_Modeling.sql
Project: Insurance Portfolio Risk & Profitability Analysis
Author: Syed Shahwaiz Ali
Role: SQL Data Analyst
Created: 2026
Database: SQL Server (T-SQL)

Description:
This script performs portfolio-level and farm-level risk modeling on the
cleaned insurance dataset.

The purpose of this analysis is to identify:
- high-risk farms
- largest financial loss contributors
- least loss-making farms
- portfolio risk distribution
- high-value farms with critical exposure

Dataset Used:
dbo.MasterDataCleaned

Risk Modeling Sections:
1. Farm-Level Risk Classification
2. Largest Loss Contributors
3. Least Loss-Making Farms
4. Portfolio Risk Distribution
5. High-Value High-Risk Farms
*/

/*
-----------------------------------------------------------
1. Farm-Level Risk Classification
-----------------------------------------------------------
Business Question:
Which farms are the riskiest based on claims, premium income,
net profitability, and loss ratio?

Purpose:
This query evaluates each farm's overall financial position and
classifies its risk using the claims-to-premium ratio.
*/

SELECT
    FARM_NAME,
    SUM(Premium) AS Total_Premium,
    SUM(Claim_amount) AS Total_Claims,
    SUM(Premium) - SUM(Claim_amount) AS Net_Profit_or_Loss,
    CAST(
        SUM(Claim_amount) / NULLIF(SUM(Premium), 0)
        AS DECIMAL(18,2)
    ) AS Loss_Ratio,
    CASE
        WHEN SUM(Claim_amount) / NULLIF(SUM(Premium), 0) > 1 THEN 'High Risk'
        WHEN SUM(Claim_amount) / NULLIF(SUM(Premium), 0) BETWEEN 0.6 AND 1 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END AS Risk_Category
FROM dbo.MasterDataCleaned
GROUP BY FARM_NAME
ORDER BY Loss_Ratio DESC;

/*
-----------------------------------------------------------
2. Largest Loss Contributors
-----------------------------------------------------------
Business Question:
Which farms contribute the largest absolute financial losses
to the portfolio?

Purpose:
This query identifies the farms causing the greatest monetary
damage, helping prioritize underwriting or pricing review.
*/

SELECT
    FARM_NAME,
    SUM(Premium) AS Total_Premium,
    SUM(Claim_amount) AS Total_Claims,
    SUM(Claim_amount) - SUM(Premium) AS Total_Loss
FROM dbo.MasterDataCleaned
GROUP BY FARM_NAME
ORDER BY Total_Loss DESC;

/*
-----------------------------------------------------------
3. Least Loss-Making Farms
-----------------------------------------------------------
Business Question:
Which farms perform relatively better financially, even if the
portfolio is overall loss-making?

Purpose:
This query highlights farms with the smallest losses, which may
represent comparatively stronger portfolio segments.
*/

SELECT
    FARM_NAME,
    SUM(Premium) AS Total_Premium,
    SUM(Claim_amount) AS Total_Claims,
    SUM(Premium) - SUM(Claim_amount) AS Total_Profit
FROM dbo.MasterDataCleaned
GROUP BY FARM_NAME
ORDER BY Total_Profit DESC;

/*
-----------------------------------------------------------
4. Portfolio Risk Distribution
-----------------------------------------------------------
Business Question:
How many farms fall into each portfolio risk category?

Purpose:
This query summarizes the portfolio's risk composition using
loss-ratio-based classification.
*/

WITH farm_risk AS (
    SELECT
        FARM_NAME,
        SUM(Claim_amount) / NULLIF(SUM(Premium), 0) AS Loss_Ratio
    FROM dbo.MasterDataCleaned
    GROUP BY FARM_NAME
)
SELECT
    CASE
        WHEN Loss_Ratio > 1 THEN 'High Risk'
        WHEN Loss_Ratio BETWEEN 0.6 AND 1 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END AS Risk_Category,
    COUNT(*) AS Number_of_Farms
FROM farm_risk
GROUP BY
    CASE
        WHEN Loss_Ratio > 1 THEN 'High Risk'
        WHEN Loss_Ratio BETWEEN 0.6 AND 1 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END;

/*
-----------------------------------------------------------
5. High-Value High-Risk Farms
-----------------------------------------------------------
Business Question:
Which farms are both financially important and operationally risky?

Purpose:
This query combines revenue contribution and loss ratio to identify
farms that are critical to the portfolio but also highly dangerous
from a risk perspective.
*/

WITH farm_metrics AS (
    SELECT
        FARM_NAME,
        SUM(Premium) AS Total_Premium,
        SUM(Claim_amount) AS Total_Claims,
        SUM(Premium) - SUM(Claim_amount) AS Net_Profit_or_Loss,
        CAST(
            SUM(Claim_amount) / NULLIF(SUM(Premium), 0)
            AS DECIMAL(18,2)
        ) AS Loss_Ratio,
        CAST(
            SUM(Premium) * 100.0 / SUM(SUM(Premium)) OVER ()
            AS DECIMAL(18,2)
        ) AS Premium_Share_Percent
    FROM dbo.MasterDataCleaned
    GROUP BY FARM_NAME
)
SELECT
    FARM_NAME,
    Total_Premium,
    Total_Claims,
    Net_Profit_or_Loss,
    Loss_Ratio,
    Premium_Share_Percent,
    CASE
    WHEN Premium_Share_Percent >= 10 AND Loss_Ratio > 35 THEN 'Critical Exposure'
    WHEN Premium_Share_Percent >= 8 AND Loss_Ratio > 33 THEN 'High Exposure'
    ELSE 'Monitor'
END AS Exposure_Category
    /*
-----------------------------------------------------------
6. Composite Risk Scoring Model (Multi-Factor)
-----------------------------------------------------------
Business Question:
Which farms represent the highest overall portfolio risk when
considering loss severity, revenue contribution, and claim frequency?

Purpose:
This query builds a composite risk score using three dimensions:

- Loss Ratio (severity of losses)
- Premium Share (portfolio exposure)
- Claim Frequency (operational risk intensity)

This allows prioritization of farms based on total portfolio impact.
*/
    SELECT
        FARM_NAME,
        SUM(Premium) AS Total_Premium,
        SUM(Claim_amount) AS Total_Claims,
        SUM(Claim_amount) * 1.0 / NULLIF(SUM(Premium),0) AS Loss_Ratio,
        SUM(Premium) * 1.0 / SUM(SUM(Premium)) OVER () AS Premium_Share,
        COUNT(Claim_amount) * 1.0 / SUM(COUNT(Claim_amount)) OVER () AS Claim_Frequency_Share 
    FROM dbo.MasterDataCleaned
    GROUP BY FARM_NAME
), risk_metrics AS (
SELECT *,
    (
      CAST( ROUND( 0.5 * Loss_Ratio +
      0.3 * Premium_Share * 100 +
      0.2 * Claim_Frequency_Share * 100,2) AS DECIMAL(18,2))
    ) AS Risk_Score
FROM farm_metrics
)
SELECT *,DENSE_RANK() OVER(ORDER BY Risk_Score DESC) AS Ranking
FROM risk_metrics
ORDER BY Risk_Score DESC;
        ELSE 'Monitor'
    END AS Exposure_Category
FROM farm_metrics
ORDER BY Loss_Ratio DESC, Premium_Share_Percent DESC;

/*
-----------------------------------------------------------
7. Claim Severity Analysis
-----------------------------------------------------------
Business Question:
Which farms generate the highest average claim severity per animal,
and how does claim severity vary across the portfolio?

Purpose:
This query evaluates the average claim size to identify farms
exposed to high-severity (high-cost) losses.
*/

SELECT *,
    DENSE_RANK() OVER(ORDER BY Avg_Claim_Severity DESC) AS Severity_Rank
FROM (
    SELECT
        FARM_NAME,
        SUM(Claim_amount) AS Total_Claims,
        COUNT(Claim_amount) AS Total_Claims_Count,

        -- Average Claim Size (Severity)
        CAST(
            SUM(Claim_amount) * 1.0 / NULLIF(COUNT(Claim_amount), 0)
            AS DECIMAL(18,2)
        ) AS Avg_Claim_Severity

    FROM dbo.MasterDataCleaned
    GROUP BY FARM_NAME
) AS e
ORDER BY Avg_Claim_Severity DESC;
