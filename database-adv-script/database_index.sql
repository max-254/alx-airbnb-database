-- ============================================
-- Airbnb Database - CREATE INDEX Statements
-- Performance Optimization for All Tables
-- ============================================

-- ============================================
-- USER TABLE INDEXES
-- ============================================

-- Index on email for login queries (already UNIQUE, but explicit index helps)
CREATE INDEX idx_user_email ON User(email);

-- Index on role for filtering by user type
CREATE INDEX idx_user_role ON User(role);

-- Index on created_at for user registration analytics
CREATE INDEX idx_user_created_at ON User(created_at);

-- Composite index for role and created_at (useful for admin dashboards)
CREATE INDEX idx_user_role_created ON User(role, created_at);

-- Index on phone_number for contact lookups
CREATE INDEX idx_user_phone ON User(phone_number);

-- Index on last_name and first_name for name searches
CREATE INDEX idx_user_name ON User(last_name, first_name);

-- ============================================
-- PROPERTY TABLE INDEXES
-- ============================================

-- Index on host_id (Foreign Key) - Critical for JOIN operations
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on property_type for filtering by type
CREATE INDEX idx_property_type ON Property(property_type);

-- Index on price_per_night for price range queries
CREATE INDEX idx_property_price ON Property(price_per_night);

-- Index on is_active for filtering active/inactive properties
CREATE INDEX idx_property_active ON Property(is_active);

-- Index on created_at for listing date queries
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Composite index for active properties with price range
CREATE INDEX idx_property_active_price ON Property(is_active, price_per_night);

-- Composite index for property type and price (common filter combination)
CREATE INDEX idx_property_type_price ON Property(property_type, price_per_night);

-- Index on max_guests for guest capacity searches
CREATE INDEX idx_property_max_guests ON Property(max_guests);

-- Composite index for bedrooms and bathrooms (common search criteria)
CREATE INDEX idx_property_beds_baths ON Property(bedrooms, bathrooms);

-- Full-text index on title and description for search functionality
CREATE FULLTEXT INDEX idx_property_search ON Property(title, description);

-- ============================================
-- LOCATION TABLE INDEXES
-- ============================================

-- Index on property_id (Foreign Key) - Already UNIQUE but explicit for clarity
CREATE INDEX idx_location_property_id ON Location(property_id);

-- Index on city for location-based searches
CREATE INDEX idx_location_city ON Location(city);

-- Index on state for state-level searches
CREATE INDEX idx_location_state ON Location(state);

-- Index on country for country-level searches
CREATE INDEX idx_location_country ON Location(country);

-- Composite index for city and state (common search pattern)
CREATE INDEX idx_location_city_state ON Location(city, state);

-- Composite index for country, state, city (hierarchical search)
CREATE INDEX idx_location_hierarchy ON Location(country, state, city);

-- Spatial index on coordinates for proximity searches
CREATE INDEX idx_location_coordinates ON Location(latitude, longitude);

-- Index on postal_code for zip code searches
CREATE INDEX idx_location_postal ON Location(postal_code);

-- ============================================
-- PROPERTY_IMAGE TABLE INDEXES
-- ============================================

-- Index on property_id (Foreign Key) - Critical for retrieving property images
CREATE INDEX idx_image_property_id ON Property_Image(property_id);

-- Index on is_primary for finding primary images quickly
CREATE INDEX idx_image_is_primary ON Property_Image(is_primary);

-- Composite index for property and primary image
CREATE INDEX idx_image_property_primary ON Property_Image(property_id, is_primary);

-- Index on display_order for sorting images
CREATE INDEX idx_image_display_order ON Property_Image(property_id, display_order);

-- Index on uploaded_at for recent images
CREATE INDEX idx_image_uploaded_at ON Property_Image(uploaded_at);

-- ============================================
-- AMENITY TABLE INDEXES
-- ============================================

-- Index on property_id (Foreign Key)
CREATE INDEX idx_amenity_property_id ON Amenity(property_id);

