-- ============================================
-- Airbnb Database - Sample Data Insertion
-- ============================================

-- Clear existing data (optional - use with caution)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Message;
TRUNCATE TABLE Review;
TRUNCATE TABLE Payment;
TRUNCATE TABLE Booking;
TRUNCATE TABLE Amenity;
TRUNCATE TABLE Property_Image;
TRUNCATE TABLE Location;
TRUNCATE TABLE Property;
TRUNCATE TABLE User;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- INSERT USERS
-- ============================================

INSERT INTO User (user_id, email, password_hash, first_name, last_name, phone_number, profile_photo, role, created_at) VALUES
-- Hosts
('550e8400-e29b-41d4-a716-446655440001', 'john.doe@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYbYC9Rq0S2', 'John', 'Doe', '+1-555-0101', 'https://example.com/photos/john.jpg', 'host', '2023-01-15 10:30:00'),
('550e8400-e29b-41d4-a716-446655440002', 'sarah.wilson@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYbYC9Rq0S2', 'Sarah', 'Wilson', '+1-555-0102', 'https://example.com/photos/sarah.jpg', 'host', '2023-02-20 14:15:00'),
('550e8400-e29b-41d4-a716-446655440003', 'michael.brown@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYbYC9Rq0S2', 'Michael', 'Brown', '+1-555-0103', 'https://example.com/photos/michael.jpg', 'host', '2023-03-10 09:00:00'),
('550e8400-e29b-41d4-a716-446655440004', 'emily.davis@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYbYC9Rq0S2', 'Emily', 'Davis', '+1-555-0104', 'https://example.com/photos/emily.jpg', 'host', '2023-04-05 16:45:00'),

-- Guests
('550e8400-e29b-41d4-a716-446655440005', 'jane.smith@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYbYC9Rq0S2', 'Jane', 'Smith', '+1-555-0105', 'https://example.com/photos/jane.jpg', 'guest', '2023-05-12 11:20:00'),
('550e8400-e29b-41d4-a716-446655440006', 'robert.johnson@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYbYC9Rq0S2', 'Robert', 'Johnson', '+1-555-0106', 'https://example.com/photos/robert.jpg', 'guest', '2023-06-18 13:30:00'),
('550e8400-e29b-41d4-a716-446655440007', 'lisa.anderson@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYbYC9Rq0S2', 'Lisa', 'Anderson', '+1-555-0107', 'https://example.com/photos/lisa.jpg', 'guest', '2023-07-22 15:10:00'),
('550e8400-e29b-41d4-a716-446655440008', 'david.martinez@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYbYC9Rq0S2', 'David', 'Martinez', '+1-555-0108', 'https://example.com/photos/david.jpg', 'guest', '2023-08-30 10:45:00'),
('550e8400-e29b-41d4-a716-446655440009', 'amanda.taylor@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYbYC9Rq0S2', 'Amanda', 'Taylor', '+1-555-0109', 'https://example.com/photos/amanda.jpg', 'guest', '2023-09-14 12:00:00'),

-- Admin
('550e8400-e29b-41d4-a716-446655440010', 'admin@airbnb.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYbYC9Rq0S2', 'Admin', 'User', '+1-555-0110', 'https://example.com/photos/admin.jpg', 'admin', '2023-01-01 08:00:00');

-- ============================================
-- INSERT PROPERTIES
-- ============================================

INSERT INTO Property (property_id, host_id, title, description, price_per_night, max_guests, bedrooms, bathrooms, property_type, is_active, created_at) VALUES
-- John's Properties
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Luxury Beachfront Villa', 'Stunning oceanfront villa with private beach access, infinity pool, and breathtaking sunset views. Perfect for families or groups seeking a luxurious coastal retreat.', 450.00, 8, 4, 3, 'villa', TRUE, '2023-01-20 09:00:00'),
('650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Downtown Loft Studio', 'Modern loft in the heart of downtown. Walking distance to restaurants, shops, and entertainment. Ideal for business travelers or couples.', 120.00, 2, 1, 1, 'loft', TRUE, '2023-02-15 11:30:00'),

