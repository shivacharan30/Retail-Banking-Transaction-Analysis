CREATE DATABASE retail_banking;

USE retail_banking;

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    
    date_of_birth DATE,
    gender VARCHAR(10),
    
    city VARCHAR(100),
    state VARCHAR(50),
    
    customer_since DATE,
    
    kyc_status VARCHAR(20),
    segment VARCHAR(50),
    
    annual_income DECIMAL(12,2),
    credit_score INT,
    
    is_active VARCHAR(10)
);

select *from customers;

CREATE TABLE accounts (
    account_id VARCHAR(15) PRIMARY KEY,
    
    customer_id VARCHAR(10) NOT NULL,
    branch_id VARCHAR(10) NOT NULL,
    
    account_type VARCHAR(50) NOT NULL,
    
    open_date DATE NOT NULL,
    close_date DATE,
    
    current_balance DECIMAL(15,2) DEFAULT 0,
    interest_rate DECIMAL(5,2),
    overdraft_limit DECIMAL(15,2) DEFAULT 0,
    
    status VARCHAR(20) NOT NULL,
    
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
        
    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);

select*from accounts;

create  TABLE branches (
    branch_id VARCHAR(10) PRIMARY KEY,
    
    branch_name VARCHAR(100) NOT NULL,
    
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    
    branch_manager VARCHAR(100),
    
    opening_date DATE,
    
    status VARCHAR(20)
);
select*from branches;

CREATE TABLE cards (
    card_id VARCHAR(15) PRIMARY KEY,
    
    account_id VARCHAR(15) NOT NULL,
    
    card_type VARCHAR(20) NOT NULL,
    
    issue_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    
    credit_limit DECIMAL(15,2) DEFAULT 0,
    
    outstanding_balance DECIMAL(15,2) DEFAULT 0,
    
    reward_points INT DEFAULT 0,
    
    is_active VARCHAR(10),
    
    network VARCHAR(50),
    
    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

select*from cards;

CREATE TABLE transactions (
    transaction_id VARCHAR(15) PRIMARY KEY,

    account_id VARCHAR(15) NOT NULL,

    transaction_date DATE NOT NULL,
    transaction_time TIME NOT NULL,

    transaction_type VARCHAR(50) NOT NULL,

    amount DECIMAL(15,2) NOT NULL,

    channel VARCHAR(50),

    description VARCHAR(255),

    balance_after DECIMAL(15,2),

    status VARCHAR(20),

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

select *from transactions;

CREATE TABLE loans (
    loan_id VARCHAR(15) PRIMARY KEY,

    customer_id VARCHAR(10) NOT NULL,
    branch_id VARCHAR(10) NOT NULL,

    loan_type VARCHAR(50) NOT NULL,

    principal_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2),

    tenure_months INT,

    disbursement_date DATE,
    maturity_date DATE,

    emi_amount DECIMAL(15,2),

    outstanding_balance DECIMAL(15,2),

    loan_status VARCHAR(30),

    purpose VARCHAR(100),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);
select *from loans;


CREATE TABLE loan_payments (
    payment_id VARCHAR(20) PRIMARY KEY,
    loan_id VARCHAR(20) NOT NULL,
    payment_date VARCHAR (20) NOT NULL,
    scheduled_amount DECIMAL(15,2),
    paid_amount DECIMAL(15,2),
    principal_paid DECIMAL(15,2),
    interest_paid DECIMAL(15,2),
    penalty DECIMAL(15,2) DEFAULT 0,
    days_late INT DEFAULT 0,
    payment_method VARCHAR(50),
    status VARCHAR(50),
FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id)
);
select*from loan_payments;


select*from accounts;
select*from branches;
select*from cards;
select *from customers;
select*from loans;
select*from loan_payments;
select*from transactions;

-- Sprint 3: Basic Analysis / Data Exploration
-- Write SQL queries to answer the following basic questions. The purpose of this sprint is to become 
-- familiar with the database before moving into objective-based analysis.
-- What is the total number of customers?;
select count(*) as total_customer from customers;

-- What is the total number of accounts?
select count(*) as total_account from accounts;

-- What are the different account types available?
-- Different account types
select distinct account_type from  accounts;

-- How many customers are currently active?
select COUNT(*) AS active_customers from customers
WHERE is_active = 'yes';

-- What are the different transaction types available?
select distinct transaction_type from transactions;

-- What is the total amount of completed transactions?
select count(amount) as total_amount from transactions;

-- What are the different loan types available?
select  distinct loan_type from loans;

