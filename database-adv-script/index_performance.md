-- =====================================================
-- DATABASE INDEX OPTIMIZATION
-- Performance improvement through strategic indexing
-- =====================================================

-- =====================================================
-- STEP 1: IDENTIFY HIGH-USAGE COLUMNS
-- =====================================================

/*
HIGH-USAGE COLUMNS ANALYSIS:

USERS TABLE:
- user_id: Primary key (already indexed), used in JOINs
- email: Used in WHERE clauses for login/authentication
- username: Used in WHERE clauses for searches
- created_at: Used in ORDER BY for sorting users

BOOKINGS TABLE:
- booking_id: Primary key (already indexed)
- user_id: Foreign key, heavily used in JOINs
- property_id: Foreign key, heavily used in JOINs
- booking_date: Used in WHERE, ORDER BY (date range queries)
- status: Used in WHERE clauses (filtering by status)
- created_at: Used in ORDER BY for sorting bookings

PROPERTIES TABLE:
- property_id: Primary key (already indexed)
- location: Used in WHERE clauses for location searches
- price_per_night: Used in WHERE, ORDER BY (price filtering/sorting)
- created_at: Used in ORDER BY for sorting properties

REVIEWS TABLE:
- review_id: Primary key (already indexed)
- property_id: Foreign key, used in JOINs
- user_id: Foreign key, used in JOINs
- rating: Used in WHERE, ORDER BY, aggregate functions
- created_at: Used in ORDER BY for sorting reviews
*/


-- =====================================================
-- STEP 2: CREATE INDEXES
-- =====================================================

-- USERS TABLE INDEXES
-- Index on email for fast login queries
CREATE INDEX idx_users_email ON users(email);

-- Index on username for user searches
CREATE INDEX idx_users_username ON users(username);

-- Index on created_at for chronological sorting
CREATE INDEX idx_users_created_at ON users(created_at DESC);


-- BOOKINGS TABLE INDEXES
-- Index on user_id for JOIN operations
CREATE INDEX idx_bookings_user_id ON bookings(user_id);

-- Index on property_id for JOIN operations
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- Index on booking_date for date range queries
CREATE INDEX idx_bookings_booking_date ON bookings(booking_date);

-- Index on status for filtering bookings by status
CREATE INDEX idx_bookings_status ON bookings(status);

-- Composite index for common query patterns (user + date)
CREATE INDEX idx_bookings_user_date ON bookings(user_id, booking_date DESC);

-- Composite index for property availability queries
CREATE INDEX idx_bookings_property_date_status ON bookings(property_id, booking_date, status);


-- PROPERTIES TABLE INDEXES
-- Index on location for location-based searches
CREATE INDEX idx_properties_location ON properties(location);

-- Index on price_per_night for price filtering and sorting
CREATE INDEX idx_properties_price ON properties(price_per_night);

-- Composite index for location and price queries
CREATE INDEX idx_properties_location_price ON properties(location, price_per_night);

-- Index on created_at for sorting by newest properties
CREATE INDEX idx_properties_created_at ON properties(created_at DESC);


-- REVIEWS TABLE INDEXES
-- Index on property_id for JOIN operations
CREATE INDEX idx_reviews_property_id ON reviews(property_id);

-- Index on user_id for JOIN operations
CREATE INDEX idx_reviews_user_id ON reviews(user_id);

-- Index on rating for filtering and sorting by rating
CREATE INDEX idx_reviews_rating ON reviews(rating DESC);

-- Composite index for property reviews with ratings
CREATE INDEX idx_reviews_property_rating ON reviews(property_id, rating DESC);


-- =====================================================
-- STEP 3: PERFORMANCE MEASUREMENT QUERIES
-- =====================================================

-- ----------------------------------------------------
-- TEST QUERY 1: Find user by email (Login scenario)
-- ----------------------------------------------------

-- BEFORE INDEX (Run this after dropping idx_users_email if it exists)
EXPLAIN ANALYZE
SELECT user_id, username, email, created_at
FROM users
WHERE email = 'john.doe@example.com';

-- Expected: Seq Scan (Full table scan)


-- AFTER INDEX
EXPLAIN ANALYZE
SELECT user_id, username, email, created_at
FROM users
WHERE email = 'john.doe@example.com';

-- Expected: Index Scan using idx_users_email


-- ----------------------------------------------------
-- TEST QUERY 2: Get all bookings for a user
-- ----------------------------------------------------

-- BEFORE INDEX
EXPLAIN ANALYZE
SELECT b.booking_id, b.booking_date, b.status, p.property_name
FROM bookings b
JOIN properties p ON b.property_id = p.property_id
WHERE b.user_id = 123
ORDER BY b.booking_date DESC;

-- Expected: Seq Scan on bookings


-- AFTER INDEX
EXPLAIN ANALYZE
SELECT b.booking_id, b.booking_date, b.status, p.property_name
FROM bookings b
JOIN properties p ON b.property_id = p.property_id
WHERE b.user_id = 123
ORDER BY b.booking_date DESC;

-- Expected: Index Scan using idx_bookings_user_date


-- ----------------------------------------------------
-- TEST QUERY 3: Find properties by location and price range
-- ----------------------------------------------------

-- BEFORE INDEX
EXPLAIN ANALYZE
SELECT property_id, property_name, location, price_per_night
FROM properties
WHERE location = 'New York'
  AND price_per_night BETWEEN 100 AND 300
ORDER BY price_per_night;

-- Expected: Seq Scan with Filter


-- AFTER INDEX
EXPLAIN ANALYZE
SELECT property_id, property_name, location, price_per_night
FROM properties
WHERE location = 'New York'
  AND price_per_night BETWEEN 100 AND 300
ORDER BY price_per_night;

