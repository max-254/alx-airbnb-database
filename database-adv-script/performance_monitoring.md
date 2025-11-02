-- Created composite index
CREATE INDEX idx_bookings_user_date 
ON bookings(user_id, start_date DESC);

-- Created covering index
CREATE INDEX idx_bookings_user_covering 
ON bookings(user_id, start_date DESC, booking_id, 
           end_date, total_price, status, property_id);
Results After Optimization:

Execution Time: 8ms
Rows Scanned: 23
Improvement: 99.4% faster