-- Index on amenity_name for filtering by amenity type
CREATE INDEX idx_amenity_name ON Amenity(amenity_name);

-- Composite index for property and amenity (prevents duplicates, speeds lookups)
CREATE INDEX idx_amenity_property_name ON Amenity(property_id, amenity_name);

-- ============================================
-- BOOKING TABLE INDEXES
-- ============================================

-- Index on property_id (Foreign Key) - Critical for property bookings
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index on guest_id (Foreign Key) - Critical for user bookings
CREATE INDEX idx_booking_guest_id ON Booking(guest_id);

-- Index on status for filtering by booking status
CREATE INDEX idx_booking_status ON Booking(status);

-- Index on check_in_date for date-based queries
CREATE INDEX idx_booking_check_in ON Booking(check_in_date);

-- Index on check_out_date for date-based queries
CREATE INDEX idx_booking_check_out ON Booking(check_out_date);

-- Composite index for date range searches (most common query pattern)
CREATE INDEX idx_booking_dates ON Booking(check_in_date, check_out_date);

-- Composite index for property availability checks
CREATE INDEX idx_booking_property_dates ON Booking(property_id, check_in_date, check_out_date);

-- Composite index for property and status
CREATE INDEX idx_booking_property_status ON Booking(property_id, status);

-- Composite index for guest bookings by status
CREATE INDEX idx_booking_guest_status ON Booking(guest_id, status);

-- Index on created_at for booking history
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Index on total_price for revenue analytics
CREATE INDEX idx_booking_total_price ON Booking(total_price);

-- Composite index for upcoming bookings (common dashboard query)
CREATE INDEX idx_booking_upcoming ON Booking(status, check_in_date) 
WHERE status IN ('confirmed', 'pending');

-- ============================================
-- PAYMENT TABLE INDEXES
-- ============================================

-- Index on booking_id (Foreign Key)
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index on user_id (Foreign Key)
CREATE INDEX idx_payment_user_id ON Payment(user_id);

-- Index on status for payment status queries
CREATE INDEX idx_payment_status ON Payment(status);

-- Index on payment_method for payment method analytics
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Index on payment_date for date-based financial reports
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Index on transaction_id (already UNIQUE, but explicit for lookups)
CREATE INDEX idx_payment_transaction ON Payment(transaction_id);

-- Composite index for user payment history
CREATE INDEX idx_payment_user_date ON Payment(user_id, payment_date);

-- Composite index for payment status and date (financial dashboards)
CREATE INDEX idx_payment_status_date ON Payment(status, payment_date);

-- Index on amount for financial analytics
CREATE INDEX idx_payment_amount ON Payment(amount);

-- ============================================
-- REVIEW TABLE INDEXES
-- ============================================

-- Index on property_id (Foreign Key) - Critical for property reviews
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index on user_id (Foreign Key) - For user review history
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Index on booking_id (Foreign Key and UNIQUE)
CREATE INDEX idx_review_booking_id ON Review(booking_id);

-- Index on rating for rating-based queries
CREATE INDEX idx_review_rating ON Review(rating);

-- Index on created_at for recent reviews
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index for property ratings (average rating calculations)
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- Composite index for property and date (recent reviews for property)
CREATE INDEX idx_review_property_date ON Review(property_id, created_at);

-- Full-text index on comment for review text search
CREATE FULLTEXT INDEX idx_review_comment ON Review(comment);

-- ============================================
-- MESSAGE TABLE INDEXES
-- ============================================

-- Index on sender_id (Foreign Key)
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Index on recipient_id (Foreign Key)
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Index on booking_id (Foreign Key)
CREATE INDEX idx_message_booking_id ON Message(booking_id);

-- Index on is_read for unread message queries
CREATE INDEX idx_message_is_read ON Message(is_read);

-- Index on sent_at for chronological ordering
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for user inbox (recipient + read status)
CREATE INDEX idx_message_inbox ON Message(recipient_id, is_read, sent_at);

-- Composite index for conversation threads
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- Composite index for booking-related messages
CREATE INDEX idx_message_booking_date ON Message(booking_id, sent_at);

