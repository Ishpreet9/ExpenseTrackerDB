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
SELECT * FROM Expenses WHERE expense_date = CURDATE();

-- 5.2 Expenses from the current month
SELECT * FROM Expenses WHERE MONTH(expense_date) = MONTH(CURDATE()) AND YEAR(expense_date) = YEAR(CURDATE());

-- 5.3 Monthly income
SELECT YEAR(income_date) AS year, MONTH(income_date) AS month, SUM(amount) AS monthly_income FROM Incomes 
GROUP BY YEAR(income_date), MONTH(income_date) ORDER BY year, month;

-- 5.4 Monthly expenses
SELECT YEAR(expense_date) AS year, MONTH(expense_date) AS month, SUM(amount) AS monthly_expenses FROM Expenses 
GROUP BY YEAR(expense_date), MONTH(expense_date) ORDER BY year, month;

-- 5.5 Expenses from the last seven days
SELECT * FROM Expenses WHERE expense_date BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE();

-- 5.6 Upcoming active bills due in seven days
SELECT * FROM Recurring_Bills WHERE next_due_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY AND is_active = 1;

-- 5.7 Overdue active bills
SELECT * FROM Recurring_Bills WHERE next_due_date < CURDATE() AND is_active = 1;



-- 6. Project-specific expense and savings reports

-- 6.1 Calculate each user's income, expenses and savings
 SELECT u.user_id, u.full_name,
 COALESCE(i.total_income, 0) AS total_income,
 COALESCE(e.total_expenses, 0) AS total_expenses,
 COALESCE(i.total_income, 0) - COALESCE(e.total_expenses, 0) AS savings 
 FROM Users u 
 LEFT JOIN (SELECT user_id, SUM(amount) AS total_income FROM Incomes GROUP BY user_id) i 
 ON u.user_id = i.user_id 
 LEFT JOIN (SELECT user_id, SUM(amount) AS total_expenses FROM Expenses GROUP BY user_id) e 
 ON u.user_id = e.user_id;

-- 6.2 Find the category with the highest total spending
SELECT c.category_name, SUM(e.amount) AS total_spending FROM Categories c 
JOIN Expenses e ON c.category_id = e.category_id 
GROUP BY c.category_id, c.category_name 
ORDER BY total_spending DESC LIMIT 1;

-- 6.3 Find the income source generating the highest income
SELECT t.type_name, SUM(i.amount) AS total_income FROM Income_Types t 
JOIN Incomes i ON t.type_id = i.type_id 
GROUP BY t.type_id, t.type_name 
ORDER BY total_income DESC LIMIT 1;

-- 6.4 Classify expenses by amount
SELECT title, amount, 
CASE WHEN amount < 500 THEN 'Low Expense' 
WHEN amount <= 2000 THEN 'Medium Expense' 
ELSE 'High Expense' 
END AS expense_level FROM Expenses;

-- 6.5 Display active and inactive recurring bills
SELECT title, amount,
CASE WHEN is_active = 1 THEN 'Active' 
ELSE 'Inactive' END AS bill_status
FROM Recurring_Bills;


-- 7. INSERT, UPDATE and DELETE

-- 7.1 Add a new user
INSERT INTO Users (full_name, email) VALUES ('Karan Singh', 'karan@gmail.com');

-- 7.2 Add a new income record
INSERT INTO Incomes (user_id, type_id, title, amount, description) VALUES (1, 1, 'Bonus', 5000, 'Festival bonus');

-- 7.3 Add a new expense record
INSERT INTO Expenses (user_id, category_id, title, amount, description) VALUES (1, 1, 'Dinner', 800, 'Dinner with friends');

-- 7.4 Update a user's email 
UPDATE Users SET email = 'rahul_new@gmail.com' WHERE user_id = 1;

-- 7.5 Update an expense amount 
UPDATE Expenses SET amount = 2000 WHERE expense_id = 1;

