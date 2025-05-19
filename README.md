
# Data-Analytics-Assessment

This repository contains solutions to the Cowrywise Data Analytics SQL technical assessment. It includes SQL queries designed to solve real-world data analysis business problem using tables such as:

**users_customuser** – contains customer demographic and contact information

**plans_plan** – contains records of plans created by customers.

**savings_savingsaccount** – contains records of deposit transactions.

**withdrawals_withdrawal** - contains records of withdrawal transactions

---

# Per-Question Explanations

---

## Task 1 : Write a query to find customers with at least one funded savings plan and one funded investment plan, sorted by total deposits.

###  Business Goal
Identify customers who:
- Have **at least one savings plan** (`is_regular_savings = 1`)  
- Have **at least one investment plan** (`is_a_fund = 1`)  
- Display their total confirmed savings deposits.


###  Approach

1. **Calculate Total Deposits:**
   - I used CTE (`total_savings`) to compute total `confirmed_amount` per customer from the `savings_savingsaccount` table and grouped it by `owner_id`.

2. **Filter Qualified Customers:**
   - In the `savings_investment_customer` CTE, I filtered customers who have **at least one savings plan** and **one investment fund** using `HAVING` with conditional sums from the `plans_plan` table.

3. **Final Selection and Join:**
   - Joined `savings_investment_customer` with `users_customuser` for customer details and `plans_plan` to count savings/investment plans.
   - Joined `total_savings` using `LEFT JOIN` to include users even if they have zero deposits.
   - Aggregated data per customer to; count number of savings and investment plans, fetch total confirmed deposits and Concatenate first and last names as `name`
  
4. **Ordering:**
   - Sorted the results by `total_deposits` in descending order to highlight customers with the highest total deposits.


### ✅ Outcome
The query provides a clear and accurate summary of customers who are actively engaged in both savings and investment products, along with their total deposits.

---

## Task 2 :  Calculate the average number of transactions per customer per month and categorize them. 

###  Business Goal
Classify customers based on how frequently they make transactions in their savings accounts and group them into **High**, **Medium**, or **Low** frequency categories.

###  Approach

1. **Monthly Transaction Count:**
   - I created a CTE `trnx_count_per_month` to count how many transactions each customer deposited in each month.
   - I used `MONTHNAME(transaction_date)` to extract the month name.

2. **Average Monthly Transactions per Customer:**
   - I Aggregated the monthly counts in a second CTE `Avg_trxn_per_customer` and calculated the average number of transactions per customer across all active months.
    
3. **Customer Categorization:**
   - In the third CTE `customer_category`,  I categorized customers based on average monthly transactions:
     - **High Frequency**: ≥ 10 transactions/month
     - **Medium Frequency**: 3–9 transactions/month
     - **Low Frequency**: < 3 transactions/month

4. **Final Aggregation:**
   - I Counted how many customers fall into each category and calculated the average monthly transaction count per category for summary analysis.

### ✅ Outcome
This query provides the finance team with an actionable segmentation of users based on how actively they engage with the savings platform.

---

## Task 3 : Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days)

### Business Goal
Identify savings and investment accounts that have **no transactions in the past 365 days**, helping the business flag inactive accounts for re-engagement or review.

###  Approach

1. **Join Relevant Tables:**
   - Joined `savings_savingsaccount` (`s`) with `plans_plan` (`p`) to access both account activity and plan type details.

2. **Classify Plan Types:**
   - Used a `CASE` statement to label each plan as either:
     - `'investments'` (if `is_a_fund = 1`)
     - `'savings'` (if `is_regular_savings = 1`)
     - `'other'` (if neither flag is true)

3. **Identify Last Transaction:**
   - For each `plan_id` and `owner_id`, used `MAX(transaction_date)` to get the most recent transaction date.

4. **Calculate Inactivity Period:**
   - Used `DATEDIFF(CURDATE(), MAX(s.transaction_date))` to compute the number of days since the last transaction.

5. **Filter Inactive Accounts:**
   - Applied `HAVING inactivity_days >= 365` to only return accounts inactive for at least one year.

### ✅ Outcome
The final output lists all accounts with **over 1 year of inactivity**, categorized by plan type. This data can support user retention strategies or identify stale plans that may need to be closed or reactivated.

---

## Task 4 : For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
**Account tenure (months since signup)**

**Total transactions**

**Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)**

**Order by estimated CLV from highest to lowest**

### Business Goal
Estimate **Customer Lifetime Value (CLV)** based on how long a customer has been active (tenure) and how much they transact. This helps marketing identify high-value customers for retention or upsell efforts.

###  Approach

1. **Join Relevant Tables:**
   - Joined `users_customuser` (`u`) with `savings_savingsaccount` (`s`) to relate users with their savings transactions.

2. **Calculate Account Tenure:**
   - Used `TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())` to compute how many full months have passed since the user signed up.

3. **Transaction Count:**
   - Counted all transactions (`s.id`) made by each customer.

4. **Compute Estimated CLV:**
   - Formula used:
     ```
     CLV = (total_transactions / tenure_months) * 12 * average_profit_per_transaction
     ```
     - Assumed average profit is **0.1% (0.001)** of the transaction value.
     - Used `AVG(s.confirmed_amount * 0.001)` to compute average profit per transaction.
     - Wrapped tenure in `NULLIF(..., 0)` to avoid division-by-zero errors.

5. **Final Output:**
   - Displayed customer ID, name, tenure, total transactions, and estimated CLV.
   - Ordered results by CLV descending to highlight the most valuable customers.

### ✅ Outcome
This query produces a ranked list of customers by estimated lifetime value. It helps identify **high-engagement, high-value users** that are critical to business growth, making it useful for strategic decision-making in marketing teams.

---

# Challenges Faced

---

**Group vs Filter Logic:**
   Initially, I tried to filter customers directly in the main query using `WHERE`, but the correct approach required aggregation and filtering in the `HAVING` clause within a grouped CTE.
 
**Missing Deposits:**
   Some customers had no deposits, which caused null values when joining tables, but I resolved this using `COALESCE` to default missing values to 0.

**Division by Zero error:**
   Some users may have `tenure_months = 0`, especially new signups, but I solved it by using `NULLIF(..., 0)` to prevent the error.
  




**Name:** Olukayode Olusegun Opeyemi

**Phone:** +2348161264527

**Email**: Olukayodeoluseguno@gmail.com

**LinkedIn:** www.linkedin.com/in/olukayodeolusegun

