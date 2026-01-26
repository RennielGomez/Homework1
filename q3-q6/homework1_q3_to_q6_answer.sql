-- Question 3. Counting short trips
-- For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound),
-- how many trips had a trip_distance of less than or equal to 1 mile?

select count(*) from green_taxi_data gtaxi
where gtaxi.lpep_pickup_datetime >= to_timestamp('01-11-2025', 'DD-MM-YYYY')
and gtaxi.lpep_pickup_datetime < to_timestamp('01-12-2025', 'DD-MM-YYYY')
and gtaxi.trip_distance <= 1
limit 1;


-- Question 4. Longest trip for each day
-- Which was the pick up day with the longest trip distance? 
-- Only consider trips with trip_distance less than 100 miles (to exclude data errors).

-- Use the pick up time for your calculations.

select gtaxi.lpep_pickup_datetime::date, sum(gtaxi.trip_distance) as distance
from green_taxi_data gtaxi
where gtaxi.trip_distance < 100
group by gtaxi.lpep_pickup_datetime::date
order by 2 desc
limit 1;


-- Question 5. Biggest pickup zone
-- Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?

select pu_zone."Zone", gtaxi.lpep_pickup_datetime::date,sum(gtaxi.total_amount)
from green_taxi_data gtaxi
join taxi_zone pu_zone on pu_zone."LocationID" = gtaxi."PULocationID"
where date_trunc('day',gtaxi.lpep_pickup_datetime) = to_timestamp('18-11-2025 00:00:00', 'DD-MM-YYYY HH24:MI:SS') 
group by pu_zone."Zone", gtaxi.lpep_pickup_datetime::date 
order by 3 desc
limit 1;


-- Question 6. Largest tip
-- For the passengers picked up in the zone named "East Harlem North" in November 2025, 
-- which was the drop off zone that had the largest tip?

select do_zone."Zone",sum(gtaxi.tip_amount)
from green_taxi_data gtaxi
join taxi_zone pu_zone on pu_zone."LocationID" = gtaxi."PULocationID"
join taxi_zone do_zone on do_zone."LocationID" = gtaxi."DOLocationID"
where date_trunc('day',gtaxi.lpep_pickup_datetime) >= to_timestamp('01-11-2025 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
and date_trunc('day',gtaxi.lpep_pickup_datetime) <= to_timestamp('30-11-2025 23:59:59', 'DD-MM-YYYY HH24:MI:SS')
and pu_zone."Zone" = 'East Harlem North'
group by do_zone."Zone"
order by 2 desc
limit 1;