-- Full-text index on message_body for message search
CREATE FULLTEXT INDEX idx_message_body ON Message(message_body);

-- ============================================
-- SPECIALIZED INDEXES FOR COMMON QUERIES
-- ============================================

-- Covering index for property search results (includes commonly selected columns)
CREATE INDEX idx_property_search_covering ON Property(
    is_active, 
    property_type, 
    price_per_night, 
    max_guests, 
    bedrooms, 
    bathrooms
);

-- Covering index for booking availability check
CREATE INDEX idx_booking_availability ON Booking(
    property_id, 
    status, 
    check_in_date, 
    check_out_date
) WHERE status IN ('confirmed', 'pending');

-- Index for property performance analytics
CREATE INDEX idx_property_performance ON Property(
    host_id, 
    is_active, 
    created_at
);

-- Index for user activity tracking
CREATE INDEX idx_user_activity ON User(
    role, 
    created_at
);

-- ============================================
-- PARTIAL INDEXES (for PostgreSQL)
-- Comment out if using MySQL
-- ============================================

-- Partial index for active properties only
-- CREATE INDEX idx_property_active_only ON Property(property_id, price_per_night) 
-- WHERE is_active = TRUE;

-- Partial index for confirmed bookings only
-- CREATE INDEX idx_booking_confirmed_only ON Booking(property_id, check_in_date) 
-- WHERE status = 'confirmed';

-- Partial index for completed payments only
-- CREATE INDEX idx_payment_completed_only ON Payment(user_id, amount, payment_date) 
-- WHERE status = 'completed';

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- View all indexes on a specific table
-- SHOW INDEX FROM User;
-- SHOW INDEX FROM Property;
-- SHOW INDEX FROM Booking;

-- Check index usage (MySQL)
-- SHOW INDEX FROM table_name;

-- Analyze table statistics (helps optimizer use indexes effectively)
ANALYZE TABLE User;
ANALYZE TABLE Property;
ANALYZE TABLE Location;
ANALYZE TABLE Property_Image;
ANALYZE TABLE Amenity;
ANALYZE TABLE Booking;
ANALYZE TABLE Payment;
ANALYZE TABLE Review;
ANALYZE TABLE Message;

-- ============================================
-- INDEX MAINTENANCE COMMANDS
-- ============================================

-- Drop an index if needed
-- DROP INDEX idx_name ON table_name;

-- Rebuild indexes (MySQL)
-- ALTER TABLE table_name ENGINE=InnoDB;

-- Optimize tables to defragment and rebuild indexes
-- OPTIMIZE TABLE User, Property, Booking, Payment, Review;

-- ============================================
-- PERFORMANCE MONITORING QUERIES
-- ============================================

-- Check unused indexes (MySQL 8.0+)
-- SELECT * FROM sys.schema_unused_indexes;

-- Check index statistics
-- SELECT 
--     TABLE_NAME,
--     INDEX_NAME,
--     SEQ_IN_INDEX,
--     COLUMN_NAME,
--     CARDINALITY
-- FROM information_schema.STATISTICS
-- WHERE TABLE_SCHEMA = 'airbnb_db'
-- ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

-- ============================================
-- INDEX BEST PRACTICES NOTES
-- ============================================

/*
1. FOREIGN KEY INDEXES:
   - Always index foreign key columns for JOIN performance
   - Critical for referential integrity checks

2. WHERE CLAUSE INDEXES:
   - Index columns frequently used in WHERE clauses
   - Especially important for status, date ranges, and boolean flags

3. ORDER BY INDEXES:
   - Index columns used in ORDER BY clauses
   - Composite indexes should match ORDER BY order

4. COMPOSITE INDEXES:
   - Order matters: most selective column first
   - Useful for queries filtering on multiple columns
   - Can satisfy queries using leftmost prefix

5. COVERING INDEXES:
   - Include all columns needed by a query
   - Eliminates need to access table data
   - Trade-off: larger index size

6. FULLTEXT INDEXES:
   - Use for text search on large text columns
   - Required for MATCH...AGAINST queries
   - MySQL: Requires MyISAM or InnoDB (5.6+)

7. UNIQUE INDEXES:
   - Automatically created for PRIMARY KEY and UNIQUE constraints
   - Enforce data integrity while improving performance

8. INDEX MAINTENANCE:
   - Regularly analyze tables to update statistics
   - Monitor index usage and remove unused indexes
   - Rebuild fragmented indexes periodically

9. INDEX OVERHEAD:
   - Each index slows down INSERT/UPDATE/DELETE operations
   - Balance read performance vs write performance
   - Don't over-index: only create indexes that will be used

10. QUERY OPTIMIZATION:
    - Use EXPLAIN to verify index usage
    - Check for full table scans
    - Ensure indexes are being utilized by queries
*/

