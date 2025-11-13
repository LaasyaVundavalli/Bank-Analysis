-- Data Generation Script for Indian Banking Context
-- This script populates the database with simulated Indian customer data, including names, cities, and transaction details.
-- It uses PostgreSQL's random functions to generate realistic data distributions.

-- Step 1: Insert 200 realistic Indian customers
-- Generate customer records with random names, genders, birth dates, signup dates, and cities.
-- Names are drawn from common Indian first and last names.
-- Cities include major Indian urban centers, with Puducherry as the primary focus.
INSERT INTO customers (name, gender, dob, signup_date, city)
SELECT 
    -- Full Name: Firstname + Lastname
    first_names[ceil(random() * array_length(first_names, 1))] || ' ' ||
    last_names[ceil(random() * array_length(last_names, 1))],

    -- Random gender
    CASE WHEN random() < 0.5 THEN 'M' ELSE 'F' END,

    -- Random date of birth (between 1970 and 1997)
    DATE '1970-01-01' + (trunc(random() * 10000)::int) * INTERVAL '1 day',

    -- Random signup date within last 3 years
    CURRENT_DATE - (trunc(random() * 1095)::int) * INTERVAL '1 day',

    -- Random city
    cities[ceil(random() * array_length(cities, 1))]
FROM generate_series(1, 200),
LATERAL (
    SELECT 
        ARRAY[
            'Amit', 'Priya', 'Raj', 'Anjali', 'Vikram', 'Sneha', 'Arjun', 'Kavita',
            'Ravi', 'Meera', 'Suresh', 'Pooja', 'Deepak', 'Sunita', 'Mohan', 'Rekha',
   'Kiran', 'Nisha', 'Rakesh', 'Lata'
        ] AS first_names,
        ARRAY[
            'Sharma', 'Patel', 'Singh', 'Kumar', 'Gupta', 'Jain', 'Verma', 'Agarwal',
            'Chopra', 'Mehta', 'Rao', 'Nair', 'Iyer', 'Das', 'Banerjee', 'Saxena',
   'Mishra', 'Yadav', 'Joshi', 'Pandey'
        ] AS last_names,
        ARRAY[
            'Puducherry', 'Chennai', 'Bangalore', 'Hyderabad', 'Mumbai', 'Delhi', 'Kolkata', 'Ahmedabad',
            'Pune', 'Jaipur', 'Lucknow', 'Chandigarh'
        ] AS cities
) name_data;

SELECT * FROM customers

-- Step 2: Insert accounts for customers
-- Create 1-2 accounts per customer with unique 10-digit account numbers, account types (savings, current, loan), and random balances.
-- Account numbers are generated as zero-padded 10-digit strings.
-- Balances range from 1000 to 500000 INR, simulating realistic account values.
INSERT INTO accounts (customer_id, account_number, account_type, open_date, balance)
INSERT INTO accounts (customer_id, account_number, account_type, open_date, balance)
SELECT 
    c.customer_id,
    LPAD((trunc(random() * 1e10)::bigint)::text, 10, '0') AS account_number,
    (ARRAY['savings', 'current', 'loan'])[floor(random() * 3 + 1)],
    c.signup_date + (trunc(random() * 90)::int) * INTERVAL '1 day',
    round((1000 + random() * 499000)::numeric, 2)
FROM customers c
JOIN generate_series(1, 2) AS dup(n) ON true
WHERE random() < 0.75		-- Around 75% of customers get a second account
ORDER BY c.customer_id
LIMIT 1000;

SELECT * FROM accounts

-- Step 3: Insert transactions
-- Generate 1000 transactions across accounts with random types (debit/credit), amounts, dates, and descriptions.
-- Transactions simulate real banking activities like payments, transfers, and deposits.
-- Descriptions are tailored to Indian context, including local brands and services.
INSERT INTO transactions (account_id, transaction_type, amount, transaction_date, description)
INSERT INTO transactions (account_id, transaction_type, amount, transaction_date, description)
SELECT 
    t.account_id,
    t.transaction_type,
    t.amount,
    t.transaction_date,
    d.description
FROM (
    SELECT 
        a.account_id,
        -- Randomly assign credit or debit
        CASE 
            WHEN random() < 0.5 THEN 'debit' 
            ELSE 'credit' 
        END AS transaction_type,
        -- Random amount between 500 and 250,000
        ROUND((500 + random() * 249500)::numeric, 2) AS amount,
        -- Random date within past 2 years
        NOW() - (trunc(random() * 730) || ' days')::INTERVAL AS transaction_date
    FROM accounts a,
         generate_series(1, 10) gs
) t
-- Attach description based on type
JOIN LATERAL (
    SELECT 
        CASE 
            WHEN t.transaction_type = 'credit' THEN
                (ARRAY[
                    'Salary credited',
                    'Bank transfer from HDFC',
                    'Credit alert from SBI',
                    'Reversal of failed transaction',
                    'Loan disbursement',
                    'Wallet top-up',
                    'Refund from vendor',
                    'POS reversal',
                    'Received from customer',
                    'Online payment received',
                    'Cash deposit'
                ])[FLOOR(random() * 11 + 1)::int]
            ELSE
                (ARRAY[
                    'POS payment at Big Bazaar',
                    'Airtel Airtime recharge',
                    'Fuel purchase at Indian Oil',
                    'Electricity bill payment',
                    'Loan EMI debit',
                    'House rent payment',
                    'Online purchase at Flipkart',
                    'Cash withdrawal from ATM',
                    'Subscription payment',
                    'Insurance premium debit',
                    'Bank transfer to ICICI Bank'
                ])[FLOOR(random() * 11 + 1)::int]
        END AS description
) d ON TRUE
ORDER BY random()
LIMIT 1000;

SELECT * FROM transactions

-- Step 4: Verification queries
-- Confirm balanced transaction types (debit vs credit) to ensure realistic data distribution.
SELECT 
	transaction_type, 
	COUNT(*) 
FROM transactions 
GROUP BY transaction_type;

-- See variety of descriptions
SELECT 
	description, 
	COUNT(*) 
FROM transactions 
GROUP BY description 
ORDER BY COUNT(*) DESC;

-- Count total rows
SELECT 
	COUNT(*) 
FROM transactions;

