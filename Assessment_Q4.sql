SELECT
    u.id AS customer_id,  -- Unique customer ID
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Full name
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,  -- Tenure in months
    COUNT(s.id) AS total_transactions,  -- Total number of transactions
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE() ), 0)) * 12 
        * AVG(s.confirmed_amount * 0.001), 2
    ) AS estimated_clv  -- Estimated Customer Lifetime Value
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id  -- Join users with their savings transactions
GROUP BY u.id, u.first_name, u.last_name, u.date_joined  -- Grouping by customer
ORDER BY estimated_clv DESC;  -- Sort by highest CLV