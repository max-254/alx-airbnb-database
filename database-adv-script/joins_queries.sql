
-- ============================================
-- INNER JOIN Queries: Bookings and Users
-- ============================================

-- ============================================
-- 1. Basic INNER JOIN - All Bookings with User Details
-- ============================================

SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.number_of_guests,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
ORDER BY 
    b.created_at DESC;

-- ============================================
-- 2. Formatted Output with Concatenated Names
-- ============================================

SELECT 
    b.booking_id AS 'Booking ID',
    CONCAT(u.first_name, ' ', u.last_name) AS 'Guest Name',
    u.email AS 'Email',
    b.check_in_date AS 'Check In',
    b.check_out_date AS 'Check Out',
    b.number_of_guests AS 'Guests',
    CONCAT('$', FORMAT(b.total_price, 2)) AS 'Total Price',
    b.status AS 'Status'
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
ORDER BY 
    b.check_in_date DESC;

-- ============================================
-- 3. Include Property Information (Multiple JOINs)
-- ============================================

SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    p.title AS property_title,
    p.property_type,
    CONCAT(l.city, ', ', l.state, ', ', l.country) AS property_location,
    b.check_in_date,
    b.check_out_date,
    DATEDIFF(b.check_out_date, b.check_in_date) AS nights_stayed,
    b.number_of_guests,
    b.total_price,
    b.status
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    Location l ON p.property_id = l.property_id
ORDER BY 
    b.check_in_date DESC;

-- ============================================
-- 4. Include Host Information
-- ============================================

SELECT 
    b.booking_id,
    CONCAT(guest.first_name, ' ', guest.last_name) AS guest_name,
    guest.email AS guest_email,
    guest.phone_number AS guest_phone,
    p.title AS property_title,
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    host.email AS host_email,
    host.phone_number AS host_phone,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status
FROM 
    Booking b
INNER JOIN 
    User guest ON b.guest_id = guest.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    User host ON p.host_id = host.user_id
ORDER BY 
    b.created_at DESC;

-- ============================================
-- 5. Bookings with Payment Information
-- ============================================

SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email,
    b.check_in_date,
    b.check_out_date,
    b.total_price AS booking_amount,
    b.status AS booking_status,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.status AS payment_status,
    pay.payment_date,
    pay.transaction_id
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
INNER JOIN 
    Payment pay ON b.booking_id = pay.booking_id
ORDER BY 
    pay.payment_date DESC;

-- ============================================
-- 6. Filter by Booking Status
-- ============================================

-- Active Bookings Only (Confirmed)
SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email,
    p.title AS property_title,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
WHERE 
    b.status = 'confirmed'
ORDER BY 
    b.check_in_date ASC;

-- ============================================
-- 7. Filter by Date Range
-- ============================================

-- Bookings for a Specific Date Range
SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email,
    p.title AS property_title,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
WHERE 
    b.check_in_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY 
    b.check_in_date ASC;

-- ============================================
-- 8. Bookings with Reviews
-- ============================================

SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    p.title AS property_title,
    b.check_in_date,
    b.check_out_date,
    b.status AS booking_status,
    r.rating,
    r.comment AS review_comment,
    r.created_at AS review_date
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    Review r ON b.booking_id = r.booking_id
WHERE 
    b.status = 'completed'
ORDER BY 
    r.created_at DESC;

-- ============================================
-- 9. Aggregate Queries - User Booking Statistics
-- ============================================

-- Count bookings per user
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_spent,
    AVG(b.total_price) AS average_booking_price,
    MIN(b.check_in_date) AS first_booking_date,
    MAX(b.check_in_date) AS last_booking_date
FROM 
    User u
INNER JOIN 
    Booking b ON u.user_id = b.guest_id
GROUP BY 
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY 
    total_bookings DESC;

-- ============================================
-- 10. Current and Upcoming Bookings
-- ============================================

SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email,
    u.phone_number,
    p.title AS property_title,
    CONCAT(l.city, ', ', l.state) AS location,
    b.check_in_date,
    b.check_out_date,
    DATEDIFF(b.check_in_date, CURDATE()) AS days_until_checkin,
    b.number_of_guests,
    b.total_price,
    b.status
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
    AND b.status IN ('confirmed', 'pending')
