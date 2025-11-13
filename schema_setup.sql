-- Database Schema Setup for Bank Segmentation Analysis
-- This script creates the core tables for the banking database: customers, accounts, and transactions.
-- It establishes relationships and constraints to ensure data integrity.

-- Step 1: Create customers table
-- Stores basic customer information including demographics and location.
-- customer_id is auto-incrementing primary key.
-- gender is restricted to 'M' or 'F'.
-- city represents the customer's location in India.
CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	gender VARCHAR(1) CHECK (gender IN ('M', 'F')),
	dob DATE,
	signup_date DATE NOT NULL,
	city TEXT
);

-- Step 2: Create accounts table
-- Links accounts to customers and stores account details.
-- account_id is auto-incrementing primary key.
-- customer_id references customers table for relationship.
-- account_type is restricted to 'savings', 'current', or 'loan'.
-- balance stores the current account balance with 2 decimal precision.
CREATE TABLE accounts (
     account_id SERIAL PRIMARY KEY,
     customer_id INT REFERENCES customers(customer_id),
     account_type VARCHAR(20) CHECK (account_type IN ('savings', 'current', 'loan')),
     open_date DATE NOT NULL,
     balance NUMERIC(12,2) DEFAULT 0
 );
-- Add account_number column as a unique identifier for each account.
ALTER TABLE accounts ADD COLUMN account_number TEXT;

-- Step 3: Create transactions table
-- Records all financial transactions linked to accounts.
-- transaction_id is auto-incrementing primary key.
-- account_id references accounts table.
-- amount stores transaction value with 2 decimal precision.
-- transaction_type indicates 'debit' or 'credit'.
-- description provides details about the transaction.
CREATE TABLE transactions (
     transaction_id SERIAL PRIMARY KEY,
     account_id INT REFERENCES accounts(account_id),
     transaction_date DATE NOT NULL,
     amount NUMERIC(12,2) NOT NULL,
     transaction_type VARCHAR(20),
     description VARCHAR(50)
 );
