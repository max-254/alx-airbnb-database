-- =====================================================
-- 1. NON-CORRELATED SUBQUERY
-- Find all properties where the average rating is greater than 4.0
-- =====================================================

SELECT 
    p.property_id,
    p.property_name,
    p.location,
    p.price_per_night
FROM 
    properties p
WHERE 
    p.property_id IN (
        SELECT 
            r.property_id
        FROM 
            reviews r
        GROUP BY 
            r.property_id
        HAVING 
            AVG(r.rating) > 4.0
    )
ORDER BY 
    p.property_id;

-- Alternative using JOIN (for comparison):
-- SELECT DISTINCT p.property_id, p.property_name, p.location, p.price_per_night
-- FROM properties p
-- JOIN reviews r ON p.property_id = r.property_id
-- GROUP BY p.property_id, p.property_name, p.location, p.price_per_night
-- HAVING AVG(r.rating) > 4.0;


-- =====================================================
-- 2. CORRELATED SUBQUERY
-- Find users who have made more than 3 bookings
-- =====================================================

SELECT 
    u.user_id,
    u.username,
    u.email,
    u.created_at
FROM 
    users u
WHERE 
    (
        SELECT 
            COUNT(*)
        FROM 
            bookings b
        WHERE 
            b.user_id = u.user_id
    ) > 3
ORDER BY 
    u.user_id;

-- Alternative with additional booking count (for verification):
SELECT 
    u.user_id,
    u.username,
    u.email,
    (
        SELECT 
            COUNT(*)
        FROM 
            bookings b
        WHERE 
            b.user_id = u.user_id
    ) AS booking_count
FROM 
    users u
WHERE 
    (
        SELECT 
            COUNT(*)
        FROM 
            bookings b
        WHERE 
            b.user_id = u.user_id
    ) > 3
ORDER BY 
    booking_count DESC;

