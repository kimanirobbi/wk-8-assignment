# wk-8-assignment
This comprehensive E-commerce database system

 E-commerce Database Management System
Overview
This project implements a complete relational database management system for an E-commerce store using MySQL. The database is designed to handle all essential aspects of an online retail business, including user management, product catalog, order processing, payments, and inventory management.

Database Schema
Core Tables
users - Customer and administrator accounts

categories - Product categorization with hierarchical support

products - Product information and inventory management

orders - Customer orders and status tracking

order_items - Individual products within orders

payments - Payment processing information

shopping_cart - User shopping carts

reviews - Product reviews and ratings system

shipping - Order shipping and delivery tracking

Relationships
One-to-One: Users ↔ Shopping Cart, Orders ↔ Payments, Orders ↔ Shipping

One-to-Many: Categories → Products, Users → Orders, Users → Reviews

Many-to-Many: Orders ↔ Products (via order_items)

Features
User authentication and profile management

Product catalog with categories 

Shopping cart functionality

Order processing with status tracking

Payment and shipping management

Review and rating system

Comprehensive inventory management

Installation
Ensure MySQL Server is installed and running

Execute the provided SQL file:

bash
mysql -u your_username -p < ecommerce_db.sql
Enter your MySQL password when prompted

Usage
After installation, the database will be ready for use with your e-commerce application. The schema includes sample data for demonstration purposes.

Sample Queries
sql
-- Get all products in a specific category
SELECT * FROM products WHERE category_id = 3;

-- Find orders for a specific user
SELECT * FROM orders WHERE user_id = 1;

-- Calculate total sales
SELECT SUM(total_amount) AS total_sales FROM orders WHERE status = 'delivered';

-- Get product reviews with user information
SELECT p.name, r.rating, r.comment, u.username 
FROM reviews r
JOIN products p ON r.product_id = p.product_id
JOIN users u ON r.user_id = u.user_id;

-- Check product inventory
SELECT name, stock_quantity FROM products WHERE stock_quantity < 10;
Constraints and Validation
The database implements comprehensive constraints including:

Primary and Foreign keys for referential integrity

Unique constraints to prevent duplicates

NOT NULL constraints for required fields

CHECK constraints for data validation (e.g., price >= 0, quantity > 0)

Default values for common fields

Comprehensive indexing for performance optimization

Maintenance
Regular maintenance tasks might include:

Backing up the database regularly

Optimizing tables periodically for performance

Reviewing and archiving old orders

Updating product inventory levels

Managing user accounts and permissions

Monitoring database performance and storage

Support
For questions or issues related to this database schema, please consult the MySQL documentation or seek assistance from a database administrator.
