SELECT
    u.id AS customer_id,    -- Unique customer ID
    CONCAT(u.first_name, ' ', u.last_name) AS name,    -- Concatenate first name and last name to get name.
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,  -- Calculate tenure in months,
    FORMAT(COUNT(s.id),0) AS total_transactions,   -- Total number of transactions
    FORMAT(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE() ), 0)) * 12 
        * AVG(s.confirmed_amount / 100 * 0.001), 2
    ) AS estimated_clv  -- Calculate estimated Customer Lifetime Value
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id  -- Join users with their savings transactions
GROUP BY u.id, u.first_name, u.last_name, u.date_joined  -- Grouping by customer
ORDER BY CAST(REPLACE(estimated_clv, ',', '') AS DECIMAL) DESC;  -- Sort by highest CLV