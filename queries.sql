-- 1. Basic SELECT and filtering

-- 1.1 Display all users
SELECT * FROM Users;

-- 1.2 Display all incomes
SELECT * FROM Incomes;

-- 1.3 Display all expenses
SELECT * FROM Expenses;

-- 1.4 Display all categories
SELECT * FROM Categories;

-- 1.5 Display all income types
SELECT * FROM Income_Types;

-- 1.6 Display all recurring bills
SELECT * FROM Recurring_Bills;

-- 1.7 Display user names and email addresses
SELECT full_name, email FROM Users;

-- 1.8 Find expenses above ■2,000
SELECT * FROM Expenses WHERE amount >2000;

-- 1.9 Find expenses between ■1,000 and ■5,000
SELECT * FROM Expenses WHERE amount BETWEEN 1000 AND 5000;

-- 1.10 Find expenses in selected categories
SELECT * FROM Expenses WHERE category_id IN (1, 3, 5);

-- 1.11 Find names starting with A
SELECT * FROM Users WHERE full_name LIKE 'A%';

-- 1.12 Sort expenses from highest to lowest
SELECT * FROM Expenses ORDER BY amount DESC;

-- 1.13 Display the five highest expenses
SELECT * FROM Expenses ORDER BY amount DESC LIMIT 5;

-- 1.14 Display the latest five income records
SELECT * FROM Incomes ORDER BY income_date DESC LIMIT 5;

-- 1.15 Find a user by email
SELECT * FROM Users WHERE email ='rahul@gmail.com';

-- 2. Aggregate functions and grouping

-- 2.1 Total income
SELECT SUM(amount) AS total_income FROM Incomes;

-- 2.2 Total expenses
SELECT SUM(amount) AS total_expenses FROM Expenses;

-- 2.3 Average expense
SELECT AVG(amount) AS average_expense FROM Expenses;

-- 2.4 Highest expense
SELECT MAX(amount) AS highest_expense FROM Expenses;

-- 2.5 Lowest expense
SELECT MIN(amount) AS lowest_expense FROM Expenses;

-- 2.6 Count users
SELECT COUNT(*) AS total_users FROM Users;

-- 2.7 Count income records
SELECT COUNT(*) AS total_income_records FROM
Incomes;

-- 2.8 Count expense records
SELECT COUNT(*) AS total_expense_records FROM
Expenses;

-- 2.9 Total income per user
SELECT user_id, SUM(amount) AS total_income
FROM Incomes GROUP BY user_id;

-- 2.10 Total expenses per user
SELECT user_id, SUM(amount) AS
total_expenses FROM Expenses GROUP BY user_id;

-- 2.11 Count expenses in each category
SELECT category_id, COUNT(*) AS
expense_count FROM Expenses GROUP BY category_id;

-- 2.12 Categories with total expenses above ■5,000
SELECT category_id,
SUM(amount) AS total_expenses FROM Expenses GROUP BY category_id 
HAVING SUM(amount) > 5000;

-- 3. JOIN queries

-- 3.1 Users with their income records
SELECT u.full_name,i.title, i.amount, i.income_date FROM Users u 
INNER JOIN Incomes i ON u.user_id = i.user_id;

-- 3.2 Users with their expense records
SELECT u.full_name, e.title,e.amount, e.expense_date FROM Users u 
INNER JOIN Expenses e ON u.user_id = e.user_id;

-- 3.3 Expenses with category names
SELECT e.title, c.category_name,e.amount FROM Expenses e 
INNER JOIN Categories c ON e.category_id =c.category_id;

-- 3.4 Incomes with income type names
SELECT i.title, t.type_name, i.amount FROM Incomes i 
INNER JOIN Income_Types t ON i.type_id = t.type_id;

-- 3.5 Recurring bills with user and category names
SELECT u.full_name,r.title, c.category_name, r.amount, r.frequency FROM Recurring_Bills r
JOIN Users u ON r.user_id = u.user_id JOIN Categories c ON r.category_id = c.category_id;