-- ============================================
-- EXAMPLE: Verify Index Usage with EXPLAIN
-- ============================================

-- Check if booking date range query uses index
EXPLAIN SELECT * FROM Booking 
WHERE property_id = '650e8400-e29b-41d4-a716-446655440001'
AND check_in_date >= '2024-12-01' 
AND check_out_date <= '2024-12-31';

-- Check if property search uses indexes
EXPLAIN SELECT p.*, l.city, l.state 
FROM Property p
INNER JOIN Location l ON p.property_id = l.property_id
WHERE p.is_active = TRUE 
AND p.property_type = 'apartment'
AND p.price_per_night BETWEEN 100 AND 300
ORDER BY p.price_per_night;

-- ============================================
-- SUCCESS MESSAGE
-- ============================================

SELECT 'All indexes created successfully!' AS Status;
SELECT 'Run ANALYZE TABLE on all tables to update statistics' AS Recommendation;


/*
Alternative solution

*/

-- ============================================
-- EXPLAIN ANALYZE - Query Performance Analysis
-- Airbnb Database Performance Testing
-- ============================================

-- ============================================
-- WHAT IS EXPLAIN ANALYZE?
-- ============================================
/*
EXPLAIN ANALYZE executes the query and provides:
1. Query execution plan (how the database processes the query)
2. Actual execution time
3. Number of rows examined vs returned
4. Index usage
5. Join strategies
6. Filtering methods

MySQL: Use EXPLAIN or EXPLAIN ANALYZE (MySQL 8.0.18+)
PostgreSQL: Use EXPLAIN ANALYZE
*/

-- ============================================
-- 1. SIMPLE SELECT WITH INDEX
-- ============================================

-- Query: Find active properties
EXPLAIN ANALYZE
SELECT 
    property_id,
    title,
    price_per_night
FROM 
    Property
WHERE 
    is_active = TRUE;

/*
EXPECTED OUTPUT:
- Uses idx_property_active index
- Type: ref (index lookup)
- Rows examined should be close to rows returned
- Execution time: < 10ms for small dataset
*/

-- ============================================
-- 2. BOOKING DATE RANGE QUERY
-- ============================================

-- Query: Find bookings in December 2024
EXPLAIN ANALYZE
SELECT 
    booking_id,
    property_id,
    guest_id,
    check_in_date,
    check_out_date,
    total_price,
    status
FROM 
    Booking
WHERE 
    check_in_date BETWEEN '2024-12-01' AND '2024-12-31';

/*
EXPECTED OUTPUT:
- Uses idx_booking_check_in or idx_booking_dates
- Type: range (range scan on index)
- Shows how many rows were scanned vs returned
*/

-- ============================================
-- 3. INNER JOIN WITH INDEXES
-- ============================================

-- Query: Bookings with user information
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.first_name,
    u.last_name,
    u.email
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
WHERE 
    b.status = 'confirmed';

/*
EXPECTED OUTPUT:
- Booking table uses idx_booking_status
- Join uses idx_booking_guest_id and User primary key
- Type: ref for both tables
- Join type: eq_ref (best case for joins)
*/

-- ============================================
-- 4. MULTIPLE JOIN QUERY
-- ============================================

