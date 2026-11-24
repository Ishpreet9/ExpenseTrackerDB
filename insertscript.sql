SQL INSERT script

-- ====================================================================
-- 1. INSERT INTO Users (10 rows)
-- ====================================================================
INSERT INTO Users (user_id, full_name, email, created_at) VALUES (1, 'Rahul Sharma', 'rahul@gmail.com', TO_DATE('01-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Users (user_id, full_name, email, created_at) VALUES (2, 'Priya Patel', 'priya.patel@gmail.com', TO_DATE('02-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Users (user_id, full_name, email, created_at) VALUES (3, 'Aarav Verma', 'aarav.verma@gmail.com', TO_DATE('03-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Users (user_id, full_name, email, created_at) VALUES (4, 'Sneha Reddy', 'sneha.reddy@gmail.com', TO_DATE('04-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Users (user_id, full_name, email, created_at) VALUES (5, 'Vikram Singh', 'vikram.singh@gmail.com', TO_DATE('05-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Users (user_id, full_name, email, created_at) VALUES (6, 'Ananya Nair', 'ananya.nair@gmail.com', TO_DATE('06-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Users (user_id, full_name, email, created_at) VALUES (7, 'Rohan Das', 'rohan.das@gmail.com', TO_DATE('07-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Users (user_id, full_name, email, created_at) VALUES (8, 'Kavya Menon', 'kavya.menon@gmail.com', TO_DATE('08-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Users (user_id, full_name, email, created_at) VALUES (9, 'Siddharth Joshi', 'sid.joshi@gmail.com', TO_DATE('09-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Users (user_id, full_name, email, created_at) VALUES (10, 'Meera Kapoor', 'meera.kapoor@gmail.com', TO_DATE('10-NOV-2026', 'DD-MON-YYYY'));

-- ====================================================================
-- 2. INSERT INTO Income_Types (7 specified items)
-- ====================================================================
INSERT INTO Income_Types (type_id, type_name) VALUES (1, 'Salary');
INSERT INTO Income_Types (type_id, type_name) VALUES (2, 'Freelance');
INSERT INTO Income_Types (type_id, type_name) VALUES (3, 'Rental');
INSERT INTO Income_Types (type_id, type_name) VALUES (4, 'Bank Interest');
INSERT INTO Income_Types (type_id, type_name) VALUES (5, 'Performance Bonus');
INSERT INTO Income_Types (type_id, type_name) VALUES (6, 'Cashback and Rewards');
INSERT INTO Income_Types (type_id, type_name) VALUES (7, 'Tax Refund');

-- ====================================================================
-- 3. INSERT INTO Categories (10 specified items)
-- ====================================================================
INSERT INTO Categories (category_id, category_name) VALUES (1, 'Food');
INSERT INTO Categories (category_id, category_name) VALUES (2, 'Rent');
INSERT INTO Categories (category_id, category_name) VALUES (3, 'Utilities');
INSERT INTO Categories (category_id, category_name) VALUES (4, 'Transportation');
INSERT INTO Categories (category_id, category_name) VALUES (5, 'Entertainment');
INSERT INTO Categories (category_id, category_name) VALUES (6, 'Healthcare');
INSERT INTO Categories (category_id, category_name) VALUES (7, 'Shopping');
INSERT INTO Categories (category_id, category_name) VALUES (8, 'Subscription');
INSERT INTO Categories (category_id, category_name) VALUES (9, 'Insurance');
INSERT INTO Categories (category_id, category_name) VALUES (10, 'Fitness');

-- ====================================================================
-- 4. INSERT INTO Incomes (12 rows, matching user income types)
-- ====================================================================
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (101, 1, 1, 'Monthly Salary', 45000.00, TO_DATE('01-NOV-2026', 'DD-MON-YYYY'), 'Regular job monthly credit');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (102, 1, 2, 'Freelance Web Design', 12000.00, TO_DATE('05-NOV-2026', 'DD-MON-YYYY'), 'Small client landing page project');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (103, 2, 1, 'Monthly Salary', 60000.00, TO_DATE('02-NOV-2026', 'DD-MON-YYYY'), 'Tech company monthly salary');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (104, 2, 4, 'Savings Account Interest', 450.00, TO_DATE('04-NOV-2026', 'DD-MON-YYYY'), 'Quarterly bank interest payout');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (105, 3, 1, 'Monthly Salary', 38000.00, TO_DATE('03-NOV-2026', 'DD-MON-YYYY'), 'Operations job salary');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (106, 3, 6, 'Credit Card Cashback', 350.00, TO_DATE('07-NOV-2026', 'DD-MON-YYYY'), 'Reward points redeemed to statement');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (107, 4, 3, 'Tenant Rental Income', 15000.00, TO_DATE('04-NOV-2026', 'DD-MON-YYYY'), 'Monthly rent from 1BHK apartment');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (108, 5, 5, 'Quarterly Performance Bonus', 15000.00, TO_DATE('06-NOV-2026', 'DD-MON-YYYY'), 'Employee incentive payout');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (109, 6, 1, 'Monthly Salary', 50000.00, TO_DATE('06-NOV-2026', 'DD-MON-YYYY'), 'Marketing manager payroll');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (110, 7, 7, 'Income Tax Refund', 3200.00, TO_DATE('08-NOV-2026', 'DD-MON-YYYY'), 'Excess TDS refund from IT department');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (111, 8, 2, 'Content Writing Gig', 5000.00, TO_DATE('09-NOV-2026', 'DD-MON-YYYY'), 'Blog post writing assignment');
INSERT INTO Incomes (income_id, user_id, type_id, title, amount, income_date, description) VALUES (112, 9, 1, 'Monthly Salary', 55000.00, TO_DATE('10-NOV-2026', 'DD-MON-YYYY'), 'Software developer monthly wage');

-- ====================================================================
-- 5. INSERT INTO Expenses (12 rows)
-- ====================================================================
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (201, 1, 1, 'Weekly Groceries', 'Supermarket vegetables and snacks', 1800.00, TO_DATE('02-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (202, 1, 2, 'House Rent', 'Monthly apartment lease share', 9000.00, TO_DATE('05-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (203, 1, 3, 'Electricity Bill', 'State power board monthly charge', 1450.00, TO_DATE('07-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (204, 2, 2, 'Apartment Rent', 'Full house rent payment', 18000.00, TO_DATE('05-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (205, 2, 4, 'Metro & Cab Commute', 'Daily office travel pass', 2200.00, TO_DATE('08-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (206, 3, 1, 'Zomato Food Delivery', 'Weekend dinner order', 650.00, TO_DATE('06-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (207, 3, 5, 'Movie Tickets', 'Multiplex weekend show', 800.00, TO_DATE('09-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (208, 4, 7, 'Winter Jacket', 'Clothing store shopping', 3500.00, TO_DATE('07-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (209, 5, 6, 'Pharmacy Medicines', 'Doctor prescription pickup', 1200.00, TO_DATE('10-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (210, 6, 8, 'Netflix & Spotify', 'Monthly digital subscriptions', 799.00, TO_DATE('11-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (211, 7, 10, 'Gym Membership', 'Quarterly fitness center pass', 4000.00, TO_DATE('12-NOV-2026', 'DD-MON-YYYY'));
INSERT INTO Expenses (expense_id, user_id, category_id, title, description, amount, expense_date) VALUES (212, 8, 9, 'Vehicle Insurance', 'Annual comprehensive motor policy', 6500.00, TO_DATE('13-NOV-2026', 'DD-MON-YYYY'));

-- ====================================================================
-- 6. INSERT INTO Recurring_Bills (10 rows)
-- ====================================================================
INSERT INTO Recurring_Bills (bill_id, user_id, category_id, title, amount, frequency, next_due_date, is_active) VALUES (301, 1, 2, 'House Rent', 9000.00, 'MONTHLY', TO_DATE('05-DEC-2026', 'DD-MON-YYYY'), 1);
INSERT INTO Recurring_Bills (bill_id, user_id, category_id, title, amount, frequency, next_due_date, is_active) VALUES (302, 1, 3, 'Broadband Wi-Fi', 799.00, 'MONTHLY', TO_DATE('20-NOV-2026', 'DD-MON-YYYY'), 1);
INSERT INTO Recurring_Bills (bill_id, user_id, category_id, title, amount, frequency, next_due_date, is_active) VALUES (303, 2, 2, 'Apartment Rent', 18000.00, 'MONTHLY', TO_DATE('05-DEC-2026', 'DD-MON-YYYY'), 1);
INSERT INTO Recurring_Bills (bill_id, user_id, category_id, title, amount, frequency, next_due_date, is_active) VALUES (304, 2, 9, 'Health Insurance', 12000.00, 'YEARLY', TO_DATE('15-JAN-2027', 'DD-MON-YYYY'), 1);
INSERT INTO Recurring_Bills (bill_id, user_id, category_id, title, amount, frequency, next_due_date, is_active) VALUES (305, 3, 8, 'Cloud Storage', 130.00, 'MONTHLY', TO_DATE('28-NOV-2026', 'DD-MON-YYYY'), 1);
INSERT INTO Recurring_Bills (bill_id, user_id, category_id, title, amount, frequency, next_due_date, is_active) VALUES (306, 4, 3, 'Electricity Bill', 2500.00, 'MONTHLY', TO_DATE('01-DEC-2026', 'DD-MON-YYYY'), 1);
INSERT INTO Recurring_Bills (bill_id, user_id, category_id, title, amount, frequency, next_due_date, is_active) VALUES (307, 5, 10, 'Gym Subscription', 1500.00, 'MONTHLY', TO_DATE('30-NOV-2026', 'DD-MON-YYYY'), 1);
INSERT INTO Recurring_Bills (bill_id, user_id, category_id, title, amount, frequency, next_due_date, is_active) VALUES (308, 6, 8, 'OTT Streaming Bundle', 499.00, 'MONTHLY', TO_DATE('12-DEC-2026', 'DD-MON-YYYY'), 1);
INSERT INTO Recurring_Bills (bill_id, user_id, category_id, title, amount, frequency, next_due_date, is_active) VALUES (309, 7, 9, 'Car Insurance', 9500.00, 'YEARLY', TO_DATE('10-MAR-2027', 'DD-MON-YYYY'), 1);
INSERT INTO Recurring_Bills (bill_id, user_id, category_id, title, amount, frequency, next_due_date, is_active) VALUES (310, 8, 1, 'Daily Milk & Bread', 50.00, 'DAILY', TO_DATE('24-NOV-2026', 'DD-MON-YYYY'), 1);

COMMIT;