-- 3.6 All users, including those without income (LEFT JOIN)
SELECT u.full_name, i.title, i.amount FROM Users u 
LEFT JOIN Incomes i ON u.user_id = i.user_id;

-- 3.7 Users who have never recorded an expense
SELECT u.* FROM Users u
LEFT JOIN Expenses e ON u.user_id = e.user_id 
WHERE e.expense_id IS NULL;

-- 3.8 Detailed expense report
SELECT u.full_name, e.title,c.category_name, e.amount, e.expense_date FROM Users u 
JOIN Expenses e ON u.user_id = e.user_id JOIN Categories c ON e.category_id = c.category_id 
ORDER BY e.expense_date DESC;

-- 3.9 Detailed income report
SELECT u.full_name, i.title, t.type_name, i.amount, i.income_date FROM Users u 
JOIN Incomes i ON u.user_id = i.user_id 
JOIN Income_Types t ON i.type_id = t.type_id;


-- 4. Subqueries — basic and advanced A subquery is a SELECT statement

-- 4.1 Find the highest expense record
SELECT * FROM Expenses WHERE amount = (SELECT MAX(amount) FROM Expenses);

-- 4.2 Find expenses above the average expense
SELECT * FROM Expenses WHERE amount > (SELECT AVG(amount) FROM Expenses);

-- 4.3 Find users who have recorded at least one income
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM Incomes);

-- 4.4 Find users who have both income and expenses
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM Incomes) AND user_id IN (SELECT user_id FROM Expenses);

-- 4.5 Find the second-highest expense amount
SELECT MAX(amount) AS second_highest_expense FROM Expenses WHERE amount < (SELECT MAX(amount)FROM Expenses);

-- 4.6 Find users whose total income is greater than the average individual income amount
SELECT * FROM Users WHERE user_id IN ( SELECT user_id FROM Incomes GROUP BY user_id HAVING SUM(amount) > (SELECT AVG(amount) FROM Incomes) );

-- 4.7 Find users whose total expenses are greater than their total income
SELECT u.user_id, u.full_name FROM Users u WHERE (SELECT COALESCE(SUM(amount), 0) FROM Expenses e 
WHERE e.user_id = u.user_id) > (SELECT COALESCE(SUM(amount), 0) FROM Incomes i WHERE i.user_id = u.user_id);

-- 4.8 Find users who have never added a recurring bill
SELECT * FROM Users
WHERE NOT EXISTS ( SELECT 1 FROM Recurring_Bills r WHERE r.user_id = Users.user_id );

-- 4.9 Find the highest expense in each category
SELECT e.* FROM Expenses e
WHERE e.amount = ( SELECT MAX(e2.amount) FROM Expenses e2 
WHERE e2.category_id = e.category_id );


-- 5. Date-based queries

-- 5.1 Today's expenses
SELECT * FROM Expenses WHERE expense_date = CURRENT_DATE;

-- 5.2 Expenses from the current month
SELECT * FROM Expenses
WHERE expense_date >= date_trunc('month', CURRENT_DATE)
  AND expense_date <  date_trunc('month', CURRENT_DATE) + INTERVAL '1 month';

-- 5.3 Monthly income
SELECT EXTRACT(YEAR FROM income_date)::int  AS year,
       EXTRACT(MONTH FROM income_date)::int AS month,
       SUM(amount) AS monthly_income
FROM Incomes
GROUP BY 1, 2
ORDER BY 1, 2;

-- 5.4 Monthly expenses
SELECT EXTRACT(YEAR FROM expense_date)::int  AS year,
       EXTRACT(MONTH FROM expense_date)::int AS month,
       SUM(amount) AS monthly_expenses
FROM Expenses
GROUP BY 1, 2
ORDER BY 1, 2;

-- 5.5 Expenses from the last seven days
SELECT * FROM Expenses
WHERE expense_date BETWEEN CURRENT_DATE - INTERVAL '7 days' AND CURRENT_DATE;

-- 5.6 Upcoming active bills due in seven days
SELECT * FROM Recurring_Bills
WHERE next_due_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
  AND is_active = 1;