ORDER BY 
    b.check_in_date ASC;

-- ============================================
-- 11. Bookings by Specific User
-- ============================================

-- Replace the email with the actual user email
SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    p.title AS property_title,
    p.property_type,
    CONCAT(l.city, ', ', l.state, ', ', l.country) AS location,
    b.check_in_date,
    b.check_out_date,
    DATEDIFF(b.check_out_date, b.check_in_date) AS nights,
    b.number_of_guests,
    b.total_price,
    b.status,
    b.created_at AS booking_date
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    Location l ON p.property_id = l.property_id
WHERE 
    u.email = 'jane.smith@example.com'
ORDER BY 
    b.check_in_date DESC;

-- ============================================
-- 12. Bookings with Messages
-- ============================================

SELECT 
    b.booking_id,
    CONCAT(guest.first_name, ' ', guest.last_name) AS guest_name,
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    p.title AS property_title,
    b.check_in_date,
    b.status AS booking_status,
    COUNT(m.message_id) AS total_messages,
    MAX(m.sent_at) AS last_message_date
FROM 
    Booking b
INNER JOIN 
    User guest ON b.guest_id = guest.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    User host ON p.host_id = host.user_id
INNER JOIN 
    Message m ON b.booking_id = m.booking_id
GROUP BY 
    b.booking_id, guest_name, host_name, p.title, b.check_in_date, b.status
ORDER BY 
    last_message_date DESC;

-- ============================================
-- 13. Revenue Report by Property and Guest
-- ============================================

SELECT 
    p.title AS property_title,
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    COUNT(DISTINCT b.guest_id) AS unique_guests,
    SUM(b.total_price) AS total_revenue,
    AVG(b.total_price) AS average_booking_value,
    MIN(b.check_in_date) AS first_booking,
    MAX(b.check_in_date) AS latest_booking
FROM 
    Property p
INNER JOIN 
    User host ON p.host_id = host.user_id
INNER JOIN 
    Booking b ON p.property_id = b.property_id
INNER JOIN 
    User guest ON b.guest_id = guest.user_id
WHERE 
    b.status IN ('confirmed', 'completed')
GROUP BY 
    p.property_id, p.title, host_name
ORDER BY 
    total_revenue DESC;

-- ============================================
-- 14. Complete Booking Details (All Related Tables)
-- ============================================

SELECT 
    b.booking_id,
    b.status AS booking_status,
    b.check_in_date,
    b.check_out_date,
    DATEDIFF(b.check_out_date, b.check_in_date) AS nights,
    b.number_of_guests,
    b.total_price,
    -- Guest Information
    CONCAT(guest.first_name, ' ', guest.last_name) AS guest_name,
    guest.email AS guest_email,
    guest.phone_number AS guest_phone,
    -- Property Information
    p.title AS property_title,
    p.property_type,
    p.price_per_night,
    -- Location Information
    l.address,
    CONCAT(l.city, ', ', l.state, ', ', l.country) AS location,
    -- Host Information
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    host.email AS host_email,
    host.phone_number AS host_phone,
    -- Payment Information
    pay.payment_method,
    pay.status AS payment_status,
    pay.payment_date,
    pay.transaction_id,
    -- Review Information (if exists)
    r.rating,
    r.comment AS review_comment,
    -- Timestamps
    b.created_at AS booking_created,
    b.updated_at AS booking_updated
FROM 
    Booking b
INNER JOIN 
    User guest ON b.guest_id = guest.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
INNER JOIN 
    Location l ON p.property_id = l.property_id
INNER JOIN 
    User host ON p.host_id = host.user_id
LEFT JOIN 
    Payment pay ON b.booking_id = pay.booking_id
LEFT JOIN 
    Review r ON b.booking_id = r.booking_id
ORDER BY 
    b.created_at DESC;

-- ============================================
-- 15. Bookings Summary for Dashboard
-- ============================================

SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    p.title AS property,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    b.status,
    CASE 
        WHEN b.status = 'pending' THEN 'Awaiting Confirmation'
        WHEN b.status = 'confirmed' THEN 'Confirmed'
        WHEN b.status = 'completed' THEN 'Completed'
        WHEN b.status = 'cancelled' THEN 'Cancelled'
        ELSE 'Unknown'
    END AS status_description,
    CASE 
        WHEN b.check_in_date > CURDATE() THEN 'Upcoming'
        WHEN b.check_in_date <= CURDATE() AND b.check_out_date >= CURDATE() THEN 'Active'
        WHEN b.check_out_date < CURDATE() THEN 'Past'
        ELSE 'Unknown'
    END AS booking_period
FROM 
    Booking b
INNER JOIN 
    User u ON b.guest_id = u.user_id
INNER JOIN 
    Property p ON b.property_id = p.property_id
ORDER BY 
    b.check_in_date DESC;
    
    
 
-- ============================================
-- LEFT JOIN Queries: Properties and Reviews
-- Including Properties with No Reviews
-- ============================================

-- ============================================
-- 1. Basic LEFT JOIN - All Properties with Reviews
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    p.price_per_night,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
ORDER BY 
    p.title, r.created_at DESC;

-- ============================================
-- 2. Properties with Review Count
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    p.price_per_night,
    COUNT(r.review_id) AS total_reviews,
    AVG(r.rating) AS average_rating,
    MIN(r.rating) AS lowest_rating,
    MAX(r.rating) AS highest_rating
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.title, p.property_type, p.price_per_night
ORDER BY 
    total_reviews DESC, average_rating DESC;

-- ============================================
-- 3. Identify Properties WITHOUT Reviews
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    p.price_per_night,
    p.created_at AS listed_date,
    DATEDIFF(CURDATE(), p.created_at) AS days_since_listed
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
WHERE 
    r.review_id IS NULL
ORDER BY 
    p.created_at DESC;

-- ============================================
-- 4. Properties with Review Details and Reviewer Info
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    p.price_per_night,
    CONCAT(l.city, ', ', l.state) AS location,
    r.review_id,
    r.rating,
    r.comment,
    CONCAT(u.first_name, ' ', u.last_name) AS reviewer_name,
    r.created_at AS review_date,
    CASE 
        WHEN r.review_id IS NULL THEN 'No Reviews Yet'
        ELSE 'Has Reviews'
    END AS review_status
FROM 
    Property p
LEFT JOIN 
    Location l ON p.property_id = l.property_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
LEFT JOIN 
    User u ON r.user_id = u.user_id
ORDER BY 
    p.title, r.created_at DESC;

-- ============================================
-- 5. Properties with Host Information and Reviews
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    host.email AS host_email,
    CONCAT(l.city, ', ', l.state, ', ', l.country) AS location,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating,
    CASE 
        WHEN COUNT(r.review_id) = 0 THEN 'No Reviews'
        WHEN AVG(r.rating) >= 4.5 THEN 'Excellent'
        WHEN AVG(r.rating) >= 4.0 THEN 'Very Good'
        WHEN AVG(r.rating) >= 3.5 THEN 'Good'
        WHEN AVG(r.rating) >= 3.0 THEN 'Average'
        ELSE 'Below Average'
    END AS rating_category
FROM 
    Property p
INNER JOIN 
    User host ON p.host_id = host.user_id
LEFT JOIN 
    Location l ON p.property_id = l.property_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.title, p.property_type, host_name, host_email, location
ORDER BY 
    average_rating DESC NULLS LAST, total_reviews DESC;

-- ============================================
-- 6. Detailed Property Report with All Reviews
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    p.description,
    p.property_type,
    p.price_per_night,
    p.max_guests,
    p.bedrooms,
    p.bathrooms,
    CONCAT(l.address, ', ', l.city, ', ', l.state) AS full_address,
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    -- Review Details
    CASE 
        WHEN r.review_id IS NULL THEN 'No review available'
        ELSE CONCAT(r.rating, '/5 stars')
    END AS rating_display,
    COALESCE(r.comment, 'No comments yet') AS review_comment,
    CONCAT(reviewer.first_name, ' ', reviewer.last_name) AS reviewer_name,
    r.created_at AS review_date