-- Query: Complete booking details with property and location
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    u.first_name,
    u.last_name,
    p.title AS property_title,
    l.city,
    l.state,
    b.check_in_date,
    b.total_price
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    Location l ON p.property_id = l.property_id
WHERE 
    b.check_in_date >= CURDATE()
    AND b.status = 'confirmed'
ORDER BY 
    b.check_in_date ASC;

/*
EXPECTED OUTPUT:
- Shows join order (which table is scanned first)
- Index usage on all foreign keys
- Uses idx_booking_status and idx_booking_check_in
- Temporary table for sorting (if no index covers ORDER BY)
*/

-- ============================================
-- 5. LEFT JOIN QUERY
-- ============================================

-- Query: All properties with review count
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.title,
    COUNT(r.review_id) AS review_count,
    AVG(r.rating) AS avg_rating
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.title;

/*
EXPECTED OUTPUT:
- Property table: full scan or index scan
- Review table: uses idx_review_property_id
- Shows grouping/aggregation cost
- Using temporary table for GROUP BY
*/

-- ============================================
-- 6. COMPLEX WHERE CLAUSE WITH MULTIPLE CONDITIONS
-- ============================================

-- Query: Property search with multiple filters
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.title,
    p.property_type,
    p.price_per_night,
    l.city,
    l.state
FROM 
    Property p
INNER JOIN 
    Location l ON p.property_id = l.property_id
WHERE 
    p.is_active = TRUE
    AND p.property_type = 'apartment'
    AND p.price_per_night BETWEEN 100 AND 300
    AND p.max_guests >= 4
    AND l.city = 'New York'
ORDER BY 
    p.price_per_night ASC;

/*
EXPECTED OUTPUT:
- Index merge or single index usage
- Uses idx_property_active_price or idx_property_type_price
- Location filter uses idx_location_city
- Shows number of rows filtered at each step
*/

-- ============================================
-- 7. AGGREGATE QUERY WITH GROUP BY
-- ============================================

-- Query: Revenue by property
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.title,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue,
    AVG(b.total_price) AS avg_booking_value
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
WHERE 
    b.status IN ('confirmed', 'completed')
GROUP BY 
    p.property_id, p.title
HAVING 
    COUNT(b.booking_id) > 0
ORDER BY 
    total_revenue DESC;

/*
EXPECTED OUTPUT:
- Uses idx_booking_property_id and idx_booking_status
- Shows temporary table creation for grouping
- Filesort for ORDER BY if no covering index
- HAVING filter applied after aggregation
*/

-- ============================================
-- 8. SUBQUERY ANALYSIS
-- ============================================

-- Query: Properties with above-average price
EXPLAIN ANALYZE
SELECT 
    property_id,
    title,
    price_per_night
FROM 
    Property
WHERE 
    price_per_night > (
        SELECT AVG(price_per_night)
        FROM Property
        WHERE is_active = TRUE
    )
    AND is_active = TRUE
ORDER BY 
    price_per_night DESC;

/*
EXPECTED OUTPUT:
- Shows subquery execution (SUBQUERY or DEPENDENT SUBQUERY)
- Index usage on both main query and subquery
- Number of subquery executions
*/

-- ============================================
-- 9. FULL-TEXT SEARCH QUERY
-- ============================================

-- Query: Search properties by text
EXPLAIN ANALYZE
SELECT 
    property_id,
    title,
    description,
    price_per_night,
    MATCH(title, description) AGAINST('beach ocean view') AS relevance_score
FROM 
    Property
WHERE 
    MATCH(title, description) AGAINST('beach ocean view' IN NATURAL LANGUAGE MODE)
    AND is_active = TRUE
ORDER BY 
    relevance_score DESC;

/*
EXPECTED OUTPUT:
- Uses idx_property_search (FULLTEXT index)
- Type: fulltext
- Shows relevance scoring cost
*/

-- ============================================
-- 10. BOOKING AVAILABILITY CHECK
-- ============================================

-- Query: Check if property is available for dates
EXPLAIN ANALYZE
SELECT 
    booking_id,
    check_in_date,
    check_out_date,
    status
