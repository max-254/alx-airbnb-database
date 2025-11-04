-- =====================================================
-- COMPLETE BOOKINGS QUERY
-- Retrieve all bookings with user, property, and payment details
-- =====================================================

SELECT 
    -- Booking Information
    b.booking_id,
    b.booking_date,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    
    -- User Information
    u.user_id,
    u.username,
    u.email AS user_email,
    u.first_name,
    u.last_name,
    u.phone_number,
    u.created_at AS user_joined_date,
    
    -- Property Information
    p.property_id,
    p.property_name,
    p.location,
    p.description AS property_description,
    p.price_per_night,
    p.property_type,
    p.number_of_bedrooms,
    p.number_of_bathrooms,
    p.max_guests,
    
    -- Payment Information
    pm.payment_id,
    pm.payment_date,
    pm.payment_method,
    pm.payment_amount,
    pm.payment_status,
    pm.transaction_id,
    pm.currency
    
FROM 
    bookings b
    
INNER JOIN 
    users u ON b.user_id = u.user_id
    
INNER JOIN 
    properties p ON b.property_id = p.property_id
    
LEFT JOIN 
    payments pm ON b.booking_id = pm.booking_id
    
ORDER BY 
    b.booking_date DESC, b.booking_id;


-- =====================================================
-- ALTERNATIVE: WITH CALCULATED FIELDS
-- =====================================================

-- Enhanced version with additional calculated fields
SELECT 
    -- Booking Information
    b.booking_id,
    b.booking_date,
    b.start_date,
    b.end_date,
    DATEDIFF(b.end_date, b.start_date) AS nights_booked,
    b.total_price,
    b.status AS booking_status,
    
    -- User Information
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_full_name,
    u.username,
    u.email AS user_email,
    u.phone_number,
    
    -- Property Information
    p.property_id,
    p.property_name,
    p.location,
    p.price_per_night,
    p.property_type,
    CONCAT(p.number_of_bedrooms, ' bed / ', p.number_of_bathrooms, ' bath') AS property_details,
    
    -- Payment Information
    pm.payment_id,
    pm.payment_date,
    pm.payment_method,
    pm.payment_amount,
    pm.payment_status,
    CASE 
        WHEN pm.payment_status = 'completed' THEN 'Paid'
        WHEN pm.payment_status = 'pending' THEN 'Payment Pending'
        WHEN pm.payment_status = 'failed' THEN 'Payment Failed'
        ELSE 'No Payment'
    END AS payment_status_description,
    
    -- Calculated Fields
    CASE 
        WHEN b.start_date > CURDATE() THEN 'Upcoming'
        WHEN b.end_date < CURDATE() THEN 'Completed'
        WHEN b.start_date <= CURDATE() AND b.end_date >= CURDATE() THEN 'Active'
        ELSE 'Unknown'
    END AS booking_timeline_status
    
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pm ON b.booking_id = pm.booking_id
ORDER BY 
    b.booking_date DESC;


-- =====================================================
-- FILTERED VERSION: ACTIVE BOOKINGS ONLY
-- =====================================================

-- Get only active or upcoming bookings with all details
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.username,
    u.email AS user_email,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.phone_number,
    
    p.property_name,
    p.location,
    p.price_per_night,
    
    pm.payment_status,
    pm.payment_amount,
    pm.payment_method
    
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pm ON b.booking_id = pm.booking_id
    
WHERE 
    b.end_date >= CURDATE()
    AND b.status IN ('confirmed', 'pending')
    
ORDER BY 
    b.start_date ASC;


-- =====================================================
-- SUMMARY VERSION: WITH AGGREGATE STATISTICS
-- =====================================================

-- Include booking count and total revenue per property
SELECT 
    b.booking_id,
    b.booking_date,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.username,
    u.email,
    
    p.property_name,
    p.location,
    p.price_per_night,
    
    pm.payment_status,
    pm.payment_amount,
    
    -- Aggregate statistics using window functions
    COUNT(*) OVER (PARTITION BY p.property_id) AS total_bookings_for_property,
    SUM(b.total_price) OVER (PARTITION BY p.property_id) AS total_revenue_for_property,
    COUNT(*) OVER (PARTITION BY u.user_id) AS total_bookings_by_user
    
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
INNER JOIN 
    properties p ON b.property_id = p.property_id
LEFT JOIN 
    payments pm ON b.booking_id = pm.booking_id
    
ORDER BY 
    b.booking_date DESC;


-- =====================================================
-- NOTES AND EXPLANATIONS
-- =====================================================

/*
JOIN TYPES EXPLAINED:

1. INNER JOIN for users and properties:
   - Only returns bookings that have both user and property
   - Ensures data integrity
   - Most common scenario

2. LEFT JOIN for payments:
   - Returns all bookings even if payment doesn't exist yet
   - Useful for pending bookings without payment
   - payment_* columns will be NULL if no payment exists

QUERY VARIATIONS:

1. Basic Query:
   - All fields from all tables
   - Simple and straightforward
   - Good for data exports

2. Enhanced Query:
   - Calculated fields (nights_booked, full_name)
   - Status descriptions
   - Better for reporting

3. Filtered Query:
   - Only active/upcoming bookings
   - Optimized for operational dashboards
   - Better performance on large datasets

4. Summary Query:
   - Includes aggregate statistics
   - Useful for analytics
   - Shows patterns across bookings

PERFORMANCE CONSIDERATIONS:
- Indexes recommended on: user_id, property_id, booking_id
- Use WHERE clause to filter large result sets
- Consider pagination for web applications
- Add LIMIT clause if only need sample data

COMMON MODIFICATIONS:
- Add WHERE clause to filter by date range
- Add specific user or property filters
- Join with reviews table for ratings
- Join with host/owner information if available
*/
