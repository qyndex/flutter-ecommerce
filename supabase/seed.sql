-- Seed data: 15 products across 5 categories
-- Uses deterministic UUIDs so product IDs are stable across reseeds

INSERT INTO public.products (id, name, description, price, category, image_url, stock_count, rating, review_count) VALUES

-- Electronics (3)
('11111111-1111-1111-1111-000000000001', 'Wireless Headphones',
 'Premium wireless headphones with active noise cancellation, 30-hour battery life, and ultra-comfortable memory foam ear cushions.',
 149.99, 'Electronics', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=300&fit=crop', 45, 4.5, 1240),

('11111111-1111-1111-1111-000000000002', 'Smart Watch Pro',
 'Feature-rich smartwatch with health tracking, GPS, 5-day battery life, and always-on AMOLED display.',
 299.99, 'Electronics', 'https://images.unsplash.com/photo-1546868871-af0de0ae72be?w=400&h=300&fit=crop', 30, 4.6, 2103),

('11111111-1111-1111-1111-000000000003', 'Portable Bluetooth Speaker',
 'Waterproof portable speaker with 360-degree sound, 12-hour playtime, and built-in microphone for calls.',
 79.99, 'Electronics', 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&h=300&fit=crop', 60, 4.3, 876),

-- Sports & Outdoors (3)
('11111111-1111-1111-1111-000000000004', 'Running Shoes',
 'Lightweight running shoes with responsive cushioning, breathable mesh upper, and durable rubber outsole for daily training.',
 89.99, 'Sports', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=300&fit=crop', 80, 4.3, 876),

('11111111-1111-1111-1111-000000000005', 'Yoga Mat Premium',
 'Non-slip yoga mat with alignment lines, 6mm thickness, carrying strap, and eco-friendly TPE material.',
 34.99, 'Sports', 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=400&h=300&fit=crop', 120, 4.4, 519),

('11111111-1111-1111-1111-000000000006', 'Stainless Steel Water Bottle',
 'Double-wall vacuum insulated water bottle. Keeps drinks cold 24 hours or hot 12 hours. BPA-free, 32oz capacity.',
 24.99, 'Sports', 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&h=300&fit=crop', 200, 4.7, 342),

-- Accessories (3)
('11111111-1111-1111-1111-000000000007', 'Leather Backpack',
 'Genuine leather backpack with padded laptop compartment, waterproof lining, and antique brass hardware.',
 199.99, 'Accessories', 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=300&fit=crop', 25, 4.7, 342),

('11111111-1111-1111-1111-000000000008', 'Minimalist Wallet',
 'Slim RFID-blocking wallet crafted from full-grain leather. Holds 8 cards and cash with a sleek profile.',
 49.99, 'Accessories', 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400&h=300&fit=crop', 90, 4.2, 654),

('11111111-1111-1111-1111-000000000009', 'Polarized Sunglasses',
 'Classic aviator sunglasses with UV400 polarized lenses, lightweight titanium frame, and spring hinges.',
 69.99, 'Accessories', 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400&h=300&fit=crop', 55, 4.4, 431),

-- Home & Kitchen (3)
('11111111-1111-1111-1111-000000000010', 'Coffee Maker Deluxe',
 'Programmable drip coffee maker with built-in burr grinder, thermal carafe, and brew-strength control.',
 129.99, 'Home', 'https://images.unsplash.com/photo-1517256064527-9d1c6e12e795?w=400&h=300&fit=crop', 35, 4.2, 988),

('11111111-1111-1111-1111-000000000011', 'Cast Iron Skillet',
 'Pre-seasoned 12-inch cast iron skillet. Oven safe to 500F, works on all cooktops including induction.',
 39.99, 'Home', 'https://images.unsplash.com/photo-1585515320310-259814833e62?w=400&h=300&fit=crop', 70, 4.8, 1567),

('11111111-1111-1111-1111-000000000012', 'Ceramic Plant Pot Set',
 'Set of 3 modern ceramic plant pots with drainage holes and bamboo saucers. Matte finish in neutral tones.',
 44.99, 'Home', 'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=400&h=300&fit=crop', 40, 4.5, 287),

-- Clothing (3)
('11111111-1111-1111-1111-000000000013', 'Organic Cotton T-Shirt',
 '100% organic cotton crew-neck t-shirt. Pre-shrunk, breathable fabric with reinforced double-stitched seams.',
 29.99, 'Clothing', 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=300&fit=crop', 150, 4.1, 723),

('11111111-1111-1111-1111-000000000014', 'Merino Wool Sweater',
 'Lightweight merino wool crewneck sweater. Temperature regulating, odor resistant, and machine washable.',
 89.99, 'Clothing', 'https://images.unsplash.com/photo-1434389677669-e08b4cda3a42?w=400&h=300&fit=crop', 40, 4.6, 398),

('11111111-1111-1111-1111-000000000015', 'Denim Jacket',
 'Classic denim jacket in medium wash. Stretch denim for comfort, button front closure, and two chest pockets.',
 79.99, 'Clothing', 'https://images.unsplash.com/photo-1495105787522-5334e3ffa0ef?w=400&h=300&fit=crop', 35, 4.3, 562)

ON CONFLICT (id) DO NOTHING;
