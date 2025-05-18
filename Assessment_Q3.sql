SELECT 
    s.plan_id,              -- Plan ID from savings accounts.
    s.owner_id,             -- Owner (customer) ID
    CASE                    -- Determine plan type based on flags
        WHEN p.is_a_fund = 1 THEN 'investments'
        WHEN p.is_regular_savings = 1 THEN 'savings'
        ELSE 'other'
    END AS type,
    MAX(DATE(s.transaction_date)) AS last_transaction_date,     -- Most recent transaction date
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days  -- Days since last transaction
FROM savings_savingsaccount s
JOIN plans_plan p ON s.plan_id = p.id   -- Join plans to savings accounts
GROUP BY s.plan_id, s.owner_id, type    -- Aggregate by plan and owner
HAVING inactivity_days >= 365;          -- Filter accounts inactive for 1 year or more