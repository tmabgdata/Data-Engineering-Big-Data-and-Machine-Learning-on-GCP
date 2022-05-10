-- Task 4. Analyze the taxi data using BigQuery

SELECT * FROM taxirides.realtime LIMIT 10

-- Task 5. Perform aggregations on the stream for reporting

WITH streaming_data AS (
SELECT
  timestamp,
  TIMESTAMP_TRUNC(timestamp, HOUR, 'UTC') AS hour,
  TIMESTAMP_TRUNC(timestamp, MINUTE, 'UTC') AS minute,
  TIMESTAMP_TRUNC(timestamp, SECOND, 'UTC') AS second,
  ride_id,
  latitude,
  longitude,
  meter_reading,
  ride_status,
  passenger_count
FROM
  taxirides.realtime
WHERE ride_status = 'dropoff'
ORDER BY timestamp DESC
LIMIT 1000
)
# calculate aggregations on stream for reporting:
SELECT
 ROW_NUMBER() OVER() AS dashboard_sort,
 minute,
 COUNT(DISTINCT ride_id) AS total_rides,
 SUM(meter_reading) AS total_revenue,
 SUM(passenger_count) AS total_passengers
FROM streaming_data
GROUP BY minute, timestamp

-- The result shows key metrics by the minute for every taxi drop-off.

-- Task 8. Create a time series dashboard with Google Data Studio and BigQuery from Google Connectors

SELECT
  *
FROM
  taxirides.realtime
WHERE
  ride_status='dropoff'

-- END