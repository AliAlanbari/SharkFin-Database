

CREATE DATABASE IF NOT EXISTS sharkfin;
USE sharkfin;

-- Drop tables in dependency order (safe rebuild)
DROP TABLE IF EXISTS Market_Data;
DROP TABLE IF EXISTS AI_Insights;
DROP TABLE IF EXISTS Tax_Records;
DROP TABLE IF EXISTS Goals;
DROP TABLE IF EXISTS Dividends;
DROP TABLE IF EXISTS Portfolio_Benchmarks;
DROP TABLE IF EXISTS Investments;
DROP TABLE IF EXISTS Bills;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS User_Profile;
DROP TABLE IF EXISTS Users;

-- -------------------------
-- Users
-- -------------------------
CREATE TABLE Users (
  user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  account_type ENUM('personal','family','joint','business') NOT NULL DEFAULT 'personal',
  create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------
-- User_Profile
-- -------------------------
CREATE TABLE User_Profile (
  profile_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  financial_preferences TEXT NULL,
  security_settings TEXT NULL,
  income_source VARCHAR(120) NULL,
  user_id BIGINT NOT NULL,
  CONSTRAINT fk_user_profile_user
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_user_profile_user_id ON User_Profile(user_id);

-- -------------------------
-- Account
-- -------------------------
CREATE TABLE Account (
  account_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  account_name VARCHAR(120) NOT NULL,
  account_category VARCHAR(60) NULL,
  balance DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  CONSTRAINT fk_account_user
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_account_user_id ON Account(user_id);

-- -------------------------
-- Transactions
-- -------------------------
CREATE TABLE Transactions (
  transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_id BIGINT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  category VARCHAR(80) NOT NULL,
  date DATE NOT NULL,
  description VARCHAR(255) NULL,
  CONSTRAINT fk_transactions_account
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_transactions_account_date ON Transactions(account_id, date);

-- -------------------------
-- Bills
-- -------------------------
CREATE TABLE Bills (
  bill_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  name VARCHAR(120) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  due_date DATE NOT NULL,
  frequency VARCHAR(40) NOT NULL,
  CONSTRAINT fk_bills_user
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_bills_user_duedate ON Bills(user_id, due_date);

-- -------------------------
-- Investments
-- -------------------------
CREATE TABLE Investments (
  investment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  asset_type ENUM('stock','real_estate','forex') NOT NULL,
  symbol VARCHAR(20) NULL,
  quantity DECIMAL(14,4) NULL,
  current_value DECIMAL(14,2) NULL,
  CONSTRAINT fk_investments_user
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_investments_user ON Investments(user_id);

-- -------------------------
-- Portfolio_Benchmarks
-- -------------------------
CREATE TABLE Portfolio_Benchmarks (
  benchmark_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  portfolio_return DECIMAL(8,4) NOT NULL,
  benchmark_return DECIMAL(8,4) NOT NULL,
  comparison_date DATE NOT NULL,
  CONSTRAINT fk_benchmarks_user
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_benchmarks_user_date ON Portfolio_Benchmarks(user_id, comparison_date);

-- -------------------------
-- Dividends
-- -------------------------
CREATE TABLE Dividends (
  dividend_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  investment_id BIGINT NOT NULL,
  ex_dividend_date DATE NOT NULL,
  dividend_amount DECIMAL(12,2) NOT NULL,
  CONSTRAINT fk_dividends_investment
    FOREIGN KEY (investment_id) REFERENCES Investments(investment_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_dividends_investment_date ON Dividends(investment_id, ex_dividend_date);

-- -------------------------
-- Goals
-- -------------------------
CREATE TABLE Goals (
  goal_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  target_amount DECIMAL(12,2) NOT NULL,
  current_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  deadline DATE NOT NULL,
  CONSTRAINT fk_goals_user
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_goals_user_deadline ON Goals(user_id, deadline);

-- -------------------------
-- Tax_Records
-- -------------------------
CREATE TABLE Tax_Records (
  tax_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  deductible_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  estimated_tax DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  year INT NOT NULL,
  CONSTRAINT fk_tax_user
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_tax_user_year ON Tax_Records(user_id, year);

-- -------------------------
-- AI_Insights
-- -------------------------
CREATE TABLE AI_Insights (
  insight_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  insight_type ENUM('prediction','warning','tip') NOT NULL,
  message VARCHAR(500) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ai_insights_user
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
    ON DELETE CASCADE
);

CREATE INDEX idx_ai_user_time ON AI_Insights(user_id, created_at);

-- -------------------------
-- Market_Data
-- -------------------------
CREATE TABLE Market_Data (
  market_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  symbol VARCHAR(20) NOT NULL,
  asset_type ENUM('stock','real_estate','forex') NOT NULL,
  price DECIMAL(14,4) NOT NULL,
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_market_symbol_time ON Market_Data(symbol, timestamp);