FROM 
    Booking
WHERE 
    property_id = '650e8400-e29b-41d4-a716-446655440001'
    AND status IN ('confirmed', 'pending')
    AND (
        (check_in_date <= '2024-12-25' AND check_out_date >= '2024-12-20')
    );

/*
EXPECTED OUTPUT:
- Uses idx_booking_property_dates composite index
- Shows date range overlap logic
- Type: range or ref
*/

-- ============================================
-- 11. INEFFICIENT QUERY (WITHOUT INDEX)
-- ============================================

-- Query: Search by description (no full-text index scenario)
EXPLAIN ANALYZE
SELECT 
    property_id,
    title,
    description
FROM 
    Property
WHERE 
    description LIKE '%mountain%';

/*
EXPECTED OUTPUT:
- Type: ALL (full table scan - BAD!)
- No index usage (LIKE with leading wildcard can't use index)
- High execution time
- Many rows examined
*/

-- ============================================
-- 12. OPTIMIZED VERSION OF ABOVE
-- ============================================

-- Query: Better search using full-text
EXPLAIN ANALYZE
SELECT 
    property_id,
    title,
    description
FROM 
    Property
WHERE 
    MATCH(description) AGAINST('mountain' IN NATURAL LANGUAGE MODE);

/*
EXPECTED OUTPUT:
- Uses FULLTEXT index
- Type: fulltext (GOOD!)
- Much faster than LIKE query
- Fewer rows examined
*/

-- ============================================
-- 13. COVERING INDEX QUERY
-- ============================================

-- Query: Uses covering index (all columns in index)
EXPLAIN ANALYZE
SELECT 
    property_id,
    property_type,
    price_per_night,
    max_guests
FROM 
    Property
WHERE 
    is_active = TRUE
    AND property_type = 'apartment'
ORDER BY 
    price_per_night;

/*
EXPECTED OUTPUT:
- Uses idx_property_search_covering (covering index)
- Extra: Using index (doesn't need to access table data - BEST!)
- Very fast execution
*/

-- ============================================
-- 14. INDEX MERGE SCENARIO
-- ============================================

-- Query: Multiple index usage
EXPLAIN ANALYZE
SELECT 
    property_id,
    title,
    price_per_night
FROM 
    Property
WHERE 
    property_type = 'villa'
    OR price_per_night < 100;

/*
EXPECTED OUTPUT:
- Type: index_merge (uses multiple indexes)
- Shows which indexes are merged
- Union or intersection operation
*/

-- ============================================
-- 15. COMPARE: WITH vs WITHOUT INDEX
-- ============================================

-- First, drop an index to see difference
-- DROP INDEX idx_booking_status ON Booking;

-- Query WITHOUT index
EXPLAIN ANALYZE
SELECT 
    booking_id,
    property_id,
    status
FROM 
    Booking
WHERE 
    status = 'confirmed';

/*
WITHOUT INDEX:
- Type: ALL (full table scan)
- Rows examined: all rows in table
- Slow execution time
*/

-- Recreate the index
-- CREATE INDEX idx_booking_status ON Booking(status);

-- Query WITH index
EXPLAIN ANALYZE
SELECT 
    booking_id,
    property_id,
    status
FROM 
    Booking
WHERE 
    status = 'confirmed';

/*
WITH INDEX:
- Type: ref (index lookup)
- Rows examined: only matching rows
- Fast execution time
*/

-- ============================================
-- 16. PAGINATION QUERY
-- ============================================

-- Query: Paginated results
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.title,
    p.price_per_night,
    l.city
FROM 
    Property p
INNER JOIN 
    Location l ON p.property_id = l.property_id
WHERE 
    p.is_active = TRUE
ORDER BY 
    p.created_at DESC
LIMIT 20 OFFSET 0;

/*
EXPECTED OUTPUT:
- Uses idx_property_created_at for sorting
- LIMIT reduces rows returned
- Shows if filesort is needed
*/

-- ============================================
-- 17. COMPLEX JOIN WITH AGGREGATION
-- ============================================

