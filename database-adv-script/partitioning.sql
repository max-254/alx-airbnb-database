-- =====================================================
-- BOOKING TABLE PARTITIONING IMPLEMENTATION
-- Partition by start_date for improved query performance
-- =====================================================

-- =====================================================
-- STEP 1: ANALYZE CURRENT TABLE
-- =====================================================

-- Check current table size and row count
SELECT 
    COUNT(*) AS total_bookings,
    MIN(start_date) AS earliest_booking,
    MAX(start_date) AS latest_booking,
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS size_mb
FROM bookings, information_schema.tables
WHERE table_schema = DATABASE()
  AND table_name = 'bookings';

-- Analyze data distribution by year
SELECT 
    YEAR(start_date) AS booking_year,
    COUNT(*) AS booking_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings), 2) AS percentage
FROM bookings
GROUP BY YEAR(start_date)
ORDER BY booking_year;


-- =====================================================
-- STEP 2: BACKUP EXISTING DATA
-- =====================================================

-- Create backup of existing bookings table
CREATE TABLE bookings_backup AS
SELECT * FROM bookings;

-- Verify backup
SELECT COUNT(*) FROM bookings_backup;


-- =====================================================
-- STEP 3: CREATE PARTITIONED TABLE (RANGE BY YEAR)
-- =====================================================

-- Drop existing table (after backup!)
-- DROP TABLE IF EXISTS bookings;

-- Create new partitioned bookings table
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    number_of_guests INT NOT NULL,
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (booking_id, start_date),  -- Must include partition key
    KEY idx_user_id (user_id),
    KEY idx_property_id (property_id),
    KEY idx_booking_date (booking_date),
    KEY idx_status (status)
    
) PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p_2020 VALUES LESS THAN (2021),
    PARTITION p_2021 VALUES LESS THAN (2022),
    PARTITION p_2022 VALUES LESS THAN (2023),
    PARTITION p_2023 VALUES LESS THAN (2024),
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_2025 VALUES LESS THAN (2026),
    PARTITION p_2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);


-- =====================================================
-- STEP 4: ALTERNATIVE - MONTHLY PARTITIONING
-- (Better for very large tables with frequent queries)
-- =====================================================

