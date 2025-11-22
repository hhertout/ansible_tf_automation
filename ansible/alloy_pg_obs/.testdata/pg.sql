-- Create test table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'active'
);

-- Insert 10000 test records
INSERT INTO users (username, email, status)
SELECT
    'user_' || generate_series,
    'user_' || generate_series || '@example.com',
    CASE 
        WHEN generate_series % 3 = 0 THEN 'inactive'
        WHEN generate_series % 5 = 0 THEN 'pending'
        ELSE 'active'
    END
FROM generate_series(1, 10000);

-- Create some indexes for testing
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Run some test queries to generate stats
SELECT COUNT(*) FROM users WHERE status = 'active';
SELECT * FROM users WHERE email LIKE '%1000%';
SELECT status, COUNT(*) FROM users GROUP BY status;