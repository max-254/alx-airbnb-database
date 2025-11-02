-- =====================================================
-- QUERY PERFORMANCE ANALYSIS AND OPTIMIZATION
-- =====================================================

-- =====================================================
-- STEP 1: ANALYZE ORIGINAL QUERY PERFORMANCE
-- =====================================================

-- Run EXPLAIN on the original query
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.booking_date,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    
    u.user_id,
    u.username,
    u.email AS user_email,
    u.first_name,
    u.last_name,
    u.phone_number,
    
    p.property_id,
    p.property_name,
    p.location,
    p.description AS property_description,
    p.price_per_night,
    p.property_type,
    
    pm.payment_id,
    pm.payment_date,
    pm.payment_method,
    pm.payment_amount,
    pm.payment_status
    
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pm ON b.booking_id = pm.booking_id
ORDER BY b.booking_date DESC;

/*
TYPICAL ISSUES IDENTIFIED:

1. Sequential Scans (Seq Scan):
   - Full table scans on bookings, users, properties
   - Missing indexes on join columns
   - Cost: High for large tables

2. Hash Join / Nested Loop:
   - Inefficient join algorithms without indexes
   - Multiple hash operations consuming memory

3. Sort Operation:
   - ORDER BY causing additional sort step
   - No index on booking_date for sorted retrieval

4. Excessive Columns:
   - Selecting all columns increases I/O
   - Description fields can be large TEXT columns

5. No WHERE Clause:
   - Returning all records (potentially millions)
   - No filtering at database level
*/


-- =====================================================
-- STEP 2: CREATE NECESSARY INDEXES
-- =====================================================

-- Index for JOIN on bookings.user_id
CREATE INDEX IF NOT EXISTS idx_bookings_user_id 
ON bookings(user_id);

-- Index for JOIN on bookings.property_id
CREATE INDEX IF NOT EXISTS idx_bookings_property_id 
ON bookings(property_id);

-- Index for LEFT JOIN on payments.booking_id
CREATE INDEX IF NOT EXISTS idx_payments_booking_id 
ON payments(booking_id);

-- Composite index for ORDER BY and common filters
CREATE INDEX IF NOT EXISTS idx_bookings_date_status 
ON bookings(booking_date DESC, status);

-- Covering index for bookings (includes frequently accessed columns)
CREATE INDEX IF NOT EXISTS idx_bookings_covering 
ON bookings(booking_date DESC, user_id, property_id, booking_id, start_date, end_date, total_price, status);


-- =====================================================
-- STEP 3: OPTIMIZED QUERY - VERSION 1
-- Remove unnecessary columns, add practical filters
-- =====================================================

EXPLAIN ANALYZE
SELECT 
    -- Only essential booking columns
    b.booking_id,
    b.booking_date,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    -- Essential user columns (removed phone, separated names)
    u.user_id,
    u.username,
    u.email,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    
    -- Essential property columns (removed description)
    p.property_id,
    p.property_name,
    p.location,
    p.price_per_night,
    
    -- Payment essentials only
    pm.payment_id,
    pm.payment_status,
    pm.payment_amount
    
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pm ON b.booking_id = pm.booking_id

-- Add practical filter (last 6 months only)
WHERE b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)

-- Use index for sorting
ORDER BY b.booking_date DESC

-- Limit results for pagination
LIMIT 100;

/*
OPTIMIZATIONS APPLIED:
1. Removed large TEXT columns (description)
2. Removed rarely used columns (phone_number)
3. Added WHERE clause to filter recent bookings
4. Added LIMIT for pagination
5. Indexes ensure Index Scan instead of Seq Scan
6. Reduced I/O by selecting fewer columns

EXPECTED IMPROVEMENT:
- Before: 500-1000ms (Seq Scan)
- After: 10-50ms (Index Scan)
- 90-95% performance improvement
*/


-- =====================================================
-- STEP 4: OPTIMIZED QUERY - VERSION 2
-- Using subquery for conditional payment join
-- =====================================================

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.booking_date,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.user_id,
    u.username,
    u.email,
    
    p.property_id,
    p.property_name,
    p.location,
    p.price_per_night,
    
    -- Only join payment if booking is confirmed
    CASE 
        WHEN b.status = 'confirmed' THEN pm.payment_status
        ELSE NULL
    END AS payment_status,
    CASE 
        WHEN b.status = 'confirmed' THEN pm.payment_amount
        ELSE NULL
    END AS payment_amount
    
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pm ON b.booking_id = pm.booking_id 
    AND b.status = 'confirmed'  -- Conditional join
    
