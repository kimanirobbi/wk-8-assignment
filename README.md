# wk-8-assignment
This comprehensive E-commerce database system

Key Features:
User Management - Customers and administrators

Product Catalog - Categories, products, and images

Order Processing - Orders, order items, and payment tracking

Shopping Experience - Shopping carts and wishlists

Customer Engagement - Reviews and ratings system

Marketing Tools - Coupons and discounts

Shipping & Logistics - Order tracking and delivery management

Relationship Types:
One-to-One: Users ↔ Shopping Cart, Users ↔ Wishlist, Orders ↔ Payments, Orders ↔ Shipping

One-to-Many: Categories → Products, Users → Orders, Users → Reviews

Many-to-Many: Orders ↔ Products (via order_items), Wishlists ↔ Products (via wishlist_items)

Constraints Applied:
Primary Keys on all tables

Foreign Keys for referential integrity

Unique constraints where appropriate

NOT NULL for required fields

CHECK constraints for data validation

Default values and auto-increment IDs

Comprehensive indexing for performance

The database is ready for production use and includes sample data for demonstration purposes.
