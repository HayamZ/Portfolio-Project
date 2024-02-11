select * 
from HotelRes


--Bookings per segment

Select  market_segment_type, count(booking_id) as Number_of_bookings
from HotelRes
Group By market_segment_type
Order by 2 desc

--Total Cancellation

SELECT 
	Booking_status, 
	COUNT(Booking_status) AS total_status
FROM HotelRes
GROUP BY Booking_status



-- Cancellation Rate

SELECT
Booking_status,
	Round(COUNT(Booking_id) * 100 /
		(SELECT COUNT(Booking_status)
		FROM Hotelres),2) AS percent_of_status

From hotelres
Group by Booking_status



--Bookings in each month

SELECT 
	arrival_month, COUNT(booking_id) as Number_of_Bookings

	FROM HotelRes
Group By arrival_month
Order By arrival_month

--Calculating adr per year

SELECT ROUND(SUM(avg_price_per_room)/COUNT(Booking_ID),2) AS ADR
FROM HotelRes
WHERE arrival_year=2017

SELECT ROUND(SUM(avg_price_per_room)/COUNT(Booking_ID),2) AS ADR
FROM HotelRes
WHERE arrival_year=2018

ALTER TABLE HotelRes
ADD ADR INT

UPDATE HotelRes
SET ADR= CASE 
WHEN arrival_year=2018 THEN (SELECT ROUND(SUM(avg_price_per_room)/COUNT(Booking_ID),2)
FROM HotelRes
WHERE arrival_year=2018)
 WHEN arrival_year=2017 THEN (SELECT ROUND(SUM(avg_price_per_room)/COUNT(Booking_ID),2)
FROM HotelRes
WHERE arrival_year=2017)
ELSE NULL
END



--Revenue

SELECT arrival_year, SUM((no_of_week_nights + no_of_weekend_nights)*adr) AS Revenue
FROM HotelRes
GROUP BY arrival_year 

--Market segment and Cancellation percentage

WITH CT AS
(SELECT market_segment_type,COUNT(booking_status)AS Cancelled_bookings,booking_status
FROM HotelRes
WHERE booking_status='canceled'
GROUP BY market_segment_type,booking_status)
SELECT market_segment_type, CAST(ROUND(Cancelled_bookings*100*1.0/(SELECT COUNT(booking_status) FROM HotelRes WHERE booking_status='canceled'),2) AS DECIMAL(10,1)) AS Percentage_Can
FROM CT
GROUP BY market_segment_type,Cancelled_bookings
