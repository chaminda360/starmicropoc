-- MySQL initialization script for Starline services
-- This script creates and configures both service databases and populates them with sample data

-- Starline Service Database Setup
CREATE DATABASE IF NOT EXISTS starline_service_db;
GRANT ALL PRIVILEGES ON starline_service_db.* TO 'root'@'%';
FLUSH PRIVILEGES;

-- Starline Stock Database Setup
CREATE DATABASE IF NOT EXISTS starline_stock_db;
GRANT ALL PRIVILEGES ON starline_stock_db.* TO 'root'@'%';
FLUSH PRIVILEGES;

-- Configure Starline Service Database
USE starline_service_db;

-- Users table: Stores user information
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each user
    name VARCHAR(255) NOT NULL,                -- User's full name
    email VARCHAR(255) UNIQUE NOT NULL,        -- User's email (unique constraint)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Account creation timestamp
);

-- Orders table: Tracks user orders
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each order
    user_id INT NOT NULL,                      -- References users.id
    product_name VARCHAR(255) NOT NULL,        -- Name of the ordered product
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Order creation timestamp
    FOREIGN KEY (user_id) REFERENCES users(id) -- Ensures referential integrity
);

-- Sample user data
INSERT INTO users (name, email) VALUES
('John Doe', 'john.doe@example.com'),    -- Test user 1
('Jane Smith', 'jane.smith@example.com'); -- Test user 2

-- Sample order data
INSERT INTO orders (user_id, product_name) VALUES
(1, 'Satellite A'),  -- Order for John Doe
(2, 'Satellite B');  -- Order for Jane Smith

-- Configure Starline Stock Database
USE starline_stock_db;

-- Products table: Stores product inventory
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each product
    name VARCHAR(255) NOT NULL,                -- Product name
    price DECIMAL(10, 2) NOT NULL,            -- Product price (supports 2 decimal places)
    stock INT NOT NULL,                        -- Current stock quantity
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Product creation timestamp
);

-- Transactions table: Tracks stock movements
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each transaction
    product_id INT NOT NULL,                   -- References products.id
    quantity INT NOT NULL,                     -- Transaction quantity (+ve for in, -ve for out)
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Transaction timestamp
    FOREIGN KEY (product_id) REFERENCES products(id)  -- Ensures referential integrity
);

-- Sample product data
INSERT INTO products (name, price, stock) VALUES
('Satellite A', 1000.00, 50),  -- Product 1 with initial stock
('Satellite B', 1500.00, 30);  -- Product 2 with initial stock

-- Sample transaction data
INSERT INTO transactions (product_id, quantity) VALUES
(1, 5),  -- Stock movement for Satellite A
(2, 3);  -- Stock movement for Satellite B
