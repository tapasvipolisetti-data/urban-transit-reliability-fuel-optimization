use citylinetransit;

CREATE INDEX idx_fact_routekey ON fact_transit_trips(RouteKey);
CREATE INDEX idx_fact_buskey ON fact_transit_trips(BusKey);
CREATE INDEX idx_fact_timekey ON fact_transit_trips(TimeKey);
CREATE INDEX idx_fact_perfkey ON fact_transit_trips(PerfKey);

CREATE INDEX idx_route_routekey ON dim_route(RouteKey);
CREATE INDEX idx_bus_buskey ON dim_bus(BusKey);
CREATE INDEX idx_time_timekey ON dim_time(TimeKey);
CREATE INDEX idx_perf_perfkey ON dim_performance(PerfKey);

EXPLAIN
SELECT 
    f.TripID,
    r.Source,
    r.Destination,
    b.BusID,
    f.Distance,
    f.FuelConsumed,
    f.ActualTime,
    f.TargetTime
FROM fact_transit_trips f
JOIN dim_route r ON f.RouteKey = r.RouteKey
JOIN dim_bus b ON f.BusKey = b.BusKey;

SHOW INDEX FROM fact_transit_trips;

SELECT 
    SUM(RouteKey IS NULL) AS RouteKey_Nulls,
    SUM(BusKey IS NULL) AS BusKey_Nulls,
    SUM(TimeKey IS NULL) AS TimeKey_Nulls,
    SUM(PerfKey IS NULL) AS PerfKey_Nulls
FROM fact_transit_trips;



CREATE OR REPLACE VIEW v_route_otp AS
SELECT
    r.RouteKey,
    r.Source,
    r.Destination,
    CONCAT(r.Source,' → ',r.Destination) AS RouteName,
    COUNT(f.TripID) AS TotalTrips,
    SUM(CASE WHEN f.OTPFlag = 'On Time' THEN 1 ELSE 0 END) AS OnTimeTrips,
    ROUND(
        SUM(CASE WHEN f.OTPFlag = 'On Time' THEN 1 ELSE 0 END) * 100.0
        / COUNT(f.TripID),
        2
    ) AS OTP_Percentage
FROM fact_transit_trips f
JOIN dim_route r
ON f.RouteKey = r.RouteKey
GROUP BY r.RouteKey, r.Source, r.Destination;


SELECT * 
FROM v_route_otp
ORDER BY OTP_Percentage ASC;


SELECT DISTINCT OTPFlag
FROM fact_transit_trips;


CREATE OR REPLACE VIEW v_route_otp AS
SELECT
    r.RouteKey,
    r.Source,
    r.Destination,
    CONCAT(r.Source,' → ',r.Destination) AS RouteName,
    COUNT(f.TripID) AS TotalTrips,
    SUM(CASE WHEN TRIM(f.OTPFlag) = 'On Time' THEN 1 ELSE 0 END) AS OnTimeTrips,
    ROUND(
        SUM(CASE WHEN TRIM(f.OTPFlag) = 'On Time' THEN 1 ELSE 0 END) * 100.0
        / COUNT(f.TripID),
        2
    ) AS OTP_Percentage
FROM fact_transit_trips f
JOIN dim_route r
ON f.RouteKey = r.RouteKey
GROUP BY r.RouteKey, r.Source, r.Destination;

SELECT *
FROM v_route_otp
ORDER BY OTP_Percentage ASC;

SELECT OTPFlag, COUNT(*)
FROM fact_transit_trips
GROUP BY OTPFlag;

CREATE OR REPLACE VIEW v_route_otp AS
SELECT
    r.RouteKey,
    r.Source,
    r.Destination,
    CONCAT(r.Source,' → ',r.Destination) AS RouteName,
    COUNT(f.TripID) AS TotalTrips,
    SUM(CASE WHEN TRIM(f.OTPFlag) = 'OnTime' THEN 1 ELSE 0 END) AS OnTimeTrips,
    ROUND(
        SUM(CASE WHEN TRIM(f.OTPFlag) = 'OnTime' THEN 1 ELSE 0 END) * 100.0
        / COUNT(f.TripID),
        2
    ) AS OTP_Percentage
FROM fact_transit_trips f
JOIN dim_route r
ON f.RouteKey = r.RouteKey
GROUP BY r.RouteKey, r.Source, r.Destination;

SELECT *
FROM v_route_otp
ORDER BY OTP_Percentage ASC;


CREATE OR REPLACE VIEW v_fuel_efficiency AS
SELECT
    b.BusKey,
    b.BusID,
    b.BusType,
    COUNT(f.TripID) AS TotalTrips,
    ROUND(SUM(f.Distance),2) AS TotalDistance,
    ROUND(SUM(f.FuelConsumed),2) AS TotalFuelConsumed,
    ROUND(
        SUM(f.Distance) /
        NULLIF(SUM(f.FuelConsumed),0),
        2
    ) AS FuelEfficiency_KMPL
FROM fact_transit_trips f
JOIN dim_bus b
ON f.BusKey = b.BusKey
GROUP BY b.BusKey, b.BusID, b.BusType;

SELECT *
FROM v_fuel_efficiency
ORDER BY FuelEfficiency_KMPL ASC;