-- 5.7 Overdue active bills
SELECT * FROM Recurring_Bills
WHERE next_due_date < CURRENT_DATE
  AND is_active = 1;


-- 6. Views

-- 6.1 Create a detailed expense view
CREATE VIEW Expense_Report AS 
SELECT u.full_name, e.title, c.category_name, e.amount, e.expense_date FROM Expenses e 
JOIN Users u ON e.user_id = u.user_id
JOIN Categories c ON e.category_id = c.category_id;

-- 6.2 Display the expense view
SELECT * FROM Expense_Report;

-- 6.3 Create an income report view
CREATE VIEW Income_Report AS 
SELECT u.full_name, i.title, t.type_name, i.amount, i.income_date FROM Incomes i 
JOIN Users u ON i.user_id = u.user_id JOIN Income_Types t ON i.type_id = t.type_id;

-- 6.4 Display the income view
SELECT * FROM Income_Report;


-- 7. DISTINCT queries

-- 7.1 Display unique user IDs from expenses
SELECT DISTINCT user_id FROM Expenses;

-- 7.2 Display unique expense category IDs
SELECT DISTINCT category_id FROM Expenses;

-- 7.3 Display unique income type IDs
SELECT DISTINCT type_id FROM Incomes;

-- 7.4 Display unique bill frequencies
SELECT DISTINCT frequency FROM Recurring_Bills;


-- 8. String functions

-- 8.1 Display user names in uppercase
SELECT UPPER(full_name) AS uppercase_name FROM Users;

-- 8.2 Display user names in lowercase
SELECT LOWER(full_name) AS lowercase_name FROM Users;

-- 8.3 Display the length of each user's name
SELECT full_name, LENGTH(full_name) AS name_length FROM Users;

-- 8.4 Combine user's name and email
SELECT CONCAT(full_name, ' - ', email) AS user_details FROM Users;

-- 8.5 Extract the first three characters of user names
SELECT SUBSTRING(full_name, 1, 3) AS short_name FROM Users;

-- 8.6 Remove extra spaces from names
SELECT TRIM(full_name) AS cleaned_name FROM Users;

-- 8.7 Display the first two characters of each name
SELECT LEFT(full_name, 2) AS first_two_characters FROM Users;

-- 8.8 Display the last two characters of each name
SELECT RIGHT(full_name, 2) AS last_two_characters FROM Users;

-- 8.9 Replace a word in a string
SELECT REPLACE(full_name, 'Rahul', 'Rohit') AS modified_name FROM Users;


-- 9. Numeric functions

-- 9.1 Round expense amounts to two decimal places
SELECT ROUND(amount, 2) AS rounded_amount FROM Expenses;

-- 9.2 Display absolute values of expense amounts
SELECT ABS(amount) AS absolute_amount FROM Expenses;

-- 9.3 Round expense amounts upward
SELECT CEILING(amount) AS rounded_up_amount FROM Expenses;

-- 9.4 Round expense amounts downward
SELECT FLOOR(amount) AS rounded_down_amount FROM Expenses;

-- 9.5 Find the remainder of expense amounts divided by 2
SELECT amount, MOD(amount, 2) AS remainder FROM Expenses;


-- 10. NULL handling functions

-- 10.1 Replace NULL values in descriptions with 'No Description'
SELECT title, IFNULL(description, 'No Description') AS description
FROM Expenses;

-- 10.2 Replace NULL values using COALESCE
SELECT title, COALESCE(description, 'Not Available') AS description
FROM Incomes;

-- 10.3 Return NULL if amount is zero
SELECT amount, NULLIF(amount, 0) AS result
FROM Expenses;


-- 11. CROSS JOIN and SELF JOIN

-- 11.1 Display all possible combinations of users and categories
SELECT u.full_name, c.category_name
FROM Users u
CROSS JOIN Categories c;

-- 11.2 Compare users with other users using SELF JOIN
SELECT u1.full_name AS user_one, u2.full_name AS user_two
FROM Users u1
JOIN Users u2
ON u1.user_id < u2.user_id;