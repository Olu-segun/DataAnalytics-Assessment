# Data-Analytics-Assessment

**OVERVIEW**
This repository contains solutions to the Cowrywise Data Analytics SQL Assessment. It includes SQL queries designed to solve real-world data analysis scenarios using tables such as:

users_customuser – containings customer information

plans_plan – details of savings and investment plans

savings_savingsaccount – transaction records and savings data of users

withdrawals_withdrawal -  Stores information about user's withdrawals

**Task 1**: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

**Goal**
Identify customers who:
      •	Have who at least one savings plan.
      •	Have who at least one investment plan.  
      •	Display their total confirmed savings deposits.

**Approach**
1. Calculate Total Deposits:
 I used a CTE (total_savings) to compute total confirmed_amount per customer from the savings_savingsaccount table.
2. Filter Qualified Customers:
    - In the savings_investment_customer CTE, filtered customers who have at least one savings plan and one investment fund using HAVING with conditional sums from the             plans_plan table.
3. Final Selection and Join:
  - Joined  savings_investment_customerwith  users_customuser  for customer details and plans_plan to count savings/investment plans.
  - Joined total_savings using LEFT JO IN to include users even if they have zero deposits.
  - Aggregated data per customer to:
  - Count number of savings and investment plans.
  - Fetch total confirmed deposits.
  - Concatenate first and last names as name.
4. Ordering:
   - Sorted the results by total_deposits in descending order to highlight customers with the highest savings.

 **Challenges Faced**
      •	Initially tried to filter customers directly in the main query using WHERE, but the correct approach required aggregation and filtering in the HAVING clause within a         grouped  CTE.
      •	I needed to include all selected fields (first_name, last_name, total_deposits) in the GROUP BY clause to comply with SQL standards.
      •	Extral care was taken to ensure correct joins between user, savings, and plans tables to avoid duplicated or missing rows.

**Outcome**
The query provides a clear and accurate summary of customers who are actively engaged in both savings and investment products, along with their total contributions. It supports business intelligence use cases such as customer segmentation, targeting, and prioritization for engagement.

