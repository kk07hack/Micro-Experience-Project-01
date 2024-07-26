Analyzing Customer Retention and Lifetime Value Through Cohort Analysis
Overview

-This project analyzes customer retention and lifetime value (CLTV) for Gameflix using SQL cohort analysis. The goal is to understand customer behaviors and improve retention strategies.

Data Preparation

-Data Quality Checks: Ensure no missing or duplicate values in ORDER, PROMOTIONAL_PLAN, and USER_REGISTRATION tables.
Extract Fields: Add active_month, promo_activation_month, and promo_ending_month columns to the ORDER table.

Cohort Analysis & Retention

-Create Cohorts: Based on the month of first subscription.
Retention Rates: Calculate the number of users retained each month and compute retention rates.

Customer Lifetime Value (CLTV)

-Cohort Revenue: Calculate monthly and total revenue for each cohort, determining average revenue per customer.
Gross Margin: Further analysis to understand profitability by cohort.

