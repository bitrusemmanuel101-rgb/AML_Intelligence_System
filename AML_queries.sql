
-- Query 1: Top 10 Highest Risk Customers
SELECT  
    Customer_Name,
    Customer_ID,
    count(*) as Total_Transaction,
    sum(AML_Label) as Suspicious_Transactions,
    round(sum(Transaction_Amount), 2) as Total_Amount_Moved,
    ROUND(avg(AML_Risk_Score), 2) as Average_Risk_Score
FROM
    aml_transactions
group BY
    Customer_Name, Customer_ID
order BY
    average_risk_score desc
    limit 10;




-- Query 2: Total Value at Risk
SELECT
    ROUND(SUM(Transaction_Amount), 2) AS Total_TPV,
    ROUND(SUM(CASE WHEN AML_Label = 1 
        THEN Transaction_Amount ELSE 0 END), 2) AS Suspicious_Volume,
    round(SUM(CASE WHEN AML_Label = 1 
        THEN Transaction_Amount ELSE 0 END) * 100.0 
        / SUM(Transaction_Amount), 2) AS Suspicious_Volume_Percentage,
    count(*) as Transaction_Count,
     sum(CASE WHEN AML_Label = 1 
        THEN 1 ELSE 0 END),
    round(sum(CASE WHEN AML_Label = 1 
        THEN 1 ELSE 0 END) * 100.0 
        / count(*), 2) as Suspicious_count_Percentage

FROM
    aml_transactions;




-- Query 3: SAR Candidates
SELECT 
    Customer_ID,
    Customer_Name,
    COUNT(*) AS Total_Transactions,
    SUM(AML_Label) AS Suspicious_Count,
    ROUND(AVG(AML_Risk_Score), 2) AS Avg_Risk_Score,
    ROUND(SUM(Transaction_Amount), 2) AS Total_Amount_Moved,
    'File SAR' AS Recommended_Action
FROM 
    aml_transactions
GROUP BY 
    Customer_ID, Customer_Name
HAVING 
    Avg_Risk_Score >= 0.35
AND 
    Suspicious_Count > 2
ORDER BY 
    Avg_Risk_Score DESC;





-- Query 4: Suspicious Corridors
SELECT
    Sender_Country,
    Receiver_Country,
    round(sum(CASE WHEN AML_Label = 1 
    then Transaction_Amount else 0 END), 2) as Suspicious_Transaction,
    sum(AML_Label) as Suspicious_Count,
    ROUND(avg(AML_Risk_Score), 2) as Average_Risk_Score
FROM    
    aml_transactions
group BY
    Sender_Country, Receiver_Country
HAVING
    Suspicious_Transaction > 0
ORDER BY
    Average_Risk_Score DESC
LIMIT
    10;




-- Query 5: Red Flag Distribution
SELECT 
    'Geo Risk' AS Flag_Type, SUM(Geo_Risk_Flag) AS Count 
FROM 
    aml_transactions
UNION ALL
SELECT 
    'Structuring', SUM(Structuring_Flag) 
FROM 
    aml_transactions
UNION ALL
SELECT 
    'Velocity',    SUM(Velocity_Flag) 
FROM 
    aml_transactions
UNION ALL
SELECT 
    'Round Number',SUM(Round_Number_Flag) 
FROM 
    aml_transactions
UNION ALL
SELECT 
    'Prior SAR',   SUM(Previous_SAR_Flag) 
FROM 
    aml_transactions
ORDER BY 
    Count DESC;




--Query 6: Risk By Account Type
SELECT
    Account_Type,
    count(*) as  Transaction_Count,
    sum(Transaction_Amount) as Total_TPV,
    sum(AML_Label) as Suspicious_count,
    round(avg(AML_Risk_Score), 2) as Average_Risk_Score
FROM
    aml_transactions
GROUP BY
    Account_Type
ORDER BY
    Average_Risk_Score DESC;




-- Peak suspicious hours
SELECT 
    SUBSTR(Transaction_Time, 1, 2) AS Hour,
    COUNT(*) AS Total_Transactions,
    SUM(AML_Label) AS Suspicious_Count,
    ROUND(AVG(AML_Risk_Score), 2) AS Avg_Risk_Score
FROM 
    aml_transactions
GROUP BY 
    Hour
ORDER BY 
    Suspicious_Count DESC
LIMIT 5;




--Query 8: Risk By Transaction Type
SELECT
    Transaction_Type,
    count(*) as  Transaction_Count,
    sum(Transaction_Amount) as Total_TPV,
    sum(AML_Label) as Suspicious_count,
    round(avg(AML_Risk_Score), 2) as Average_Risk_Score
FROM
    aml_transactions
GROUP BY
    Transaction_Type
ORDER BY
    Average_Risk_Score DESC;