Name- krishna kumar 
project -Customer segmentation analysis to improve conversion


Task 1: Data Cleaning and Importing
Data Cleaning:

Apply data cleaning methods to refine the dataset.
Ensure data consistency and integrity by handling missing values, duplicates, and data type mismatches.
Importing Data:

Import the cleaned data into the analysis environment for further exploration.
Exploratory Data Analysis (EDA):

Conduct initial descriptive statistics and visualize data distributions and relationships.
Analyze active vs. closed accounts, account types and balances, loan amounts vs. account balances, and closure percentages.

Task 2: Exploratory Data Analysis
Active vs. Closed Accounts:

SELECT 
    "ACCOUNT_STATUS", 
    COUNT(*) AS count
FROM 
    "TRANSACTION_LINE"
GROUP BY 
    "ACCOUNT_STATUS";

2. Breakdown of Account Types and Balances:

SELECT 
    "ACCOUNT_CATEGORY", 
    COUNT(*) AS count, 
    SUM("ACCOUNT_BALANCE") AS total_balance
FROM 
    "TRANSACTION_LINE"
GROUP BY 
    "ACCOUNT_CATEGORY";

3. Loan Amounts vs. Account Balances:

SELECT 
    "ACCOUNT_CATEGORY", 
    AVG("SANCTIONED_AMOUNT") AS avg_loan_amount, 
    AVG("ACCOUNT_BALANCE") AS avg_balance
FROM 
    "TRANSACTION_LINE"
GROUP BY 
    "ACCOUNT_CATEGORY";

4. Closure Percentages by Ownership Type:

SELECT 
    "OWNERSHIP_TYPE", 
    "ACCOUNT_CATEGORY", 
    (COUNT(CASE WHEN "ACCOUNT_STATUS" = 'Closed' THEN 1 END) * 100.0) / COUNT(*) AS closure_percentage
FROM 
    "TRANSACTION_LINE"
GROUP BY 
    "OWNERSHIP_TYPE", "ACCOUNT_CATEGORY";

Task 3: Creating Required Additional Variables & Customer Segmentations

1.Additional Variables:

ALTER TABLE "TRANSACTION_LINE" ADD COLUMN active_month DATE;
UPDATE "TRANSACTION_LINE" SET active_month = DATE_TRUNC('month', "ORDER_DATE"::timestamp);

ALTER TABLE "TRANSACTION_LINE" ADD COLUMN promo_activation_month DATE;
UPDATE "TRANSACTION_LINE" SET promo_activation_month = DATE_TRUNC('month', "REDEMPTION_DATE"::timestamp);

ALTER TABLE "TRANSACTION_LINE" ADD COLUMN promo_ending_month DATE;
UPDATE "TRANSACTION_LINE" SET promo_ending_month = DATE_TRUNC('month', "VALIDITY_TILL_DATE"::timestamp);

2.Customer Segmentations:

FICO Scores and Account Categories:

SELECT 
    "FICO_SCORE", 
    "ACCOUNT_CATEGORY", 
    COUNT(*) AS count
FROM 
    "TRANSACTION_LINE"
GROUP BY 
    "FICO_SCORE", "ACCOUNT_CATEGORY";

-Product Usage Segmentation:

SELECT 
    "USER_ID", 
    STRING_AGG(DISTINCT "ACCOUNT_CATEGORY", ', ') AS product_types
FROM 
    "TRANSACTION_LINE"
GROUP BY 
    "USER_ID";
- Account Activity Segmentation:

SELECT 
    "USER_ID",
    COUNT(CASE WHEN "ACCOUNT_STATUS" = 'Active' THEN 1 END) AS active_accounts,
    COUNT(CASE WHEN "ACCOUNT_STATUS" = 'Closed' THEN 1 END) AS closed_accounts
FROM 
    "TRANSACTION_LINE"
GROUP BY 
    "USER_ID";

Task 4: Cross-Selling Opportunities & Cohort Analysis
1.Cohort Analysis:

WITH user_cohorts AS (
    SELECT 
        "USER_ID",
        DATE_TRUNC('month', MIN("ORDER_DATE"::DATE)) AS cohort_month
    FROM 
        "TRANSACTION_LINE"
    GROUP BY 
        "USER_ID"
),
cohort_retention AS (
    SELECT 
        uc.cohort_month,
        DATE_TRUNC('month', "ORDER_DATE"::DATE) AS active_month,
        COUNT(DISTINCT t."USER_ID") AS retained_users
    FROM user_cohorts uc
    JOIN "TRANSACTION_LINE" t ON uc."USER_ID" = t."USER_ID"
    GROUP BY uc.cohort_month, DATE_TRUNC('month', "ORDER_DATE"::DATE)
),
cohort_size AS (
    SELECT 
        cohort_month,
        COUNT("USER_ID") AS cohort_count
    FROM user_cohorts
    GROUP BY cohort_month
)
SELECT 
    TO_CHAR(cr.cohort_month, 'YYYY-MM') AS cohort_month,
    TO_CHAR(cr.active_month, 'YYYY-MM') AS active_month,
    cr.retained_users,
    (cr.retained_users * 1.0 / cohort_size.cohort_count) AS retention_rate
FROM cohort_retention cr
JOIN cohort_size ON cr.cohort_month = cohort_size.cohort_month
ORDER BY cr.cohort_month, cr.active_month;


3.Cross-Selling Opportunities:

-Common Account Combinations:

SELECT 
    "USER_ID",
    STRING_AGG(DISTINCT "ACCOUNT_CATEGORY", ', ') AS account_combinations
FROM 
    "TRANSACTION_LINE"
GROUP BY 
    "USER_ID";





