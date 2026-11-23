-- 1. Users Table
-- Stores registered user profiles, contact emails, and account creation dates.
CREATE TABLE Users (
    user_id    NUMBER PRIMARY KEY,
    full_name  VARCHAR2(100) NOT NULL,
    email      VARCHAR2(100) NOT NULL UNIQUE,
    created_at DATE DEFAULT SYSDATE
);

-- 2. Income_Types Table
-- Lookup table defining sources of income (e.g., Salary, Freelance, Dividends).
CREATE TABLE Income_Types (
    type_id   NUMBER PRIMARY KEY,
    type_name VARCHAR2(50) NOT NULL UNIQUE
);

-- 3. Categories Table
-- Lookup table defining spending categories (e.g., Food, Rent, Utilities).
CREATE TABLE Categories (
    category_id   NUMBER PRIMARY KEY,
    category_name VARCHAR2(50) NOT NULL UNIQUE
);

-- 4. Incomes Table
-- Records individual income transactions earned by users.
CREATE TABLE Incomes (
    income_id   NUMBER PRIMARY KEY,
    user_id     NUMBER NOT NULL,
    type_id     NUMBER NOT NULL,
    title       VARCHAR2(100) NOT NULL,
    amount      NUMBER(10, 2) NOT NULL CHECK (amount > 0),
    income_date DATE DEFAULT SYSDATE,
    description VARCHAR2(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (type_id) REFERENCES Income_Types(type_id)
);

-- 5. Expenses Table
-- Logs individual spending transactions made by users.
CREATE TABLE Expenses (
    expense_id   NUMBER PRIMARY KEY,
    user_id      NUMBER NOT NULL,
    category_id  NUMBER NOT NULL,
    title        VARCHAR2(100) NOT NULL,
    description  VARCHAR2(255),
    amount       NUMBER(10, 2) NOT NULL CHECK (amount > 0),
    expense_date DATE DEFAULT SYSDATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- 6. Savings_History Table
-- Tracks each user's running savings balance, updated via triggers.
CREATE TABLE Savings_History (
    history_id      NUMBER PRIMARY KEY,
    user_id         NUMBER NOT NULL,
    change_type     VARCHAR2(20) NOT NULL,
    change_amount   NUMBER(10, 2) NOT NULL,
    current_savings NUMBER(12, 2) NOT NULL,
    updated_at      DATE DEFAULT SYSDATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 7. Recurring_Bills Table
-- Stores scheduled repeating bills with due dates and active status (0 or 1).
CREATE TABLE Recurring_Bills (
    bill_id       NUMBER PRIMARY KEY,
    user_id       NUMBER NOT NULL,
    category_id   NUMBER NOT NULL,
    title         VARCHAR2(100) NOT NULL,
    amount        NUMBER(10, 2) NOT NULL CHECK (amount > 0),
    frequency     VARCHAR2(20) NOT NULL CHECK (frequency IN ('DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY')),
    next_due_date DATE NOT NULL,
    is_active     NUMBER(1) DEFAULT 1 CHECK (is_active IN (0, 1)),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Triggers

-- 1. Trigger to add record in Savings_History whenever Incomes gets an entry
CREATE OR REPLACE TRIGGER trg_income_savings
AFTER INSERT ON Incomes
FOR EACH ROW
DECLARE
    v_lock_id Users.user_id%TYPE;
    v_prev    Savings_History.current_savings%TYPE;
BEGIN
    -- Lock the user's row so two simultaneous inserts can't read the same balance
    SELECT user_id INTO v_lock_id
    FROM Users
    WHERE user_id = :NEW.user_id
    FOR UPDATE;
 
    -- Latest balance for this user (0 if they have no history yet)
    SELECT NVL(MAX(current_savings) KEEP (DENSE_RANK LAST ORDER BY history_id), 0)
    INTO v_prev
    FROM Savings_History
    WHERE user_id = :NEW.user_id;
 
    INSERT INTO Savings_History (user_id, change_type, change_amount, current_savings)
    VALUES (:NEW.user_id, 'INCOME', :NEW.amount, v_prev + :NEW.amount);
END;
/

-- 2. Trigger to add record in Savings_history whenever Expense table gets an entry
CREATE OR REPLACE TRIGGER trg_expense_savings
AFTER INSERT ON Expenses
FOR EACH ROW
DECLARE
    v_lock_id Users.user_id%TYPE;
    v_prev    Savings_History.current_savings%TYPE;
BEGIN
    SELECT user_id INTO v_lock_id
    FROM Users
    WHERE user_id = :NEW.user_id
    FOR UPDATE;
 
    SELECT NVL(MAX(current_savings) KEEP (DENSE_RANK LAST ORDER BY history_id), 0)
    INTO v_prev
    FROM Savings_History
    WHERE user_id = :NEW.user_id;
 
    INSERT INTO Savings_History (user_id, change_type, change_amount, current_savings)
    VALUES (:NEW.user_id, 'EXPENSE', -:NEW.amount, v_prev - :NEW.amount);
END;
/

-- Procedure to make recurring payments and update the respective entries
CREATE OR REPLACE PROCEDURE process_due_bills AS
    v_due DATE;
BEGIN
    FOR b IN (
        SELECT bill_id, user_id, category_id, title, amount, frequency, next_due_date
        FROM Recurring_Bills
        WHERE is_active = 1
          AND next_due_date <= TRUNC(SYSDATE)
    ) LOOP
        v_due := b.next_due_date;
 
        -- Loop so that missed periods (e.g. job was down for 3 days) are caught up
        WHILE v_due <= TRUNC(SYSDATE) LOOP
            INSERT INTO Expenses (user_id, category_id, title, description, amount, expense_date)
            VALUES (b.user_id, b.category_id, b.title,
                    'Auto-generated from recurring bill #' || b.bill_id,
                    b.amount, v_due);
 
            v_due := CASE b.frequency
                         WHEN 'DAILY'   THEN v_due + 1
                         WHEN 'WEEKLY'  THEN v_due + 7
                         WHEN 'MONTHLY' THEN ADD_MONTHS(v_due, 1)
                         WHEN 'YEARLY'  THEN ADD_MONTHS(v_due, 12)
                     END;
        END LOOP;
 
        UPDATE Recurring_Bills
        SET next_due_date = v_due
        WHERE bill_id = b.bill_id;
    END LOOP;
 
    COMMIT;
END process_due_bills;
/

-- Runs everyday at 00:05:00
BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'JOB_PROCESS_DUE_BILLS',
        job_type        => 'STORED_PROCEDURE',
        job_action      => 'PROCESS_DUE_BILLS',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY;BYHOUR=0;BYMINUTE=5;BYSECOND=0',
        enabled         => TRUE
    );
END;
/