FROM 
    Property p
INNER JOIN 
    Location l ON p.property_id = l.property_id
INNER JOIN 
    User host ON p.host_id = host.user_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
LEFT JOIN 
    User reviewer ON r.user_id = reviewer.user_id
ORDER BY 
    p.title, r.created_at DESC;

-- ============================================
-- 7. Properties with Rating Distribution
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating,
    SUM(CASE WHEN r.rating = 5 THEN 1 ELSE 0 END) AS five_star_count,
    SUM(CASE WHEN r.rating = 4 THEN 1 ELSE 0 END) AS four_star_count,
    SUM(CASE WHEN r.rating = 3 THEN 1 ELSE 0 END) AS three_star_count,
    SUM(CASE WHEN r.rating = 2 THEN 1 ELSE 0 END) AS two_star_count,
    SUM(CASE WHEN r.rating = 1 THEN 1 ELSE 0 END) AS one_star_count
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.title
ORDER BY 
    average_rating DESC NULLS LAST;

-- ============================================
-- 8. Properties: Reviewed vs Not Reviewed
-- ============================================

SELECT 
    CASE 
        WHEN r.review_id IS NULL THEN 'Not Reviewed'
        ELSE 'Has Reviews'
    END AS review_status,
    COUNT(DISTINCT p.property_id) AS property_count,
    ROUND(AVG(p.price_per_night), 2) AS avg_price_per_night
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    review_status;

-- ============================================
-- 9. Properties with Most Recent Review
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    p.price_per_night,
    CONCAT(l.city, ', ', l.state) AS location,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating,
    MAX(r.created_at) AS most_recent_review_date,
    DATEDIFF(CURDATE(), MAX(r.created_at)) AS days_since_last_review
FROM 
    Property p
LEFT JOIN 
    Location l ON p.property_id = l.property_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.title, p.property_type, p.price_per_night, location
ORDER BY 
    most_recent_review_date DESC NULLS LAST;

