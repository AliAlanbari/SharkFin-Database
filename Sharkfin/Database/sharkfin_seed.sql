USE sharkfin;

-- Demo user
INSERT INTO Users (name, email, password_hash, account_type)
VALUES ('Demo User', 'demo@sharkfin.com', 'HASHED_PASSWORD', 'personal');

-- Profile
INSERT INTO User_Profile (financial_preferences, security_settings, income_source, user_id)
VALUES ('{"currency":"USD","alerts":true}', '{"mfa":false}', 'Salary', 1);

-- Account
INSERT INTO Account (user_id, account_name, account_category, balance)
VALUES (1, 'Main Checking', 'Bank', 2500.00);

-- Transactions
INSERT INTO Transactions (account_id, amount, category, date, description)
VALUES
(1, 45.50, 'Groceries', '2026-02-10', 'Publix'),
(1, 1200.00, 'Rent', '2026-02-01', 'February rent');

-- Bill
INSERT INTO Bills (user_id, name, amount, due_date, frequency)
VALUES (1, 'Netflix', 15.99, '2026-02-25', 'monthly');

-- AI insight
INSERT INTO AI_Insights (user_id, insight_type, message)
VALUES (1, 'warning', 'Groceries spending is trending higher than last month.');

-- Market data sample
INSERT INTO Market_Data (symbol, asset_type, price)
VALUES ('AAPL', 'stock', 185.1234);