-- =====================================================
-- 1. AGGREGATION QUERY
-- Find the total number of bookings made by each user
-- =====================================================

SELECT 
    u.user_id,
    u.username,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.username, u.email
ORDER BY 
    total_bookings DESC, u.username;

-- Note: Using LEFT JOIN ensures users with 0 bookings are included
-- Using INNER JOIN would only show users who have at least 1 booking


-- =====================================================
-- 2. WINDOW FUNCTIONS
-- Rank properties based on total number of bookings
-- =====================================================

-- Using ROW_NUMBER (unique sequential ranking, no ties)
SELECT 
    p.property_id,
    p.property_name,
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_num
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.property_name, p.location
ORDER BY 
    row_num;


-- Using RANK (same rank for ties, skips next rank)
SELECT 
    p.property_id,
    p.property_name,
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.property_name, p.location
ORDER BY 
    rank;


-- Using DENSE_RANK (same rank for ties, doesn't skip next rank)
SELECT 
    p.property_id,
    p.property_name,
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.property_name, p.location
ORDER BY 
    dense_rank;


-- =====================================================
-- COMPARISON OF WINDOW FUNCTIONS
-- =====================================================

-- All three ranking functions in one query for comparison
SELECT 
    p.property_id,
    p.property_name,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank
FROM 
    properties p
LEFT JOIN 
    bookings b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.property_name
ORDER BY 
    total_bookings DESC;

-- =====================================================
-- ADVANCED: Additional Aggregation Metrics
-- =====================================================

-- More detailed user booking analysis
SELECT 
    u.user_id,
    u.username,
    COUNT(b.booking_id) AS total_bookings,
    MIN(b.booking_date) AS first_booking_date,
    MAX(b.booking_date) AS last_booking_date,
    SUM(b.total_price) AS total_amount_spent,
    AVG(b.total_price) AS avg_booking_price
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.username
HAVING 
    COUNT(b.booking_id) > 0
ORDER BY 
    total_bookings DESC;