-- What is the total number of loans?
select count(*) as total_loans from loans;

-- What are the different card types available?
select distinct card_type from cards;

-- What is the total outstanding loan balance?
select sum(outstanding_balance) from loans;


-- Sprint 4: Objective-Based Analysis
-- Understand Customer Profile and Segmentation

-- How many customers are there in each customer segment?
SELECT segment, COUNT(*) AS customer_count FROM customers
GROUP BY segment;

-- How many customers are there in each city?
select count(*) as customers_city from customers
group by city;

-- How many customers are there in each state?
select state,count(*) as customer_count from customers
group by state;

-- What is the average income of customers in each segment?
select segment,avg(annual_income) from customers
group by segment;

-- What is the average credit score of customers in each segment?
select segment,avg(credit_score) as average_creditscore from customers
group by segment;

-- How many customers are currently active and inactive?
select is_active,count(*) as customer_count from customers
group by is_active;
select*from customers;

-- How many customers have completed their KYC?
select kyc_status,count(*) as completed_kyc from customers
where kyc_status ='Verified';

-- -- What is the total number of customers?
select count(*) as total_customer from customers;


-- .2 Understand Account Usage and Branch Activity
-- How many accounts are there for each account type?
select distinct account_type from accounts;
select *from accounts;
-- What is the total balance held in each account type?
select account_type,sum(current_balance) as total_balance
from accounts group by account_type;

-- What is the average balance for each account type?
select account_type,avg(current_balance) as average_balance from accounts group by account_type;
 
-- How many accounts are currently active and closed?
select status,count(*) as account_count from accounts
group by status;
-- Which branches have the highest number of accounts?
select max(branch_Id) as haccountsighest_number from accounts;
select*from accounts;
-- Which branches have the highest total account balance?
select max(current_balance)as highest_total from accounts;


-- What is the average interest rate for each account type?
select account_type, avg(interest_rate) as average_rate from accounts
group by account_type;


-- -- 4.3 Analyze Transaction Patterns
-- How many transactions are there for each transaction type?
select transaction_type,count(*) from transactions
group by transaction_type;
select*from transactions;
-- What is the total transaction amount for each transaction type?
select transaction_type,sum(amount) as total_transaction from transactions
group by transaction_type;

-- Which transaction channels are used most frequently?
select channel,count(*) as most_channel from transaction
group by channel;

-- What is the average transaction amount for each transaction type?
select transaction_type,avg(amount) as transaction_amount from transactions
group by transaction_type;

-- What are the most common transaction descriptions?
select description,count(*) as common_transaction from transactions
group by description;

-- How many transactions occur in each month?
select count(transaction_date) as transaction_month from transactions;

-- Which accounts have the highest number of transactions?
SELECT account_id,COUNT(*) AS transaction_count FROM transactions
GROUP BY account_id;

-- Which accounts have the highest total transaction value?
select account_id,count(*) as highest_total from transactions
group by account_id;


-- 4.4 Evaluate Loan Performance and Repayment Behaviour
-- How many loans are there for each loan type?
select loan_type,count(*) as loan_type from loans
group by loan_type;
select*from loans;
-- What is the total loan amount for each loan type?
select loan_type,sum(principal_amount) as loan_amount from loans
group by loan_type;

-- What is the total outstanding loan balance for each loan type?
select loan_type,sum(outstanding_balance) as loan_balance from loans
group by loan_type;
-- How many loans are there for each loan status?
select loan_status,count(*) as loans_status from loans
group by loan_status;

-- Which loan purposes are most common?
select purpose,count(*) as common_purposes  from loans
group by purpose;

-- Which payment methods are most commonly used for loan repayments?
SELECT loan_type,COUNT(*) AS loan_count FROM loans
GROUP BY loan_type;


-- 4.5 Understand Card Usage and Product Engagement
-- How many cards are there for each card type?
select card_type,count(*) as card_type from cards
group by card_type;
select *from cards;

-- How many cards are currently active and inactive?
select is_active,count(*) as card_count from cards
group by is_active;
-- What is the average credit limit for each card type?
select card_type,avg(credit_limit) as average_credit from cards
group by card_type;

-- What is the total outstanding balance for each card type?
select card_type,sum(outstanding_balance) as total_outstanding from cards
group by card_type;

-- Which card types have the highest reward points?
select card_type,max(reward_points) as highest_reward from cards
group by card_type;

-- How many cards does each customer have?
select account_id,count(*) as card_count from cards 
group by account_id;

