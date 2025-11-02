-- ============================================
-- Airbnb Database Schema
-- ============================================

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Amenity;
DROP TABLE IF EXISTS Property_Image;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS User;

-- ============================================
-- USER Table
-- ============================================
CREATE TABLE User (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    profile_photo VARCHAR(500),
    role ENUM('guest', 'host', 'admin') NOT NULL DEFAULT 'guest',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_user_email (email),
    INDEX idx_user_role (role)
);

-- ============================================
-- PROPERTY Table
-- ============================================
CREATE TABLE Property (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    max_guests INT NOT NULL,
    bedrooms INT NOT NULL,
    bathrooms INT NOT NULL,
    property_type ENUM('apartment', 'house', 'villa', 'cabin', 'condo', 'townhouse', 'loft', 'guesthouse') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_property_host
        FOREIGN KEY (host_id) 
        REFERENCES User(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_price_positive CHECK (price_per_night > 0),
    CONSTRAINT chk_max_guests_positive CHECK (max_guests > 0),
    CONSTRAINT chk_bedrooms_non_negative CHECK (bedrooms >= 0),
    CONSTRAINT chk_bathrooms_non_negative CHECK (bathrooms >= 0),
    
    -- Indexes
    INDEX idx_property_host (host_id),
    INDEX idx_property_type (property_type),
    INDEX idx_property_price (price_per_night),
    INDEX idx_property_active (is_active)
);

-- ============================================
-- LOCATION Table
-- ============================================
CREATE TABLE Location (
    location_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_location_property
        FOREIGN KEY (property_id)
        REFERENCES Property(property_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_latitude_range CHECK (latitude BETWEEN -90 AND 90),
    CONSTRAINT chk_longitude_range CHECK (longitude BETWEEN -180 AND 180),
    
    -- Indexes
    INDEX idx_location_city (city),
    INDEX idx_location_country (country),
    INDEX idx_location_coordinates (latitude, longitude)
);

-- ============================================
-- PROPERTY_IMAGE Table
-- ============================================
CREATE TABLE Property_Image (
    image_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_image_property
        FOREIGN KEY (property_id)
        REFERENCES Property(property_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_display_order_non_negative CHECK (display_order >= 0),
    
    -- Indexes
    INDEX idx_image_property (property_id),
    INDEX idx_image_primary (property_id, is_primary),
    INDEX idx_image_order (property_id, display_order)
);

-- ============================================
-- AMENITY Table
-- ============================================
CREATE TABLE Amenity (
    amenity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    amenity_name VARCHAR(100) NOT NULL,
    icon VARCHAR(50),
    
    -- Foreign Key Constraints
    CONSTRAINT fk_amenity_property
        FOREIGN KEY (property_id)
        REFERENCES Property(property_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Indexes
    INDEX idx_amenity_property (property_id),
    INDEX idx_amenity_name (amenity_name)
);

-- ============================================
-- BOOKING Table
-- ============================================
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    guest_id UUID NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_booking_property
        FOREIGN KEY (property_id)
        REFERENCES Property(property_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_booking_guest
        FOREIGN KEY (guest_id)
        REFERENCES User(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_checkout_after_checkin CHECK (check_out_date > check_in_date),
    CONSTRAINT chk_guests_positive CHECK (number_of_guests > 0),
    CONSTRAINT chk_total_price_positive CHECK (total_price > 0),
    
    -- Indexes
    INDEX idx_booking_property (property_id),
    INDEX idx_booking_guest (guest_id),
    INDEX idx_booking_dates (check_in_date, check_out_date),
    INDEX idx_booking_status (status)
);

-- ============================================
-- PAYMENT Table
-- ============================================
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL,
    user_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('credit_card', 'debit_card', 'paypal', 'stripe', 'bank_transfer') NOT NULL,
    status ENUM('pending', 'completed', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_id VARCHAR(100) UNIQUE,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_payment_booking
        FOREIGN KEY (booking_id)
        REFERENCES Booking(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_payment_user
        FOREIGN KEY (user_id)
        REFERENCES User(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_amount_positive CHECK (amount > 0),
    
    -- Indexes
    INDEX idx_payment_booking (booking_id),
    INDEX idx_payment_user (user_id),
    INDEX idx_payment_status (status),
    INDEX idx_payment_transaction (transaction_id)
);

-- ============================================
-- REVIEW Table
-- ============================================
CREATE TABLE Review (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    booking_id UUID NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_review_property
        FOREIGN KEY (property_id)
        REFERENCES Property(property_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_review_user
        FOREIGN KEY (user_id)
        REFERENCES User(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_review_booking
        FOREIGN KEY (booking_id)
        REFERENCES Booking(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_rating_range CHECK (rating BETWEEN 1 AND 5),
    
    -- Unique Constraint (one review per booking)
    CONSTRAINT uq_review_booking UNIQUE (booking_id),
    
    -- Indexes
    INDEX idx_review_property (property_id),
    INDEX idx_review_user (user_id),
    INDEX idx_review_rating (rating)
);

-- ============================================
-- MESSAGE Table
-- ============================================
CREATE TABLE Message (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    booking_id UUID,
    message_body TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    CONSTRAINT fk_message_sender
        FOREIGN KEY (sender_id)
        REFERENCES User(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_message_recipient
        FOREIGN KEY (recipient_id)
        REFERENCES User(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_message_booking
        FOREIGN KEY (booking_id)
        REFERENCES Booking(booking_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_sender_not_recipient CHECK (sender_id != recipient_id),
    
    -- Indexes
    INDEX idx_message_sender (sender_id),
    INDEX idx_message_recipient (recipient_id),
    INDEX idx_message_booking (booking_id),
    INDEX idx_message_read (recipient_id, is_read),
    INDEX idx_message_sent (sent_at)
);

-- ============================================
-- Additional Triggers for Updated_at
-- ============================================

-- Trigger for User table
DELIMITER //
CREATE TRIGGER before_user_update
BEFORE UPDATE ON User
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//
DELIMITER ;

-- Trigger for Property table
DELIMITER //
CREATE TRIGGER before_property_update
BEFORE UPDATE ON Property
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//
DELIMITER ;

-- Trigger for Booking table
DELIMITER //
CREATE TRIGGER before_booking_update
BEFORE UPDATE ON Booking
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//
DELIMITER ;

-- Trigger for Review table
DELIMITER //
CREATE TRIGGER before_review_update
BEFORE UPDATE ON Review
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//
DELIMITER ;
