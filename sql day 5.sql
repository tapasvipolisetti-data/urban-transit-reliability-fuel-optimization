CREATE DATABASE CityLineTransit;
use CityLineTransit;


USE citylinetransit;
SHOW TABLES;

SELECT 'fact_transit_trips' AS TableName, COUNT(*) AS RowCount 
FROM fact_transit_trips
UNION ALL
SELECT 'dim_route', COUNT(*) 
FROM dim_route
UNION ALL
SELECT 'dim_bus', COUNT(*) 
FROM dim_bus
UNION ALL
SELECT 'dim_performance', COUNT(*) 
FROM dim_performance
UNION ALL
SELECT 'dim_time', COUNT(*) 
FROM dim_time;


SELECT COUNT(*) FROM fact_transit_trips;
SELECT COUNT(*) FROM dim_route;
SELECT COUNT(*) FROM dim_bus;
SELECT COUNT(*) FROM dim_performance;
SELECT COUNT(*) FROM dim_time;

CREATE OR REPLACE VIEW v_trip_duration AS
SELECT
    TripID,
    RouteKey,
    BusKey,
    TimeKey,
    PerfKey,
    StartTime,
    EndTime,
    TargetTime,
    ActualTime,
    DelayAnalysis,
    ActualTime - TargetTime AS TimeVariance
FROM fact_transit_trips;

SELECT * FROM v_trip_duration LIMIT 10;

SELECT RouteKey, COUNT(*) AS CountRows
FROM dim_route
GROUP BY RouteKey
HAVING COUNT(*) > 1;

SELECT BusKey, COUNT(*) AS CountRows
FROM dim_bus
GROUP BY BusKey
HAVING COUNT(*) > 1;

SELECT PerfKey, COUNT(*) AS CountRows
FROM dim_performance
GROUP BY PerfKey
HAVING COUNT(*) > 1;

SELECT TimeKey, COUNT(*) AS CountRows
FROM dim_time
GROUP BY TimeKey
HAVING COUNT(*) > 1;

ALTER TABLE dim_route
ADD CONSTRAINT PK_dim_route PRIMARY KEY (RouteKey);

ALTER TABLE dim_bus
ADD CONSTRAINT PK_dim_bus PRIMARY KEY (BusKey);

ALTER TABLE dim_performance
ADD CONSTRAINT PK_dim_performance PRIMARY KEY (PerfKey);

ALTER TABLE dim_time
ADD CONSTRAINT PK_dim_time PRIMARY KEY (TimeKey);

ALTER TABLE fact_transit_trips
ADD CONSTRAINT FK_fact_route
FOREIGN KEY (RouteKey)
REFERENCES dim_route(RouteKey);

ALTER TABLE fact_transit_trips
ADD CONSTRAINT FK_fact_bus
FOREIGN KEY (BusKey)
REFERENCES dim_bus(BusKey);

ALTER TABLE fact_transit_trips
ADD CONSTRAINT FK_fact_performance
FOREIGN KEY (PerfKey)
REFERENCES dim_performance(PerfKey);

ALTER TABLE fact_transit_trips
ADD CONSTRAINT FK_fact_time
FOREIGN KEY (TimeKey)
REFERENCES dim_time(TimeKey);

SELECT COUNT(*) AS MissingRoutes
FROM fact_transit_trips f
LEFT JOIN dim_route r
ON f.RouteKey = r.RouteKey
WHERE r.RouteKey IS NULL;

SELECT COUNT(*) AS MissingBuses
FROM fact_transit_trips f
LEFT JOIN dim_bus b
ON f.BusKey = b.BusKey
WHERE b.BusKey IS NULL;

SELECT COUNT(*) AS MissingPerformance
FROM fact_transit_trips f
LEFT JOIN dim_performance p
ON f.PerfKey = p.PerfKey
WHERE p.PerfKey IS NULL;

SELECT COUNT(*) AS MissingTime
FROM fact_transit_trips f
LEFT JOIN dim_time t
ON f.TimeKey = t.TimeKey
WHERE t.TimeKey IS NULL;

CREATE VIEW v_route_otp AS
SELECT
    r.RouteID,
    r.RouteName,
    COUNT(f.TripID) AS TotalTrips,
    SUM(CASE WHEN f.OTPFlag = 'On Time' THEN 1 ELSE 0 END) AS OnTimeTrips,
    ROUND(
        SUM(CASE WHEN f.OTPFlag = 'On Time' THEN 1 ELSE 0 END) * 100.0 / COUNT(f.TripID),
        2
    ) AS OTP_Percentage
FROM fact_transit_trips f
JOIN dim_route r
    ON f.RouteKey = r.RouteKey
GROUP BY r.RouteID, r.RouteName;

SELECT *
FROM v_route_otp
ORDER BY OTP_Percentage DESC
LIMIT 10;