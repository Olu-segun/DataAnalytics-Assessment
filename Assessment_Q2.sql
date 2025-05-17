WITH trnx_count_per_month AS (
    SELECT 	
        owner_id,
        MONTHNAME(transaction_date) AS month_name,  -- Extract month name from transaction date
        COUNT(*) AS monthly_transaction             -- Count transactions per owner per month
    FROM savings_savingsaccount
    GROUP BY owner_id, month_name
),
Avg_trxn_per_customer AS (
    SELECT  
        owner_id,
        AVG(monthly_transaction) AS avg_monthly_trnx  -- Calculate average monthly transactions per owner
    FROM trnx_count_per_month
    GROUP BY owner_id
),
customer_category AS (
    SELECT 	
        owner_id,
        avg_monthly_trnx,
        CASE                                        -- Categorize customers based on avg monthly transactions
            WHEN avg_monthly_trnx >= 10 THEN 'High Frequency'
            WHEN avg_monthly_trnx BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM Avg_trxn_per_customer
)
SELECT 	
    frequency_category, 
    COUNT(*) AS customer_count,                    -- Number of customers per frequency category
    ROUND(AVG(avg_monthly_trnx), 1) AS avg_transactions_per_month -- Average transactions in each category
FROM customer_category
GROUP BY frequency_category;