-- ============================================
-- 10. Properties with Booking and Review Correlation
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    CONCAT(l.city, ', ', l.state) AS location,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    COUNT(DISTINCT r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating,
    CASE 
        WHEN COUNT(DISTINCT b.booking_id) = 0 THEN 'No Bookings'
        WHEN COUNT(DISTINCT r.review_id) = 0 THEN 'Bookings but No Reviews'
        ELSE CONCAT(ROUND((COUNT(DISTINCT r.review_id) * 100.0 / COUNT(DISTINCT b.booking_id)), 1), '%')
    END AS review_rate
FROM 
    Property p
LEFT JOIN 
    Location l ON p.property_id = l.property_id
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.title, location
ORDER BY 
    total_bookings DESC;

-- ============================================
-- 11. Active Properties with Reviews (Only Active)
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    p.price_per_night,
    p.is_active,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating,
    CASE 
        WHEN COUNT(r.review_id) = 0 THEN 'New Listing - No Reviews'
        WHEN AVG(r.rating) >= 4.5 THEN 'Superhost Quality'
        WHEN AVG(r.rating) >= 4.0 THEN 'Great Reviews'
        ELSE 'Good Reviews'
    END AS performance_status
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
WHERE 
    p.is_active = TRUE
GROUP BY 
    p.property_id, p.title, p.property_type, p.price_per_night, p.is_active
ORDER BY 
    average_rating DESC NULLS LAST;

-- ============================================
-- 12. Properties with Complete Review Text
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    COALESCE(
        GROUP_CONCAT(
            CONCAT(
                r.rating, ' stars - "', 
                LEFT(r.comment, 100), 
                CASE WHEN LENGTH(r.comment) > 100 THEN '..."' ELSE '"' END,
                ' - ', 
                DATE_FORMAT(r.created_at, '%M %d, %Y')
            ) 
            ORDER BY r.created_at DESC 
            SEPARATOR ' | '
        ),
        'No reviews yet'
    ) AS all_reviews
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.title
ORDER BY 
    p.title;

-- ============================================
-- 13. Properties Needing Attention (No Reviews)
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    host.email AS host_email,
    CONCAT(l.city, ', ', l.state) AS location,
    p.price_per_night,
    p.created_at AS listed_date,
    DATEDIFF(CURDATE(), p.created_at) AS days_active,
    COUNT(b.booking_id) AS completed_bookings,
    COUNT(r.review_id) AS total_reviews,
    CASE 
        WHEN COUNT(b.booking_id) = 0 THEN 'No bookings yet'
        WHEN COUNT(r.review_id) = 0 THEN 'Completed bookings but no reviews'
        ELSE 'Has reviews'
    END AS action_needed
FROM 
    Property p
INNER JOIN 
    User host ON p.host_id = host.user_id
LEFT JOIN 
    Location l ON p.property_id = l.property_id
LEFT JOIN 
    Booking b ON p.property_id = b.property_id AND b.status = 'completed'
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.title, host_name, host_email, location, 
    p.price_per_night, p.created_at
HAVING 
    COUNT(r.review_id) = 0
ORDER BY 
    completed_bookings DESC, days_active DESC;

-- ============================================
-- 14. Property Performance Dashboard
-- ============================================

SELECT 
    p.property_id,
    p.title AS property_title,
    p.property_type,
    CONCAT(l.city, ', ', l.state) AS location,
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    -- Booking Metrics
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    SUM(CASE WHEN b.status = 'completed' THEN 1 ELSE 0 END) AS completed_bookings,
    SUM(CASE WHEN b.status = 'confirmed' THEN 1 ELSE 0 END) AS upcoming_bookings,
    -- Review Metrics
    COUNT(DISTINCT r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating,
    -- Financial Metrics
    SUM(CASE WHEN b.status IN ('completed', 'confirmed') THEN b.total_price ELSE 0 END) AS total_revenue,
    -- Status
    CASE 
        WHEN COUNT(r.review_id) = 0 AND COUNT(b.booking_id) = 0 THEN 'New - No Activity'
        WHEN COUNT(r.review_id) = 0 AND COUNT(b.booking_id) > 0 THEN 'Active - Awaiting Reviews'
        WHEN AVG(r.rating) >= 4.5 THEN 'Excellent Performance'
        WHEN AVG(r.rating) >= 4.0 THEN 'Good Performance'
        ELSE 'Needs Improvement'
    END AS performance_status
FROM 
    Property p
INNER JOIN 
    User host ON p.host_id = host.user_id
LEFT JOIN 
    Location l ON p.property_id = l.property_id
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
WHERE 
    p.is_active = TRUE
GROUP BY 
    p.property_id, p.title, p.property_type, location, host_name
ORDER BY 
    average_rating DESC NULLS LAST, total_bookings DESC;

-- ============================================
-- 15. Simple Query: Properties and Review Count
-- ============================================

SELECT 
    p.title AS property_title,
    COALESCE(COUNT(r.review_id), 0) AS review_count,
    COALESCE(ROUND(AVG(r.rating), 1), 0) AS avg_rating
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.title
ORDER BY 
    review_count DESC;

-- ============================================
-- KEY DIFFERENCES: LEFT JOIN vs INNER JOIN
-- ============================================

-- LEFT JOIN: Returns ALL properties (even those without reviews)
-- Result includes properties with NULL review values

-- INNER JOIN: Returns ONLY properties that HAVE reviews
-- Properties without reviews are excluded from results

-- Example Comparison:

-- LEFT JOIN (includes all 8 properties)
SELECT COUNT(DISTINCT p.property_id) AS total_properties
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id;

-- INNER JOIN (only properties with reviews)
SELECT COUNT(DISTINCT p.property_id) AS properties_with_reviews
FROM Property p
INNER JOIN Review r ON p.property_id = r.property_id;

-- ============================================

-- Retrieve all users and all bookings using FULL OUTER JOIN
SELECT 
    u.user_id,
    u.username,
    u.email,
    b.booking_id,
    b.booking_date,
    b.status
FROM 
    users u
FULL OUTER JOIN 
    bookings b ON u.user_id = b.user_id
ORDER BY 
    u.user_id, b.booking_id;