-- Create table partitioned by year and month
CREATE TABLE bookings_monthly (
    booking_id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    number_of_guests INT NOT NULL,
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (booking_id, start_date),
    KEY idx_user_id (user_id),
    KEY idx_property_id (property_id),
    KEY idx_booking_date (booking_date),
    KEY idx_status (status)
    
) PARTITION BY RANGE (TO_DAYS(start_date)) (
    PARTITION p_2024_01 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p_2024_02 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p_2024_03 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_2024_04 VALUES LESS THAN (TO_DAYS('2024-05-01')),
    PARTITION p_2024_05 VALUES LESS THAN (TO_DAYS('2024-06-01')),
    PARTITION p_2024_06 VALUES LESS THAN (TO_DAYS('2024-07-01')),
    PARTITION p_2024_07 VALUES LESS THAN (TO_DAYS('2024-08-01')),
    PARTITION p_2024_08 VALUES LESS THAN (TO_DAYS('2024-09-01')),
    PARTITION p_2024_09 VALUES LESS THAN (TO_DAYS('2024-10-01')),
    PARTITION p_2024_10 VALUES LESS THAN (TO_DAYS('2024-11-01')),
    PARTITION p_2024_11 VALUES LESS THAN (TO_DAYS('2024-12-01')),
    PARTITION p_2024_12 VALUES LESS THAN (TO_DAYS('2025-01-01')),
    PARTITION p_2025_01 VALUES LESS THAN (TO_DAYS('2025-02-01')),
    PARTITION p_2025_02 VALUES LESS THAN (TO_DAYS('2025-03-01')),
    PARTITION p_2025_03 VALUES LESS THAN (TO_DAYS('2025-04-01')),
    PARTITION p_2025_04 VALUES LESS THAN (TO_DAYS('2025-05-01')),
    PARTITION p_2025_05 VALUES LESS THAN (TO_DAYS('2025-06-01')),
    PARTITION p_2025_06 VALUES LESS THAN (TO_DAYS('2025-07-01')),
    PARTITION p_2025_07 VALUES LESS THAN (TO_DAYS('2025-08-01')),
    PARTITION p_2025_08 VALUES LESS THAN (TO_DAYS('2025-09-01')),
    PARTITION p_2025_09 VALUES LESS THAN (TO_DAYS('2025-10-01')),
    PARTITION p_2025_10 VALUES LESS THAN (TO_DAYS('2025-11-01')),
    PARTITION p_2025_11 VALUES LESS THAN (TO_DAYS('2025-12-01')),
    PARTITION p_2025_12 VALUES LESS THAN (TO_DAYS('2026-01-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);


-- =====================================================
-- STEP 5: MIGRATE DATA FROM BACKUP
-- =====================================================

-- Insert data from backup into partitioned table
INSERT INTO bookings 
SELECT * FROM bookings_backup;

-- Verify data migration
SELECT COUNT(*) FROM bookings;
SELECT COUNT(*) FROM bookings_backup;


-- =====================================================
-- STEP 6: ADD NEW PARTITIONS (For future dates)
-- =====================================================

-- Add partition for 2027
ALTER TABLE bookings 
REORGANIZE PARTITION p_future INTO (
    PARTITION p_2027 VALUES LESS THAN (2028),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Add partition for 2028
ALTER TABLE bookings 
REORGANIZE PARTITION p_future INTO (
    PARTITION p_2028 VALUES LESS THAN (2029),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);


-- =====================================================
-- STEP 7: AUTOMATED PARTITION MANAGEMENT
-- =====================================================

-- Stored procedure to add new yearly partitions automatically
DELIMITER //

CREATE PROCEDURE add_yearly_partition()
BEGIN
    DECLARE next_year INT;
    DECLARE partition_name VARCHAR(20);
    DECLARE partition_exists INT;
    
    -- Get next year
    SET next_year = YEAR(CURDATE()) + 2;
    SET partition_name = CONCAT('p_', next_year);
    
    -- Check if partition already exists
    SELECT COUNT(*) INTO partition_exists
    FROM information_schema.partitions
    WHERE table_schema = DATABASE()
      AND table_name = 'bookings'
      AND partition_name = partition_name;
    
    -- Create partition if it doesn't exist
    IF partition_exists = 0 THEN
        SET @sql = CONCAT('ALTER TABLE bookings REORGANIZE PARTITION p_future INTO (',
                         'PARTITION ', partition_name, ' VALUES LESS THAN (', next_year + 1, '),',
                         'PARTITION p_future VALUES LESS THAN MAXVALUE)');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SELECT CONCAT('Partition ', partition_name, ' created successfully') AS result;
    ELSE
        SELECT CONCAT('Partition ', partition_name, ' already exists') AS result;
    END IF;
END //

DELIMITER ;

-- Schedule this procedure to run monthly via cron or event scheduler
-- CREATE EVENT yearly_partition_event
-- ON SCHEDULE EVERY 1 MONTH
-- DO CALL add_yearly_partition();


-- =====================================================
-- STEP 8: DROP OLD PARTITIONS (Archive strategy)
-- =====================================================

-- Drop partition for old data (e.g., 2020)
-- This is much faster than DELETE
ALTER TABLE bookings DROP PARTITION p_2020;

-- Alternative: Archive before dropping
CREATE TABLE bookings_archive_2020 AS
SELECT * FROM bookings PARTITION (p_2020);

-- Then drop the partition
ALTER TABLE bookings DROP PARTITION p_2020;


-- =====================================================
-- STEP 9: QUERY PERFORMANCE TESTING
-- =====================================================

-- Test Query 1: Get bookings for specific date range
-- WITHOUT partitioning: Scans entire table
-- WITH partitioning: Only scans relevant partitions

EXPLAIN PARTITIONS
SELECT 
    booking_id,
    user_id,
    property_id,
    start_date,
    end_date,
    total_price,
    status
FROM bookings
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30';

-- Output shows: partitions: p_2024 (only scans 2024 partition)


-- Test Query 2: Get upcoming bookings
EXPLAIN PARTITIONS
SELECT 
    booking_id,
    user_id,
    property_id,
    start_date,
    end_date,
    status
FROM bookings
WHERE start_date >= CURDATE()
  AND status = 'confirmed'
ORDER BY start_date
LIMIT 100;

-- Output shows: partitions: p_2025,p_2026,p_future


-- Test Query 3: Get bookings for specific year
EXPLAIN PARTITIONS
SELECT 
    COUNT(*) AS total_bookings,
    SUM(total_price) AS total_revenue,
    AVG(total_price) AS avg_booking_price
FROM bookings
WHERE YEAR(start_date) = 2024;

-- Output shows: partitions: p_2024 (partition pruning works!)


-- =====================================================
-- STEP 10: VERIFY PARTITION INFORMATION
-- =====================================================

-- View all partitions and their statistics
SELECT 
    partition_name,
    partition_expression,
    partition_description,
    table_rows,
    ROUND(data_length / 1024 / 1024, 2) AS data_mb,
    ROUND(index_length / 1024 / 1024, 2) AS index_mb,
    partition_comment
FROM information_schema.partitions
WHERE table_schema = DATABASE()
  AND table_name = 'bookings'
ORDER BY partition_ordinal_position;


-- Check partition distribution
SELECT 
    partition_name,
    table_rows,
    ROUND(table_rows * 100.0 / SUM(table_rows) OVER(), 2) AS percentage
FROM information_schema.partitions
WHERE table_schema = DATABASE()
  AND table_name = 'bookings'
  AND partition_name IS NOT NULL
ORDER BY partition_ordinal_position;

