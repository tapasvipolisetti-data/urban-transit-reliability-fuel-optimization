CREATE VIEW v_route_fuel_analysis AS
SELECT
    r.RouteKey,
    CONCAT(r.Source,' → ',r.Destination) AS Route_Name,
    COUNT(f.TripID) AS Total_Trips,
    ROUND(SUM(f.Distance),2) AS Total_Distance_KM,
    ROUND(SUM(f.FuelConsumed),2) AS Total_Fuel_Consumed_L,
    ROUND(SUM(f.Distance)/SUM(f.FuelConsumed),2) AS Route_Fuel_Efficiency
FROM fact_transit_trips f
JOIN dim_route r
ON f.RouteKey = r.RouteKey
GROUP BY r.RouteKey, r.Source, r.Destination;

CREATE VIEW v_bus_cost_analysis AS
SELECT
    b.BusID,
    b.BusType,
    COUNT(f.TripID) AS Total_Trips,
    ROUND(SUM(f.Distance),2) AS Total_Distance_KM,
    ROUND(AVG(f.OperatingCostPerKM),2) AS Avg_Operating_Cost_Per_KM
FROM fact_transit_trips f
JOIN dim_bus b
ON f.BusKey = b.BusKey
GROUP BY b.BusID, b.BusType;


SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT * FROM v_bus_cost_analysis LIMIT 10;

SELECT * FROM v_route_fuel_analysis;

SELECT *
FROM v_route_fuel_analysis
WHERE RouteKey = 1;

SELECT
    COUNT(*) AS Total_Trips,
    ROUND(SUM(Distance),2) AS Total_Distance_KM,
    ROUND(SUM(FuelConsumed),2) AS Total_Fuel_Consumed_L
FROM fact_transit_trips
WHERE RouteKey = 1;

SELECT *
FROM v_bus_cost_analysis
WHERE Avg_Operating_Cost_Per_KM IS NULL;


SELECT *
FROM v_route_fuel_analysis
WHERE Route_Fuel_Efficiency IS NULL;

SELECT
    COUNT(*) AS Total_Trips,
    ROUND(SUM(Distance),2) AS Total_Distance_KM,
    ROUND(SUM(FuelConsumed),2) AS Total_Fuel_Consumed_L,
    ROUND(SUM(Distance) / SUM(FuelConsumed),2) AS Route_Fuel_Efficiency
FROM fact_transit_trips
WHERE RouteKey = 1;

SELECT *
FROM v_route_fuel_analysis
WHERE RouteKey = 1;


SELECT
    r.RouteKey,
    CONCAT(r.Source, ' → ', r.Destination) AS Route_Name,
    COUNT(f.TripID) AS Total_Trips,
    ROUND(SUM(f.Distance),2) AS Total_Distance_KM,
    ROUND(SUM(f.FuelConsumed),2) AS Total_Fuel_Consumed_L,
    ROUND(SUM(f.Distance) / SUM(f.FuelConsumed),2) AS Route_Fuel_Efficiency
FROM fact_transit_trips f
JOIN dim_route r
    ON f.RouteKey = r.RouteKey
WHERE r.RouteKey = 1
GROUP BY r.RouteKey, r.Source, r.Destination;




SELECT
    b.BusID,
    b.BusType,
    COUNT(f.TripID) AS Total_Trips,
    ROUND(SUM(f.Distance),2) AS Total_Distance_KM,
    ROUND(AVG(f.OperatingCostPerKM),2) AS Avg_Operating_Cost_Per_KM
FROM fact_transit_trips f
JOIN dim_bus b
ON f.BusKey = b.BusKey
GROUP BY b.BusID, b.BusType
ORDER BY Avg_Operating_Cost_Per_KM DESC;


SELECT
    ROUND(AVG(f.OperatingCostPerKM),2) AS Avg_Operating_Cost_Per_KM
FROM fact_transit_trips f
JOIN dim_bus b
ON f.BusKey = b.BusKey
WHERE b.BusID = 'B0151';


SELECT
    r.RouteKey,
    CONCAT(r.Source, ' → ', r.Destination) AS Route_Name,
    COUNT(f.TripID) AS Total_Trips,
    ROUND(SUM(f.FuelConsumed),2) AS Total_Fuel_Consumed_L
FROM fact_transit_trips f
JOIN dim_route r
ON f.RouteKey = r.RouteKey
GROUP BY r.RouteKey, r.Source, r.Destination
ORDER BY Total_Fuel_Consumed_L DESC;


SELECT
    ROUND(SUM(f.FuelConsumed),2) AS Total_Fuel_Consumed
FROM fact_transit_trips f
JOIN dim_route r
ON f.RouteKey = r.RouteKey
WHERE r.Source = 'Mahbubnagar'
  AND r.Destination = 'Jadcherla';