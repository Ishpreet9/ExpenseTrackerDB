-- 1. Users Table
-- Stores registered user profiles, contact emails, and account creation dates.
CREATE TABLE Users (
    user_id    NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1000 INCREMENT BY 1) PRIMARY KEY,
    full_name  VARCHAR2(100) NOT NULL,
    email      VARCHAR2(100) NOT NULL UNIQUE,
    created_at DATE DEFAULT SYSDATE
);

-- 2. Income_Types Table
-- Lookup table defining sources of income (e.g., Salary, Freelance, Dividends).
CREATE TABLE Income_Types (
    type_id   NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    type_name VARCHAR2(50) NOT NULL UNIQUE
);

-- 3. Categories Table
-- Lookup table defining spending categories (e.g., Food, Rent, Utilities).
CREATE TABLE Categories (
    category_id   NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    category_name VARCHAR2(50) NOT NULL UNIQUE
);

-- 4. Incomes Table
-- Records individual income transactions earned by users.
CREATE TABLE Incomes (
    income_id   NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 2000 INCREMENT BY 1) PRIMARY KEY,
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
    expense_id   NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 3000 INCREMENT BY 1) PRIMARY KEY,
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
    history_id      NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 4000 INCREMENT BY 1) PRIMARY KEY,
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
    bill_id       NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 5000 INCREMENT BY 1) PRIMARY KEY,
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