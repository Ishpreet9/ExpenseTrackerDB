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
CREATE OR REPLACE FUNCTION trg_income_savings_fn()
RETURNS TRIGGER AS $$
DECLARE
    v_lock_id users.user_id%TYPE;
    v_prev    savings_history.current_savings%TYPE;
BEGIN
    -- Lock the user's row so two simultaneous inserts can't read the same balance
    SELECT user_id INTO v_lock_id
    FROM users                                                                       
    WHERE user_id = NEW.user_id
    FOR UPDATE;
                                           
    -- Latest balance for this user (0 if they have no history yet)
    SELECT COALESCE(
        (SELECT current_savings
         FROM savings_history                                                      
         WHERE user_id = NEW.user_id
         ORDER BY history_id DESC                                                                
         LIMIT 1),                                    
        0)                                                              
    INTO v_prev;

    INSERT INTO savings_history (user_id, change_type, change_amount, current_savings)
    VALUES (NEW.user_id, 'INCOME', NEW.amount, v_prev + NEW.amount);
                                                      
    RETURN NEW;                                                                
END;                                                                          
$$ LANGUAGE plpgsql;
                 
CREATE TRIGGER trg_income_savings
AFTER INSERT ON incomes
FOR EACH ROW
EXECUTE FUNCTION trg_income_savings_fn();


-- 2. Trigger to add record in Savings_history whenever Expense table gets an entry
CREATE OR REPLACE FUNCTION trg_expense_savings_fn()
RETURNS TRIGGER AS $$
DECLARE
    v_lock_id users.user_id%TYPE;
    v_prev    savings_history.current_savings%TYPE;
BEGIN
    -- Lock the user's row so two simultaneous inserts can't read the same balance
    SELECT user_id INTO v_lock_id
    FROM users                                                                       
    WHERE user_id = NEW.user_id
    FOR UPDATE;
                                           
    -- Latest balance for this user (0 if they have no history yet)
    SELECT COALESCE(
        (SELECT current_savings
         FROM savings_history                                                      
         WHERE user_id = NEW.user_id
         ORDER BY history_id DESC                                                                
         LIMIT 1),                                    
        0)                                                              
    INTO v_prev;

    INSERT INTO savings_history (user_id, change_type, change_amount, current_savings)
    VALUES (NEW.user_id, 'EXPENSE', -NEW.amount, v_prev - NEW.amount);
                                                      
    RETURN NEW;                                                                
END;                                                                          
$$ LANGUAGE plpgsql;
                 
CREATE TRIGGER trg_expense_savings
AFTER INSERT ON expenses
FOR EACH ROW
EXECUTE FUNCTION trg_expense_savings_fn();


-- Procedure to make recurring payments and update the respective entries
CREATE OR REPLACE PROCEDURE process_due_bills()
LANGUAGE plpgsql
AS $$
DECLARE
    b     RECORD;
    v_due DATE;
BEGIN
    FOR b IN
        SELECT bill_id, user_id, category_id, title, amount, frequency, next_due_date
        FROM recurring_bills
        WHERE is_active = TRUE
          AND next_due_date <= CURRENT_DATE
    LOOP
        v_due := b.next_due_date;

        -- Loop so that missed periods (e.g. job was down for 3 days) are caught up
        WHILE v_due <= CURRENT_DATE LOOP
            INSERT INTO expenses (user_id, category_id, title, description, amount, expense_date)
            VALUES (b.user_id, b.category_id, b.title,
                    'Auto-generated from recurring bill #' || b.bill_id,
                    b.amount, v_due);

            v_due := CASE b.frequency
                         WHEN 'DAILY'   THEN v_due + 1
                         WHEN 'WEEKLY'  THEN v_due + 7
                         WHEN 'MONTHLY' THEN (v_due + INTERVAL '1 month')::date
                         WHEN 'YEARLY'  THEN (v_due + INTERVAL '1 year')::date
                     END;
        END LOOP;

        UPDATE recurring_bills
        SET next_due_date = v_due
        WHERE bill_id = b.bill_id;
    END LOOP;

    COMMIT;
END;
$$;

-- Runs everyday at 00:05:00
CREATE EXTENSION pg_cron;

SELECT cron.schedule(
    'job_process_due_bills',
    '5 0 * * *',
    'CALL process_due_bills()'
);

