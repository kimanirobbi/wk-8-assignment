/* E-commerce database manangment system */
/* created by robbi kiarie */

create database ecommercedb;
use ecommercedb;

/*user table(customer & administrators) */
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    town VARCHAR(50),
    county VARCHAR(50),
    country VARCHAR(50) DEFAULT 'kenya',
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_username (username)
);

/*cartegories table*/
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id)
        REFERENCES categories (category_id)
        ON DELETE SET NULL,
    INDEX idx_category_name (name)
);

/*Products table*/
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10 , 2 ) NOT NULL CHECK (price >= 0),
    sale_price DECIMAL(10 , 2 ) CHECK (sale_price >= 0),
    sku VARCHAR(100) UNIQUE NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    category_id INT NOT NULL,
    brand VARCHAR(100),
    weight DECIMAL(8 , 2 ),
    dimensions VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
        ON DELETE RESTRICT,
    INDEX idx_product_name (name),
    INDEX idx_sku (sku),
    INDEX idx_category (category_id),
    INDEX idx_price (price)
);

/*Orders table*/
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    shipping_address TEXT NOT NULL,
    billing_address TEXT NOT NULL,
    shipping_method VARCHAR(100),
    tracking_number VARCHAR(100),
    payment_method VARCHAR(50),
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    INDEX idx_order_user (user_id),
    INDEX idx_order_date (order_date),
    INDEX idx_order_status (status)
);

/*Order items table (Many-to-Many relationship between orders and products)*/
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT,
    UNIQUE KEY unique_order_product (order_id, product_id),
    INDEX idx_order_items_order (order_id),
    INDEX idx_order_items_product (product_id)
);

/*Shopping cart table*/
CREATE TABLE shopping_cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_cart_user (user_id)
);

/*Cart items table*/
CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES shopping_cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_cart_product (cart_id, product_id),
    INDEX idx_cart_items_cart (cart_id),
    INDEX idx_cart_items_product (product_id)
);

CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(255),
    comment TEXT,
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product_review (user_id, product_id),
    INDEX idx_review_user (user_id),
    INDEX idx_review_product (product_id),
    INDEX idx_review_rating (rating)
);

/*Payments table (One-to-One relationship with orders)*/
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    payment_method VARCHAR(50) NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    transaction_id VARCHAR(100) UNIQUE,
    payment_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    INDEX idx_payment_order (order_id),
    INDEX idx_payment_status (payment_status),
    INDEX idx_transaction_id (transaction_id)
);

/*Shipping table*/
CREATE TABLE shipping (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    carrier VARCHAR(100) NOT NULL,
    tracking_number VARCHAR(100) UNIQUE,
    shipping_status ENUM('pending', 'shipped', 'in_transit', 'delivered') DEFAULT 'pending',
    estimated_delivery DATE,
    actual_delivery DATE,
    shipping_cost DECIMAL(10,2) NOT NULL CHECK (shipping_cost >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    INDEX idx_shipping_order (order_id),
    INDEX idx_tracking_number (tracking_number)
);

/*Insert sample data for demonstration*/
INSERT INTO categories (name, description, parent_category_id) VALUES
('Electronics', 'Electronic devices and accessories', NULL),
('Computers & Tablets', 'Computers, laptops, and tablets', 1),
('Smartphones', 'Mobile phones and accessories', 1),
('Clothing', 'Fashion and apparel', NULL),
('Men''s Clothing', 'Clothing for men', 4),
('Women''s Clothing', 'Clothing for women', 4);

INSERT INTO products (name, description, price, sku, stock_quantity, category_id, brand) VALUES
('iPhone 15 Pro', 'Latest iPhone with advanced camera system', 999.99, 'IPH15PRO-256', 50, 3, 'Apple'),
('MacBook Air M2', 'Lightweight laptop with M2 chip', 1199.99, 'MBA-M2-13', 30, 2, 'Apple'),
('Samsung Galaxy S23', 'Android smartphone with high-end features', 799.99, 'SGS23-128', 40, 3, 'Samsung'),
('Men''s Casual Shirt', 'Comfortable cotton shirt for everyday wear', 49.99, 'MCS-BLUE-M', 100, 5, 'FashionBrand'),
('Women''s Jeans', 'Classic denim jeans for women', 69.99, 'WJ-DENIM-32', 75, 6, 'DenimCo');

/*Display database structure information*/
SELECT 'E-commerce Database created successfully!' as status;
SELECT COUNT(*) as total_tables FROM information_schema.tables 
WHERE table_schema = 'ecommerce_db' AND table_type = 'BASE TABLE';