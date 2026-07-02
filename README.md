# urban-transit-reliability-fuel-optimization
- 
# Urban Transit Reliability & Fuel Efficiency Optimization
### CityLine Logistics — End-to-End Data Analytics Project

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)
![Python](https://img.shields.io/badge/Python-Analytics-blue)
![SQL](https://img.shields.io/badge/MySQL-Database-orange)
![ML](https://img.shields.io/badge/Scikit--Learn-Linear%20Regression-green)

---

## Project Overview

A 21-day end-to-end data analytics project analyzing 20,000 urban 
transit trips for CityLine Logistics, Hyderabad. The project covers 
the full analytics pipeline from raw data ingestion to AI-powered 
fuel projections and an interactive Power BI dashboard.

---

## Problem Statement

CityLine Logistics operates a large urban bus fleet across 150 routes 
in Hyderabad. The operations team faced critical challenges:

- Fleet On-Time Performance (OTP) significantly below target
- Operating costs per kilometer exceeding benchmarks
- Fuel inefficiency across multiple bus types
- No centralized analytics platform for decision making

---

## Key Findings

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Fleet OTP % | 16.02% | 40% | Critical |
| Fuel Efficiency | 4.06 km/L | 4.0 km/L | Met |
| Cost per km | ₹37.78 | ₹25 | Critical |
| Avg Idle Time | 22.95 min | 20 min | Above target |
| Slow Zones | 2,279 | 2,000 | Above target |
| Total Fuel Saved (3yr) | 24,467 L | — | Projected |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Database | MySQL Workbench |
| Data Processing | Python, Pandas, NumPy |
| Visualization | Matplotlib, Seaborn |
| Machine Learning | Scikit-Learn Linear Regression |
| Dashboard | Microsoft Power BI |
| Version Control | GitHub |

--

## Project Structure

```
urban-transit-reliability-fuel-optimization/
│
├── README.md                          ← Project documentation
│
├── cityline eda.ipynb                 ← Exploratory data analysis
├── cityline_day10_cleaned_merged.ipynb ← Data cleaning & merging
├── day 11.ipynb                       ← EDA heatmap & scatter analysis
├── day 12.ipynb                       ← IQR anomaly detection
├── day 13.ipynb                       ← Time series delay analysis
├── day 14.ipynb                       ← Feature engineering
├── dim bus eda.ipynb                  ← Bus dimension analysis
├── dim performance.ipynb              ← Performance dimension analysis
├── dim route.ipynb                    ← Route dimension analysis
├── fact eda.ipynb                     ← Fact table analysis
├── ml model.ipynb                     ← Linear regression AI model
│
├── v_bus_cost_analysis.csv            ← SQL view: cost analysis
├── v_delay_analysis.csv               ← SQL view: delay analysis
├── v_fuel_efficiency.csv              ← SQL view: fuel efficiency
├── v_route_fuel_analysis.csv          ← SQL view: route fuel
├── v_route_otp.csv                    ← SQL view: OTP by route
├── v_trip_duration.csv                ← SQL view: trip duration
│
└── CityLine_Dashboard.pbix            ← Power BI dashboard
```

## Dashboard

🔗 [View Dashboard File](https://github.com/tapasvipolisetti-data/urban-transit-reliability-fuel-optimization/blob/main/CityLine_Dashboard.pbix)

---

## Demo Video

🎥 [Watch Dashboard Walkthrough](#) — coming soon

---

## Author

**Tapasvi Polisetti**  
Data Analytics Intern  
tapasvi.polisetti@gmail.com  
🔗 [github.com/tapasvipolisetti-data](https://github.com/tapasvipolisetti-data)

---

## License

MIT License