-- Query: Property performance dashboard
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.title,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    COUNT(DISTINCT r.review_id) AS total_reviews,
    AVG(r.rating) AS avg_rating,
    SUM(b.total_price) AS total_revenue
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
WHERE 
    p.is_active = TRUE
GROUP BY 
    p.property_id, p.title
HAVING 
    COUNT(DISTINCT b.booking_id) > 0;

/*
EXPECTED OUTPUT:
- Multiple index usage for joins
- Temporary table for grouping
- DISTINCT operations cost
- HAVING filter after aggregation
*/

-- ============================================
-- READING EXPLAIN ANALYZE OUTPUT
-- ============================================

/*
KEY METRICS TO LOOK FOR:

1. TYPE (Access Method):
   - const: Single row (best)
   - eq_ref: One row per join (excellent for joins)
   - ref: Multiple rows with index (good)
   - range: Range scan on index (acceptable)
   - index: Full index scan (slow)
   - ALL: Full table scan (worst - needs optimization)

2. POSSIBLE_KEYS:
   - Shows which indexes COULD be used

3. KEY:
   - Shows which index is ACTUALLY used
   - NULL means no index used (bad!)

4. ROWS:
   - Estimated number of rows to examine
   - Lower is better

5. FILTERED:
   - Percentage of rows filtered by WHERE clause
   - Higher is better (closer to 100%)

6. EXTRA:
   - "Using index" = Covering index (excellent!)
   - "Using where" = WHERE clause applied
   - "Using temporary" = Temp table created (can be slow)
   - "Using filesort" = Sorting required (can be slow)
   - "Using join buffer" = Join buffer used (acceptable)

7. EXECUTION TIME:
   - Actual time taken (in EXPLAIN ANALYZE)
   - Compare before/after optimization
*/

-- ============================================
-- OPTIMIZATION TIPS BASED ON EXPLAIN ANALYZE
-- ============================================

/*
1. TYPE = ALL → Add index on WHERE/JOIN columns
2. "Using filesort" → Add index on ORDER BY columns
3. "Using temporary" → Check GROUP BY columns
4. High rows examined → Add more selective indexes
5. No index used → Create appropriate indexes
6. Multiple indexes → Consider composite index
7. Full table scans → Add indexes or rewrite query
8. Subqueries → Consider JOIN instead
9. LIKE '%text%' → Use FULLTEXT index
10. High execution time → Check indexes and query structure
*/

-- ============================================
-- PERFORMANCE COMPARISON TEMPLATE
-- ============================================

-- Before optimization
EXPLAIN ANALYZE
SELECT /* Your slow query here */;

-- Add index
CREATE INDEX idx_optimization ON table_name(column_name);

-- After optimization
EXPLAIN ANALYZE
SELECT /* Same query */;

-- Compare:
-- - Execution time (should be lower)
-- - Rows examined (should be lower)
-- - Type (should be ref or better, not ALL)
-- - Extra (should use index)

-- ============================================
-- MONITORING QUERY PERFORMANCE
-- ============================================

-- Enable slow query log (MySQL)
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1; -- Log queries taking > 1 second

-- View current performance schema
SELECT * FROM performance_schema.events_statements_summary_by_digest
ORDER BY SUM_TIMER_WAIT DESC
LIMIT 10;

-- ============================================
-- SUCCESS INDICATORS
-- ============================================

/*
GOOD PERFORMANCE INDICATORS:
✓ Type: const, eq_ref, ref
✓ Using index in Extra
✓ Low rows examined
✓ High filtered percentage (>80%)
✓ Fast execution time (< 100ms for most queries)
✓ No "Using temporary" or "Using filesort" (or optimized if present)

BAD PERFORMANCE INDICATORS:
✗ Type: ALL (full table scan)
✗ NULL in key column (no index used)
✗ High rows examined vs rows returned
✗ Low filtered percentage (<20%)
✗ Slow execution time (> 1 second)
✗ Multiple "Using temporary" and "Using filesort"
*/