CREATE OR REPLACE VIEW v_delay_analysis AS
SELECT
    r.RouteKey,
    r.Source,
    r.Destination,
    CONCAT(r.Source,' → ',r.Destination) AS RouteName,
    COUNT(f.TripID) AS TotalTrips,
    SUM(
        CASE
            WHEN f.ActualTime > f.TargetTime
            THEN 1
            ELSE 0
        END
    ) AS DelayedTrips,
    ROUND(AVG(f.ActualTime - f.TargetTime),2) AS AvgDelayMinutes
FROM fact_transit_trips f
JOIN dim_route r
ON f.RouteKey = r.RouteKey
GROUP BY r.RouteKey, r.Source, r.Destination;


SELECT *
FROM v_delay_analysis
ORDER BY DelayedTrips DESC;

SELECT
    COUNT(*) AS TotalTrips,
    SUM(CASE WHEN ActualTime > TargetTime THEN 1 ELSE 0 END) AS DelayedTrips
FROM fact_transit_trips;

CREATE OR REPLACE VIEW v_fuel_efficiency AS
SELECT
    b.BusKey,
    b.BusID,
    b.BusType,
    COUNT(f.TripID) AS TotalTrips,
    ROUND(SUM(f.Distance),2) AS TotalDistance,
    ROUND(SUM(f.FuelConsumed),2) AS TotalFuelConsumed,
    ROUND(
        SUM(f.Distance) / NULLIF(SUM(f.FuelConsumed),0),
        2
    ) AS FuelEfficiency_KMPL
FROM fact_transit_trips f
JOIN dim_bus b
ON f.BusKey = b.BusKey
GROUP BY b.BusKey, b.BusID, b.BusType;

SELECT *
FROM v_delay_analysis
ORDER BY DelayPercentage DESC;

CREATE OR REPLACE VIEW v_delay_analysis AS
SELECT
    r.RouteKey,
    r.Source,
    r.Destination,
    CONCAT(r.Source,' → ',r.Destination) AS RouteName,
    COUNT(f.TripID) AS TotalTrips,
    SUM(CASE WHEN TRIM(f.OTPFlag) = 'Delayed' THEN 1 ELSE 0 END) AS DelayedTrips,
    ROUND(
        SUM(CASE WHEN TRIM(f.OTPFlag) = 'Delayed' THEN 1 ELSE 0 END) * 100.0 / COUNT(f.TripID),
        2
    ) AS DelayPercentage
FROM fact_transit_trips f
JOIN dim_route r
ON f.RouteKey = r.RouteKey
GROUP BY r.RouteKey, r.Source, r.Destination;

SELECT *
FROM v_delay_analysis
ORDER BY DelayPercentage DESC;


CREATE OR REPLACE VIEW v_fuel_efficiency AS
SELECT
    b.BusKey,
    b.BusID,
    b.BusType,
    COUNT(f.TripID) AS TotalTrips,
    ROUND(SUM(f.Distance),2) AS TotalDistance,
    ROUND(SUM(f.FuelConsumed),2) AS TotalFuelConsumed,
    ROUND(
        SUM(f.Distance) / NULLIF(SUM(f.FuelConsumed),0),
        2
    ) AS FuelEfficiency_KMPL
FROM fact_transit_trips f
JOIN dim_bus b
ON f.BusKey = b.BusKey
GROUP BY b.BusKey, b.BusID, b.BusType;

SELECT *
FROM v_fuel_efficiency
ORDER BY FuelEfficiency_KMPL ASC;

SELECT *
FROM v_route_otp
ORDER BY OTP_Percentage ASC;

SELECT
COUNT(*) AS TotalTrips,
SUM(CASE WHEN OTPFlag='OnTime' THEN 1 ELSE 0 END) AS OnTimeTrips
FROM fact_transit_trips
WHERE RouteKey=28;

SELECT
COUNT(*) AS TotalTrips,
SUM(CASE WHEN OTPFlag='OnTime' THEN 1 ELSE 0 END) AS OnTimeTrips,
ROUND(
    SUM(CASE WHEN OTPFlag='OnTime' THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
    2
) AS OTP_Percentage
FROM fact_transit_trips
WHERE RouteKey = 28;

SELECT *
FROM v_route_otp
WHERE RouteKey = 28;

SELECT
    ROUND(SUM(Distance),2) AS TotalDistance,
    ROUND(SUM(FuelConsumed),2) AS TotalFuelConsumed,
    ROUND(
        SUM(Distance) / SUM(FuelConsumed),
        2
    ) AS FuelEfficiency_KMPL
FROM fact_transit_trips
WHERE BusKey = 92;


SELECT *
FROM v_fuel_efficiency
WHERE BusKey = 92;


SELECT
    COUNT(*) AS TotalTrips,
    SUM(CASE WHEN OTPFlag='Delayed' THEN 1 ELSE 0 END) AS DelayedTrips,
    ROUND(
        SUM(CASE WHEN OTPFlag='Delayed' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS DelayPercentage
FROM fact_transit_trips
WHERE RouteKey = 28;

SELECT *
FROM v_delay_analysis
WHERE RouteKey = 28;