USE CityLineTransit;

SELECT
    f.RouteKey,
    r.Source,
    r.Destination,
    CONCAT(r.Source, ' → ', r.Destination) AS RoutePath,
    COUNT(*) AS TotalTrips,

    SUM(CASE
        WHEN LOWER(f.OTPFlag) LIKE '%on%time%' THEN 1
        ELSE 0
    END) AS OnTimeTrips,

    SUM(CASE
        WHEN LOWER(f.OTPFlag) LIKE '%delayed%' THEN 1
        ELSE 0
    END) AS DelayedTrips,

    ROUND(
        SUM(CASE
            WHEN LOWER(f.OTPFlag) LIKE '%on%time%' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS OTP_Percentage

FROM fact_transit_trips f
JOIN dim_route r
    ON f.RouteKey = r.RouteKey
GROUP BY
    f.RouteKey,
    r.Source,
    r.Destination
ORDER BY OTP_Percentage ASC
limit 5;

USE CityLineTransit;

SELECT
    f.RouteKey,
    r.Source,
    r.Destination,
    CONCAT(r.Source, ' → ', r.Destination) AS RoutePath,
    COUNT(*) AS SlowZoneTrips
FROM fact_transit_trips f
JOIN dim_route r
    ON f.RouteKey = r.RouteKey
WHERE f.ActualTime > (1.15 * f.TargetTime)
GROUP BY
    f.RouteKey,
    r.Source,
    r.Destination
ORDER BY SlowZoneTrips DESC;

USE CityLineTransit;

SELECT
    f.RouteKey,
    r.Source,
    r.Destination,
    CONCAT(r.Source, ' → ', r.Destination) AS RoutePath,
    COUNT(*) AS TotalDelayedTrips
FROM fact_transit_trips f
JOIN dim_route r
    ON f.RouteKey = r.RouteKey
WHERE f.DelayAnalysis > 0
GROUP BY
    f.RouteKey,
    r.Source,
    r.Destination
ORDER BY TotalDelayedTrips DESC;