-- 7.6 Deactivate a recurring bill
UPDATE Recurring_Bills SET is_active = 0 WHERE bill_id = 1;

-- 7.7 Delete an expense
DELETE FROM Expenses WHERE expense_id = 1;


-- 8. Views

-- 8.1 Create a detailed expense view
CREATE VIEW Expense_Report AS 
SELECT u.full_name, e.title, c.category_name, e.amount, e.expense_date FROM Expenses e 
JOIN Users u ON e.user_id = u.user_id
JOIN Categories c ON e.category_id = c.category_id;

-- 8.2 Display the expense view
SELECT * FROM Expense_Report;

-- 8.3 Create an income report view
CREATE VIEW Income_Report AS 
SELECT u.full_name, i.title, t.type_name, i.amount, i.income_date FROM Incomes i 
JOIN Users u ON i.user_id = u.user_id JOIN Income_Types t ON i.type_id = t.type_id;

-- 8.4 Display the income view
SELECT * FROM Income_Report;


-- 9. Stored procedures A stored procedure is a saved group of SQL

-- A stored procedure is a saved group of SQL statements that can be executed using CALL. MySQL requires DELIMITER to define a procedure containing BEGIN and END.



-- 9.1 Procedure to display a user's expenses
DELIMITER //

CREATE PROCEDURE GetUserExpenses(IN p_user_id INT) 
BEGIN 
SELECT e.expense_id, e.title, c.category_name, e.amount, e.expense_date FROM Expenses e 
JOIN Categories c ON e.category_id = c.category_id WHERE e.user_id = p_user_id; 
END //

DELIMITER ;

CALL GetUserExpenses(1);

-- 9.2 Procedure to calculate a user's total income
DELIMITER //

CREATE PROCEDURE GetTotalIncome(IN p_user_id INT) 
BEGIN 
SELECT COALESCE(SUM(amount), 0) AS total_income FROM Incomes WHERE user_id = p_user_id; 
END //

DELIMITER ;

CALL GetTotalIncome(1);

-- 9.3 Procedure to calculate a user's savings
DELIMITER //

CREATE PROCEDURE GetUserSavings(IN p_user_id INT) 
BEGIN 
SELECT u.full_name, COALESCE((SELECT SUM(amount) FROM Incomes WHERE user_id = u.user_id), 0) - COALESCE((SELECT SUM(amount) FROM Expenses WHERE 
user_id = u.user_id), 0) AS total_savings FROM Users u WHERE u.user_id = p_user_id;
END //

DELIMITER ;

CALL GetUserSavings(1);

-- 9.4 Procedure to display expenses within a date range
DELIMITER //

CREATE PROCEDURE GetExpensesByDate( IN p_user_id INT, IN p_start_date DATE, IN p_end_date DATE )
BEGIN 
SELECT * FROM Expenses WHERE user_id = p_user_id AND expense_date BETWEEN p_start_date AND p_end_date 
ORDER BY expense_date; 
END //

DELIMITER ;

CALL GetExpensesByDate(1, '2026-11-01', '2026-11-30');

-- 10. Transactions



-- 10.1 COMMIT example
START TRANSACTION; 
INSERT INTO Expenses (user_id, category_id, title, amount) VALUES (1, 1, 'Test Expense', 500); 
COMMIT;

-- 10.2 ROLLBACK example
START TRANSACTION; 
INSERT INTO Expenses (user_id, category_id, title, amount) VALUES (1, 1, 'Temporary Expense', 1000);
ROLLBACK;

-- 10.3 SAVEPOINT example
START TRANSACTION; 
INSERT INTO Expenses (user_id, category_id, title, amount) VALUES (1, 1, 'Expense One', 500); 
SAVEPOINT before_second_insert; 
INSERT INTO Expenses (user_id, category_id, title, amount) VALUES (1, 2, 'Expense Two', 700); 
ROLLBACK TO SAVEPOINT before_second_insert; 
COMMIT;
