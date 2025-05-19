WITH total_savings AS (
	 -- Calculate total deposits per customer.
    SELECT 
			owner_id, 
			FORMAT(SUM(confirmed_amount /100.0), 2) AS total_deposits  -- Convert confirmed_amount from kobo to naira and format with 2 decimal places.
    FROM savings_savingsaccount
    GROUP BY owner_id
),
savings_investment_customer AS (
     -- Identify customers with at least one savings plan AND one investment plan
    SELECT p.owner_id
    FROM plans_plan p
    GROUP BY p.owner_id
    HAVING 
        SUM(p.is_regular_savings = 1) > 0
        AND
        SUM(p.is_a_fund = 1) > 0
)
SELECT  
    si.owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,      -- Concatenate first and last name
    SUM(p.is_regular_savings = 1) AS savings_count,      -- Count savings plans per customer
    SUM(p.is_a_fund = 1) AS investment_count,            -- Count investment plans per customer
    COALESCE(t.total_deposits, 0) AS total_deposits      -- Total deposits, 0 if none
FROM savings_investment_customer si
JOIN users_customuser u ON si.owner_id = u.id
JOIN plans_plan p ON p.owner_id = si.owner_id
LEFT JOIN total_savings t ON si.owner_id = t.owner_id
GROUP BY si.owner_id, u.first_name, u.last_name, t.total_deposits
ORDER BY CAST(REPLACE(t.total_deposits, ',', '') AS DECIMAL) DESC;  -- Sort by total deposits descending