-- Expected: Index Scan using idx_properties_location_price


-- ----------------------------------------------------
-- TEST QUERY 4: Get properties with average rating > 4.0
-- ----------------------------------------------------

-- BEFORE INDEX
EXPLAIN ANALYZE
SELECT p.property_id, p.property_name, AVG(r.rating) as avg_rating
FROM properties p
JOIN reviews r ON p.property_id = r.property_id
GROUP BY p.property_id, p.property_name
HAVING AVG(r.rating) > 4.0
ORDER BY avg_rating DESC;

-- Expected: Hash Join with Seq Scans


-- AFTER INDEX
EXPLAIN ANALYZE
SELECT p.property_id, p.property_name, AVG(r.rating) as avg_rating
FROM properties p
JOIN reviews r ON p.property_id = r.property_id
GROUP BY p.property_id, p.property_name
HAVING AVG(r.rating) > 4.0
ORDER BY avg_rating DESC;

-- Expected: Hash Join with Index Scans using idx_reviews_property_id


-- ----------------------------------------------------
-- TEST QUERY 5: Find available properties for date range
-- ----------------------------------------------------

-- BEFORE INDEX
EXPLAIN ANALYZE
SELECT DISTINCT p.property_id, p.property_name, p.location
FROM properties p
WHERE p.property_id NOT IN (
    SELECT property_id
    FROM bookings
    WHERE booking_date BETWEEN '2024-12-01' AND '2024-12-07'
      AND status = 'confirmed'
);

-- Expected: Seq Scan with SubPlan


-- AFTER INDEX
EXPLAIN ANALYZE
SELECT DISTINCT p.property_id, p.property_name, p.location
FROM properties p
WHERE p.property_id NOT IN (
    SELECT property_id
    FROM bookings
    WHERE booking_date BETWEEN '2024-12-01' AND '2024-12-07'
      AND status = 'confirmed'
);

-- Expected: Index Scan using idx_bookings_property_date_status


-- =====================================================
-- STEP 4: INDEX MAINTENANCE COMMANDS
-- =====================================================

-- View all indexes on a table
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'bookings';

-- Check index usage statistics
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as index_scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM 
    pg_stat_user_indexes
WHERE 
    schemaname = 'public'
ORDER BY 
    idx_scan DESC;

-- Find unused indexes
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan
FROM 
    pg_stat_user_indexes
WHERE 
    schemaname = 'public'
    AND idx_scan = 0
    AND indexname NOT LIKE '%_pkey';

-- Rebuild/reindex if needed (for maintenance)
REINDEX TABLE bookings;
REINDEX TABLE properties;
REINDEX TABLE users;
REINDEX TABLE reviews;


-- =====================================================
-- STEP 5: DROP INDEXES (if needed for testing)
-- =====================================================

-- DROP INDEX idx_users_email;
-- DROP INDEX idx_users_username;
-- DROP INDEX idx_users_created_at;
-- DROP INDEX idx_bookings_user_id;
-- DROP INDEX idx_bookings_property_id;
-- DROP INDEX idx_bookings_booking_date;
-- DROP INDEX idx_bookings_status;
-- DROP INDEX idx_bookings_user_date;
-- DROP INDEX idx_bookings_property_date_status;
-- DROP INDEX idx_properties_location;
-- DROP INDEX idx_properties_price;
-- DROP INDEX idx_properties_location_price;
-- DROP INDEX idx_properties_created_at;
-- DROP INDEX idx_reviews_property_id;
-- DROP INDEX idx_reviews_user_id;
-- DROP INDEX idx_reviews_rating;
-- DROP INDEX idx_reviews_property_rating;


-- =====================================================
-- PERFORMANCE METRICS TO COMPARE
-- =====================================================

/*
METRICS TO TRACK:

1. Execution Time
   - Before: Total query execution time
   - After: Total query execution time
   - Improvement: Percentage reduction

2. Planning Time
   - Time spent creating query plan

3. Execution Plan
   - Seq Scan vs Index Scan
   - Number of rows scanned

4. Cost
   - Estimated cost units from EXPLAIN

EXAMPLE RESULTS:
Query 1 (Find user by email):
- Before: Seq Scan, 50ms, Cost: 1000
- After: Index Scan, 2ms, Cost: 10
- Improvement: 96% faster

Query 2 (User bookings):
- Before: Seq Scan + Sort, 120ms
- After: Index Scan (pre-sorted), 8ms
- Improvement: 93% faster

Query 3 (Location + Price search):
- Before: Seq Scan + Filter, 200ms
- After: Index Scan, 15ms
- Improvement: 92% faster
*/


-- =====================================================
-- BEST PRACTICES AND NOTES
-- =====================================================

/*
INDEX BEST PRACTICES:

1. Index Selectivity
   - High selectivity (many unique values): Good for indexing
   - Low selectivity (few unique values): May not benefit from index
   - Example: status column with only 3 values might not need separate index

2. Composite Indexes
   - Order matters: most selective column first
   - Useful for queries filtering/sorting on multiple columns
   - Can serve queries on leftmost columns only

3. Index Overhead
   - Indexes consume disk space
   - Slow down INSERT, UPDATE, DELETE operations
   - Balance read performance vs write performance

4. When NOT to Index
   - Small tables (< 1000 rows)
   - Columns with low selectivity
   - Frequently updated columns
   - Columns rarely used in queries

5. Monitoring
   - Regularly check index usage statistics
   - Remove unused indexes
   - Update statistics for query planner

6. Database-Specific Syntax
   - PostgreSQL: EXPLAIN ANALYZE
   - MySQL: EXPLAIN
   - SQL Server: SET STATISTICS TIME ON
   - Oracle: EXPLAIN PLAN
