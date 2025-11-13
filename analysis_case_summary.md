# Bank Segmentation Analysis

## Introduction
This project explores customer segmentation in banking using simulated Indian banking data, with a focus on Puducherry and other major cities. By analyzing transaction patterns and account activity, the aim is to identify valuable customer segments, detect dormant accounts, and support data-driven marketing strategies.

By leveraging SQL queries on realistically simulated datasets, this analysis mimics real-world banking data environments and prepares for financial data roles requiring strong SQL and business understanding.

## Project Objectives
- Identify high-value customers based on transaction volume and frequency
- Analyze salary payment trends and dormant accounts
- Understand customer product usage and segmentation by account type
- Perform regional analysis of customer activity and value across Indian cities, with focus on Puducherry
- Segment customers by digital transaction adoption (>90% digital channels)
- Provide actionable insights to support targeted banking strategies

## Methodology

### Data Simulation  
Since access to real banking data is restricted, this project uses simulated datasets designed to mimic real-world Nigerian banking data. The data includes:  
- **Customers:** 200 customers with realistic Indian first and last names, randomly assigned genders, birthdates between 1970 and 1997, and cities representing Indian urban centers including Puducherry.
- **Accounts:** Multiple accounts per customer, each with unique 10-digit account numbers and associated product types (Savings, Current, Loan).
- **Transactions:** Over 1000 transactions randomly distributed across accounts, including debit and credit types with carefully matched descriptions reflecting real Indian banking activities (e.g., salary payments, POS purchases, online transfers). Transaction dates span recent years, simulating ongoing customer activity.

### SQL Analysis  
The core of this project involves writing advanced SQL queries to extract business insights. Techniques applied include:  
- **Aggregations** (SUM, COUNT, AVG) to measure spending, transaction volumes, and frequency.  
- **Joins** to combine customer, account, and transaction data effectively.  
- **Window Functions** and **Grouping Sets** to enable detailed segmentation by time, city, and product type.  
- **Filtering and Date Functions** to analyze trends over months and years and identify dormant accounts.  

This methodology simulates the end-to-end process of banking data analysis, from raw data preparation to actionable business insights, reinforcing skills essential for financial data roles.

## Key Insights & Findings

This section summarizes the core insights derived from SQL analysis across customers, accounts, and transactions:

### 1. Total Spend per Customer  
Revealed the top spenders by summing all debit transactions, helping to identify high-value customers with strong transaction volumes.

### 2. Salary Trend Analysis  
Tracked monthly salary credit trends, showing consistency in salary disbursements and highlighting months where no salaries were paid — a red flag for economic or payroll anomalies.

### 3. Most Active Accounts by Number of Transactions  
Ranked accounts with the highest number of transactions, pointing to highly engaged users.

### 4. Most Active Accounts by Volume  
Identified accounts processing the largest transaction amounts, useful for recognizing premium banking clients.

### 5. Monthly Transaction Breakdown  
Offered a month-by-month analysis of transaction counts and volume, providing a clear view of seasonal banking behavior.

### 6. Yearly Transaction Breakdown  
Aggregated transaction trends over the years, helping understand long-term banking patterns and growth.

### 7. Top 20 High-Value Customers (Total Credit)  
Ranked customers who receive the most inflows — key for relationship management and upselling financial products.

### 8. Dormant Accounts  
Uncovered accounts with no transactions in the last 12 months — a strategic insight for reactivation campaigns.

### 9. Single Product Customers  
Found customers with only one account type — a valuable segment for cross-selling additional financial services.

### 10. Most Used Transaction Services  
Measured usage frequency of services (like POS, transfers, salary payments), indicating service adoption and preferred channels.

### 11. City-wise Performance  
Compared transaction volumes and activity across cities, helping prioritize branch or market expansion efforts.

### 12. Engagement by Region
Segmented customers and accounts into active vs. dormant groups by region, highlighting geographical strengths and weak points.

### 13. Digital-Only Customers
Identified customers performing >90% of transactions through digital channels (excluding cash withdrawals and deposits), indicating readiness for advanced digital banking services.

