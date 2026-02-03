-- data/seed_data.sql
BEGIN;

SET search_path TO retail;

-- Customers
INSERT INTO customers (first_name, last_name, email, phone, created_at)
VALUES
('Jude','Avery','jude.avery@example.com','555-0101', NOW() - INTERVAL '120 days'),
('Mia','Lopez','mia.lopez@example.com','555-0102', NOW() - INTERVAL '95 days'),
('Sam','Nguyen','sam.nguyen@example.com','555-0103', NOW() - INTERVAL '80 days'),
('Ava','Patel','ava.patel@example.com','555-0104', NOW() - INTERVAL '60 days'),
('Noah','Kim','noah.kim@example.com','555-0105', NOW() - INTERVAL '45 days'),
('Liam','Johnson','liam.johnson@example.com','555-0106', NOW() - INTERVAL '30 days'),
('Emma','Garcia','emma.garcia@example.com','555-0107', NOW() - INTERVAL '20 days'),
('Olivia','Brown','olivia.brown@example.com','555-0108', NOW() - INTERVAL '10 days');

-- Products
INSERT INTO products (product_name, category, unit_price, is_active, created_at)
VALUES
('Classic Burger','Entree', 7.99, TRUE, NOW() - INTERVAL '200 days'),
('Cheeseburger','Entree', 8.49, TRUE, NOW() - INTERVAL '180 days'),
('Chicken Sandwich','Entree', 8.99, TRUE, NOW() - INTERVAL '160 days'),
('Veggie Burger','Entree', 8.29, TRUE, NOW() - INTERVAL '140 days'),
('French Fries','Side', 3.49, TRUE, NOW() - INTERVAL '200 days'),
('Onion Rings','Side', 3.99, TRUE, NOW() - INTERVAL '190 days'),
('Soda','Drink', 2.29, TRUE, NOW() - INTERVAL '210 days'),
('Milkshake','Drink', 4.99, TRUE, NOW() - INTERVAL '170 days'),
('Cookie','Dessert', 1.99, TRUE, NOW() - INTERVAL '150 days'),
('Salad','Side', 4.79, TRUE, NOW() - INTERVAL '130 days');

-- Orders (mix of statuses and dates)
INSERT INTO orders (customer_id, order_ts, status)
VALUES
(1, NOW() - INTERVAL '40 days', 'delivered'),
(1, NOW() - INTERVAL '10 days', 'delivered'),
(2, NOW() - INTERVAL '35 days', 'delivered'),
(2, NOW() - INTERVAL '5 days',  'paid'),
(3, NOW() - INTERVAL '28 days', 'delivered'),
(3, NOW() - INTERVAL '7 days',  'delivered'),
(4, NOW() - INTERVAL '21 days', 'delivered'),
(5, NOW() - INTERVAL '18 days', 'cancelled'),
(6, NOW() - INTERVAL '14 days', 'delivered'),
(7, NOW() - INTERVAL '9 days',  'delivered'),
(8, NOW() - INTERVAL '2 days',  'placed');

-- Order items
-- Note: unit_price captured at time of purchase
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 7.99),
(1, 5, 1, 3.49),
(1, 7, 1, 2.29),

(2, 2, 2, 8.49),
(2, 5, 1, 3.49),
(2, 8, 1, 4.99),

(3, 3, 1, 8.99),
(3, 6, 1, 3.99),
(3, 7, 2, 2.29),

(4, 4, 1, 8.29),
(4, 10,1, 4.79),

(5, 2, 1, 8.49),
(5, 5, 2, 3.49),
(5, 9, 2, 1.99),

(6, 1, 1, 7.99),
(6, 7, 1, 2.29),

(7, 3, 1, 8.99),
(7, 5, 1, 3.49),

(8, 2, 1, 8.49),
(8, 7, 1, 2.29),

(9, 4, 1, 8.29),
(9, 6, 1, 3.99),
(9, 8, 1, 4.99),

(10,1, 1, 7.99),
(10,5, 1, 3.49),
(10,7, 1, 2.29),

(11,2, 1, 8.49);

-- Payments (only for paid/delivered; cancelled/placed may not have payments)
-- amount should reflect sum(quantity * unit_price)
INSERT INTO payments (order_id, payment_ts, method, amount, payment_status)
VALUES
(1,  NOW() - INTERVAL '40 days' + INTERVAL '10 minutes', 'credit_card',  (7.99 + 3.49 + 2.29), 'completed'),
(2,  NOW() - INTERVAL '10 days' + INTERVAL '15 minutes', 'apple_pay',    (2*8.49 + 3.49 + 4.99), 'completed'),
(3,  NOW() - INTERVAL '35 days' + INTERVAL '12 minutes', 'debit_card',   (8.99 + 3.99 + 2*2.29), 'completed'),
(4,  NOW() - INTERVAL '5 days'  + INTERVAL '8 minutes',  'paypal',      (8.29 + 4.79), 'completed'),
(5,  NOW() - INTERVAL '28 days' + INTERVAL '11 minutes', 'credit_card', (8.49 + 2*3.49 + 2*1.99), 'completed'),
(6,  NOW() - INTERVAL '7 days'  + INTERVAL '9 minutes',  'credit_card', (7.99 + 2.29), 'completed'),
(7,  NOW() - INTERVAL '21 days' + INTERVAL '6 minutes',  'debit_card',  (8.99 + 3.49), 'completed'),
(9,  NOW() - INTERVAL '14 days' + INTERVAL '14 minutes', 'gift_card',   (8.29 + 3.99 + 4.99), 'completed'),
(10, NOW() - INTERVAL '9 days'  + INTERVAL '10 minutes', 'cash',        (7.99 + 3.49 + 2.29), 'completed');

COMMIT;
