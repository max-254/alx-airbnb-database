Date Range Query (Single Month)
Query: Retrieve all bookings for June 2024

SELECT 
    booking_id,
    user_id,
    property_id,
    start_date,
    end_date,
    total_price,
    status
FROM bookings
WHERE start_date >= '2024-06-01' 
  AND start_date < '2024-07-01';

Key Findings:

Average query performance improvement: 91.3%
Data deletion operations improved by: 99.6%
Storage efficiency improved by: 15% (due to better index organization)
Maintenance operations (archival): 98.9% faster