WHERE b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
  AND b.status IN ('confirmed', 'pending', 'completed')
  
ORDER BY b.booking_date DESC
LIMIT 100;

/*
OPTIMIZATION: Conditional JOIN
- Only joins payments for confirmed bookings
- Reduces unnecessary payment table lookups
- Filters applied during JOIN instead of after
*/


-- =====================================================
-- STEP 5: OPTIMIZED QUERY - VERSION 3
-- Using CTE for better readability and optimization
-- =====================================================

EXPLAIN ANALYZE
WITH recent_bookings AS (
    -- Pre-filter bookings with index
    SELECT 
        booking_id,
        booking_date,
        start_date,
        end_date,
        total_price,
        status,
        user_id,
        property_id
    FROM bookings
    WHERE booking_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    ORDER BY booking_date DESC
    LIMIT 100
)
SELECT 
    rb.booking_id,
    rb.booking_date,
    rb.start_date,
    rb.end_date,
    rb.total_price,
    rb.status,
    
    u.username,
    u.email,
    
    p.property_name,
    p.location,
    p.price_per_night,
    
    pm.payment_status,
    pm.payment_amount
    
FROM recent_bookings rb
INNER JOIN users u ON rb.user_id = u.user_id
INNER JOIN properties p ON rb.property_id = p.property_id
LEFT JOIN payments pm ON rb.booking_id = pm.booking_id

ORDER BY rb.booking_date DESC;

/*
OPTIMIZATION: CTE (Common Table Expression)
- Pre-filters and limits bookings first
- Reduces join set size dramatically
- Clearer query structure
- Better query plan in most databases
*/


-- =====================================================
-- STEP 6: OPTIMIZED QUERY - VERSION 4
-- For specific use cases (e.g., user dashboard)
-- =====================================================

-- When you need bookings for a specific user
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.booking_date,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    p.property_name,
    p.location,
    p.price_per_night,
    
    pm.payment_status
    
FROM bookings b
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pm ON b.booking_id = pm.booking_id

-- Highly selective filter on indexed column
WHERE b.user_id = 123

ORDER BY b.booking_date DESC;

/*
OPTIMIZATION: Remove unnecessary joins
- User details not needed (already known)
- Highly selective WHERE clause
- Smallest possible result set
- Can use covering index
*/


-- =====================================================
-- STEP 7: MATERIALIZED VIEW (for frequent queries)
-- =====================================================

-- Create materialized view for dashboard queries
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_recent_bookings_summary AS
SELECT 
    b.booking_id,
    b.booking_date,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.user_id,
    u.username,
    u.email,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    
    p.property_id,
    p.property_name,
    p.location,
    p.price_per_night,
    
    pm.payment_id,
    pm.payment_status,
    pm.payment_amount,
    pm.payment_date
    
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pm ON b.booking_id = pm.booking_id

WHERE b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH);

-- Create index on materialized view
CREATE INDEX idx_mv_bookings_date ON mv_recent_bookings_summary(booking_date DESC);
CREATE INDEX idx_mv_bookings_user ON mv_recent_bookings_summary(user_id);
CREATE INDEX idx_mv_bookings_property ON mv_recent_bookings_summary(property_id);

-- Query the materialized view (extremely fast)
SELECT * FROM mv_recent_bookings_summary
WHERE booking_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
ORDER BY booking_date DESC
LIMIT 100;

-- Refresh materialized view periodically (e.g., hourly via cron job)
REFRESH MATERIALIZED VIEW mv_recent_bookings_summary;

/*
OPTIMIZATION: Materialized View
- Pre-computed join results
- Indexed for fast queries
- Refresh periodically (not real-time)
- Best for dashboards and reports
- 99% faster than live queries
*/


-- =====================================================
-- STEP 8: PERFORMANCE COMPARISON
-- =====================================================

-- Compare execution plans

-- Original query (poor performance)
EXPLAIN (FORMAT JSON, ANALYZE)
SELECT * FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pm ON b.booking_id = pm.booking_id
ORDER BY b.booking_date DESC;

-- Optimized query (good performance)
EXPLAIN (FORMAT JSON, ANALYZE)
SELECT 
    b.booking_id, b.booking_date, b.start_date, b.end_date,
    b.total_price, b.status,
    u.username, u.email,
    p.property_name, p.location,
    pm.payment_status
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments pm ON b.booking_id = pm.booking_id
WHERE b.booking_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY b.booking_date DESC
LIMIT 100;