-- Sarah's Properties
('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 'Cozy Mountain Cabin', 'Rustic cabin nestled in the mountains with fireplace, hot tub, and hiking trails nearby. Perfect winter getaway or summer escape.', 180.00, 6, 3, 2, 'cabin', TRUE, '2023-03-01 14:00:00'),
('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'Elegant City Apartment', 'Sophisticated 2-bedroom apartment with city skyline views, fully equipped kitchen, and premium amenities. Great for extended stays.', 200.00, 4, 2, 2, 'apartment', TRUE, '2023-03-15 10:15:00'),

-- Michael's Properties
('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 'Charming Countryside House', 'Traditional farmhouse on 5 acres with garden, chickens, and pastoral views. Experience authentic country living with modern comforts.', 150.00, 6, 3, 2, 'house', TRUE, '2023-04-10 13:45:00'),
('650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', 'Seaside Condo', 'Beachside condo with balcony overlooking the ocean. Community pool, tennis courts, and direct beach access.', 175.00, 4, 2, 2, 'condo', TRUE, '2023-05-05 16:20:00'),

-- Emily's Properties
('650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440004', 'Historic Townhouse', 'Beautifully restored Victorian townhouse in historic district. Original details with modern updates. Walk to museums and cafes.', 220.00, 5, 3, 2, 'townhouse', TRUE, '2023-06-01 09:30:00'),
('650e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440004', 'Modern Guesthouse', 'Private guesthouse on quiet property. Kitchenette, private entrance, and peaceful garden setting. Perfect for solo travelers.', 95.00, 2, 1, 1, 'guesthouse', TRUE, '2023-07-10 12:00:00');

-- ============================================
-- INSERT LOCATIONS
-- ============================================

INSERT INTO Location (location_id, property_id, address, city, state, country, postal_code, latitude, longitude) VALUES
('750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '123 Ocean Drive', 'Miami', 'Florida', 'USA', '33139', 25.7617, -80.1918),
('750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440002', '456 Main Street, Unit 12B', 'New York', 'New York', 'USA', '10001', 40.7128, -74.0060),
('750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440003', '789 Mountain View Road', 'Aspen', 'Colorado', 'USA', '81611', 39.1911, -106.8175),
('750e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440004', '321 Skyline Avenue, Apt 45', 'San Francisco', 'California', 'USA', '94102', 37.7749, -122.4194),
('750e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440005', '567 Country Lane', 'Nashville', 'Tennessee', 'USA', '37201', 36.1627, -86.7816),
('750e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440006', '890 Beachfront Blvd, Unit 8C', 'Santa Monica', 'California', 'USA', '90401', 34.0195, -118.4912),
('750e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440007', '234 Heritage Street', 'Boston', 'Massachusetts', 'USA', '02108', 42.3601, -71.0589),
('750e8400-e29b-41d4-a716-446655440008', '650e8400-e29b-41d4-a716-446655440008', '678 Garden Way', 'Portland', 'Oregon', 'USA', '97201', 45.5152, -122.6784);

-- ============================================
-- INSERT PROPERTY IMAGES
-- ============================================

INSERT INTO Property_Image (image_id, property_id, image_url, is_primary, display_order, uploaded_at) VALUES
-- Villa Images
('850e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', 'https://example.com/properties/villa/main.jpg', TRUE, 1, '2023-01-20 09:15:00'),
('850e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440001', 'https://example.com/properties/villa/pool.jpg', FALSE, 2, '2023-01-20 09:16:00'),
('850e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440001', 'https://example.com/properties/villa/bedroom.jpg', FALSE, 3, '2023-01-20 09:17:00'),
('850e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440001', 'https://example.com/properties/villa/kitchen.jpg', FALSE, 4, '2023-01-20 09:18:00'),

-- Loft Images
('850e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440002', 'https://example.com/properties/loft/main.jpg', TRUE, 1, '2023-02-15 11:45:00'),
('850e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440002', 'https://example.com/properties/loft/living.jpg', FALSE, 2, '2023-02-15 11:46:00'),

-- Cabin Images
('850e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440003', 'https://example.com/properties/cabin/main.jpg', TRUE, 1, '2023-03-01 14:15:00'),
('850e8400-e29b-41d4-a716-446655440008', '650e8400-e29b-41d4-a716-446655440003', 'https://example.com/properties/cabin/fireplace.jpg', FALSE, 2, '2023-03-01 14:16:00'),
('850e8400-e29b-41d4-a716-446655440009', '650e8400-e29b-41d4-a716-446655440003', 'https://example.com/properties/cabin/hottub.jpg', FALSE, 3, '2023-03-01 14:17:00'),

-- Apartment Images
('850e8400-e29b-41d4-a716-446655440010', '650e8400-e29b-41d4-a716-446655440004', 'https://example.com/properties/apartment/main.jpg', TRUE, 1, '2023-03-15 10:30:00'),
('850e8400-e29b-41d4-a716-446655440011', '650e8400-e29b-41d4-a716-446655440004', 'https://example.com/properties/apartment/view.jpg', FALSE, 2, '2023-03-15 10:31:00'),

-- House Images
('850e8400-e29b-41d4-a716-446655440012', '650e8400-e29b-41d4-a716-446655440005', 'https://example.com/properties/house/main.jpg', TRUE, 1, '2023-04-10 14:00:00'),
('850e8400-e29b-41d4-a716-446655440013', '650e8400-e29b-41d4-a716-446655440005', 'https://example.com/properties/house/garden.jpg', FALSE, 2, '2023-04-10 14:01:00'),

-- Condo Images
('850e8400-e29b-41d4-a716-446655440014', '650e8400-e29b-41d4-a716-446655440006', 'https://example.com/properties/condo/main.jpg', TRUE, 1, '2023-05-05 16:35:00'),
('850e8400-e29b-41d4-a716-446655440015', '650e8400-e29b-41d4-a716-446655440006', 'https://example.com/properties/condo/balcony.jpg', FALSE, 2, '2023-05-05 16:36:00'),

-- Townhouse Images
('850e8400-e29b-41d4-a716-446655440016', '650e8400-e29b-41d4-a716-446655440007', 'https://example.com/properties/townhouse/main.jpg', TRUE, 1, '2023-06-01 09:45:00'),
('850e8400-e29b-41d4-a716-446655440017', '650e8400-e29b-41d4-a716-446655440007', 'https://example.com/properties/townhouse/interior.jpg', FALSE, 2, '2023-06-01 09:46:00'),

-- Guesthouse Images
('850e8400-e29b-41d4-a716-446655440018', '650e8400-e29b-41d4-a716-446655440008', 'https://example.com/properties/guesthouse/main.jpg', TRUE, 1, '2023-07-10 12:15:00'),
('850e8400-e29b-41d4-a716-446655440019', '650e8400-e29b-41d4-a716-446655440008', 'https://example.com/properties/guesthouse/garden.jpg', FALSE, 2, '2023-07-10 12:16:00');

-- ============================================
-- INSERT AMENITIES
-- ============================================

INSERT INTO Amenity (amenity_id, property_id, amenity_name, icon) VALUES
-- Villa Amenities
('950e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', 'WiFi', '📶'),
('950e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440001', 'Pool', '🏊'),
('950e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440001', 'Beach Access', '🏖️'),
('950e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440001', 'Air Conditioning', '❄️'),
('950e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440001', 'Kitchen', '🍳'),
('950e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440001', 'Parking', '🚗'),

-- Loft Amenities
('950e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440002', 'WiFi', '📶'),
('950e8400-e29b-41d4-a716-446655440008', '650e8400-e29b-41d4-a716-446655440002', 'Air Conditioning', '❄️'),
('950e8400-e29b-41d4-a716-446655440009', '650e8400-e29b-41d4-a716-446655440002', 'Elevator', '🛗'),

-- Cabin Amenities
('950e8400-e29b-41d4-a716-446655440010', '650e8400-e29b-41d4-a716-446655440003', 'WiFi', '📶'),
('950e8400-e29b-41d4-a716-446655440011', '650e8400-e29b-41d4-a716-446655440003', 'Fireplace', '🔥'),
('950e8400-e29b-41d4-a716-446655440012', '650e8400-e29b-41d4-a716-446655440003', 'Hot Tub', '🛁'),
('950e8400-e29b-41d4-a716-446655440013', '650e8400-e29b-41d4-a716-446655440003', 'Parking', '🚗'),
('950e8400-e29b-41d4-a716-446655440014', '650e8400-e29b-41d4-a716-446655440003', 'Kitchen', '🍳'),

-- Apartment Amenities
('950e8400-e29b-41d4-a716-446655440015', '650e8400-e29b-41d4-a716-446655440004', 'WiFi', '📶'),
('950e8400-e29b-41d4-a716-446655440016', '650e8400-e29b-41d4-a716-446655440004', 'Gym', '💪'),
('950e8400-e29b-41d4-a716-446655440017', '650e8400-e29b-41d4-a716-446655440004', 'Washer/Dryer', '🧺'),
('950e8400-e29b-41d4-a716-446655440018', '650e8400-e29b-41d4-a716-446655440004', 'Kitchen', '🍳'),

-- House Amenities
('950e8400-e29b-41d4-a716-446655440019', '650e8400-e29b-41d4-a716-446655440005', 'WiFi', '📶'),
('950e8400-e29b-41d4-a716-446655440020', '650e8400-e29b-41d4-a716-446655440005', 'Garden', '🌻'),
('950e8400-e29b-41d4-a716-446655440021', '650e8400-e29b-41d4-a716-446655440005', 'Pet Friendly', '🐕'),
('950e8400-e29b-41d4-a716-446655440022', '650e8400-e29b-41d4-a716-446655440005', 'Parking', '🚗'),

-- Condo Amenities
('950e8400-e29b-41d4-a716-446655440023', '650e8400-e29b-41d4-a716-446655440006', 'WiFi', '📶'),
('950e8400-e29b-41d4-a716-446655440024', '650e8400-e29b-41d4-a716-446655440006', 'Pool', '🏊'),
('950e8400-e29b-41d4-a716-446655440025', '650e8400-e29b-41d4-a716-446655440006', 'Beach Access', '🏖️'),
('950e8400-e29b-41d4-a716-446655440026', '650e8400-e29b-41d4-a716-446655440006', 'Tennis Court', '🎾'),

-- Townhouse Amenities
('950e8400-e29b-41d4-a716-446655440027', '650e8400-e29b-41d4-a716-446655440007', 'WiFi', '📶'),
('950e8400-e29b-41d4-a716-446655440028', '650e8400-e29b-41d4-a716-446655440007', 'Fireplace', '🔥'),
('950e8400-e29b-41d4-a716-446655440029', '650e8400-e29b-41d4-a716-446655440007', 'Washer/Dryer', '🧺'),

-- Guesthouse Amenities
('950e8400-e29b-41d4-a716-446655440030', '650e8400-e29b-41d4-a716-446655440008', 'WiFi', '📶'),
('950e8400-e29b-41d4-a716-446655440031', '650e8400-e29b-41d4-a716-446655440008', 'Kitchenette', '🍽️'),
('950e8400-e29b-41d4-a716-446655440032', '650e8400-e29b-41d4-a716-446655440008', 'Private Entrance', '🚪');

-- ============================================
-- INSERT BOOKINGS
-- ============================================

INSERT INTO Booking (booking_id, property_id, guest_id, check_in_date, check_out_date, number_of_guests, total_price, status, created_at) VALUES
-- Completed Bookings
('a50e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440005', '2024-01-15', '2024-01-20', 6, 2250.00, 'completed', '2023-12-01 10:00:00'),
('a50e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440006', '2024-02-10', '2024-02-15', 4, 900.00, 'completed', '2024-01-05 14:30:00'),
('a50e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440007', '2024-03-01', '2024-03-07', 5, 900.00, 'completed', '2024-02-01 09:15:00'),
('a50e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440008', '2024-04-12', '2024-04-15', 2, 360.00, 'completed', '2024-03-20 16:45:00'),

-- Confirmed Bookings (Upcoming)
('a50e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440005', '2024-12-20', '2024-12-27', 4, 1400.00, 'confirmed', '2024-10-15 11:20:00'),
('a50e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440009', '2024-12-15', '2024-12-22', 3, 1225.00, 'confirmed', '2024-10-20 13:00:00'),
('a50e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440006', '2025-01-05', '2025-01-10', 4, 1100.00, 'confirmed', '2024-11-01 15:30:00'),

-- Pending Bookings
('a50e8400-e29b-41d4-a716-446655440008', '650e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440007', '2024-12-10', '2024-12-13', 2, 285.00, 'pending', '2024-11-01 10:00:00'),

-- Cancelled Booking
('a50e8400-e29b-41d4-a716-446655440009', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440008', '2024-06-01', '2024-06-05', 4, 1800.00, 'cancelled', '2024-04-15 12:00:00');

-- ============================================
-- INSERT PAYMENTS
-- ============================================

INSERT INTO Payment (payment_id, booking_id, user_id, amount, payment_method, status, payment_date, transaction_id) VALUES
-- Completed Payments
('b50e8400-e29b-41d4-a716-446655440001', 'a50e8400-e29b-41d4-a716-446655440001', '550e8400-