> 🔹 **Bonus Insight:** Highest Spender Per City
Identified the top spender in each Indian city — a hyper-localized view of high-value clients.

---

## Data Export and Visualization

### CSV Export of Query Results
To export key query results to CSV files for further analysis or reporting, use PostgreSQL's \COPY command. For example:

```sql
-- Export top 20 high-value customers to CSV
\COPY (
    SELECT c.customer_id, c.name, c.gender, c.city, COUNT(t.transaction_id) AS credit_transaction_count, SUM(t.amount) AS total_credits
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    JOIN customers c ON a.customer_id = c.customer_id
    WHERE t.transaction_type = 'credit'
    GROUP BY c.customer_id, c.name, c.gender, c.city
    ORDER BY total_credits DESC
    LIMIT 20
) TO 'top_20_high_value_customers.csv' WITH CSV HEADER;
```

Similar \COPY commands can be used for other queries to generate CSV files.

### JSON Summary File
A JSON summary file (`segmentation_summary.json`) can be created to aggregate key segmentation metrics:

```json
{
  "total_customers": 200,
  "total_accounts": 300,
  "total_transactions": 1000,
  "segments": {
    "high_value_customers": 20,
    "dormant_accounts": 15,
    "single_product_customers": 50,
    "digital_only_customers": 25
  },
  "top_city": "Puducherry",
  "generated_at": "2025-11-13"
}
```

This file provides a quick overview of segmentation results for integration with other systems or dashboards.

### Python Visualization Script
The `export_visualization.py` script connects to the PostgreSQL database, executes major segmentation queries, and generates a bar chart showing the top 5 segments by customer count using Matplotlib. This visualization helps in quickly understanding the distribution of customer segments.

---

## Conclusion & Recommendations

This project explored customer segmentation in a simulated Indian retail bank, with a focus on Puducherry, using structured SQL queries and realistic financial data. By analyzing customer behavior, transaction trends, and account activities, we were able to extract meaningful business insights that can guide strategic decisions.

### Key Highlights

- Identified **top spenders** and **most active accounts** by both volume and frequency
- Tracked **salary payment trends**, revealing seasonal patterns and potential employer engagement opportunities
- Detected **dormant accounts** and **single-product customers**, highlighting reactivation and cross-sell opportunities
- Segmented customer engagement **by region and city**, with focus on Puducherry, offering geo-targeted insights for marketing or branch strategy
- Analyzed **most used transaction types**, informing service prioritization and infrastructure planning
- Identified **digital-only customers** for advanced banking service targeting

---

## Recommendations

Based on the above insights, here are actionable recommendations for the bank:

1. **Target High-Value Customers**  
   Introduce premium services or loyalty rewards to retain top 10–20% of spenders, especially those with consistent credit inflow and multi-channel activity.

2. **Reactivate Dormant Customers**  
   Launch targeted reactivation campaigns offering incentives to customers inactive for 12+ months. Include dormant regions in outreach efforts.

3. **Cross-Sell to Single-Product Customers**  
   Customers with only one account type are likely under-leveraged. Recommend savings, investment, or loan products based on behavior.

4. **Strengthen Presence in Top Cities**  
   Expand marketing or branch coverage in cities with high-value or high-activity customers to consolidate market share.

5. **Balance Transaction Services**  
   Monitor infrastructure capacity around the most used services (e.g., POS, transfers), while improving underused services like mobile or bill payment.

6. **Review Salary Payment Gaps**  
   Investigate causes of missing salary transactions in some months and assess impact on liquidity and customer satisfaction.

7. **Improve Regional Penetration**
   Use geo-segmentation data to guide branch expansion or digital adoption strategies in underrepresented regions, with emphasis on Puducherry.

8. **Target Digital-Only Customers**
   Offer premium digital banking features, mobile apps, and online services to customers already heavily using digital channels to enhance satisfaction and loyalty.

---

This project exemplifies how structured SQL analytics can unlock strategic insights in the banking industry — without requiring advanced tools. It strengthens my ability to **build from scratch, think like a financial analyst**, and produce insights that matter.

