USE CityLineTransit;

SELECT
    b.BusID,
    b.BusType,
    COUNT(f.TripID) AS Total_Trips,
    ROUND(SUM(f.Distance),2) AS Total_Distance_KM,
    ROUND(SUM(f.FuelConsumed),2) AS Total_Fuel_Consumed_L,
    ROUND(SUM(f.Distance)/SUM(f.FuelConsumed),2) AS Fuel_Efficiency_KMPL
FROM fact_transit_trips f
JOIN dim_bus b
    ON f.BusKey = b.BusKey
GROUP BY b.BusID, b.BusType
ORDER BY Fuel_Efficiency_KMPL DESC;

SELECT
    b.BusID,
    b.BusType,
    COUNT(f.TripID) AS Total_Trips,
    ROUND(SUM(f.Distance), 2) AS Total_Distance_KM,
    ROUND(SUM(f.FuelConsumed), 2) AS Total_Fuel_Consumed_L,
    ROUND(SUM(f.Distance) / SUM(f.FuelConsumed), 2) AS Fuel_Efficiency_KMPL,
    ROUND(AVG(f.IdleDuration), 2) AS Avg_IdleDuration,
    ROUND(AVG(f.OperatingCostPerKM), 2) AS Avg_Operating_Cost_Per_KM
FROM fact_transit_trips f
JOIN dim_bus b
    ON f.BusKey = b.BusKey
GROUP BY b.BusID, b.BusType
ORDER BY Fuel_Efficiency_KMPL ASC
LIMIT 10;


SELECT
    b.BusID,
    b.BusType,
    COUNT(f.TripID) AS Total_Trips,
    ROUND(SUM(f.Distance), 2) AS Total_Distance_KM,
    ROUND(SUM(f.FuelConsumed), 2) AS Total_Fuel_Consumed_L,
    ROUND(SUM(f.Distance) / SUM(f.FuelConsumed), 2) AS Fuel_Efficiency_KMPL,
    ROUND(AVG(f.IdleDuration), 2) AS Avg_Idle_Duration_Min,
    ROUND(AVG(f.RPM), 2) AS Avg_RPM,
    ROUND(AVG(f.EngineTemperature), 2) AS Avg_Engine_Temp
FROM fact_transit_trips f
JOIN dim_bus b
    ON f.BusKey = b.BusKey
GROUP BY b.BusID, b.BusType
ORDER BY Avg_Idle_Duration_Min DESC;