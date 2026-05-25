# TUIK CPI Forecasting Project

**Student:** Faysal Yaman  
**Student Number:** 138721021  
**Course:** Forecasting Methods  
**Date:** May 2026

---

## 1. Project Overview

This project forecasts the **Consumer Price Index (CPI) General Index (2003=100)** for Turkey using 10 classical time series forecasting methods. Data is accessed programmatically via the `tuikr` R package. The target forecast period is **January 2026**.

---

## 2. Data Source and TÜİK Connection

Data accessed directly from the TÜİK Data Portal using the `tuikr` R package.

| Field | Detail |
|---|---|
| **TÜİK Data Set Name** | Index numbers and rate of changes in the consumer price index |
| **TÜİK Theme / Category** | Price Statistics (Theme ID: 6) |
| **TÜİK Table Name** | Index numbers and rate of changes in the consumer price index |
| **tuikr Dataflow ID** | Not applicable (istab type table; SDMX API returns HTTP 401 — instructor approved alternative access method) |
| **Selected Variable** | CPI General Index (Base year: 2003=100) |
| **Data Frequency** | Monthly |
| **Time Coverage** | January 2005 – December 2025 |
| **Latest Available Observation** | December 2025 (Index: 3513.87) |
| **Forecast Target Period** | January 2026 |
| **Date of Data Access** | 2026-05-25 |
| **R Package Used** | `tuikr` v0.2.0 |
| **Package Source** | https://github.com/emraher/tuikr |

> **Note on Data Access:** The TÜİK SDMX API (`nsiws.tuik.gov.tr`) requires authentication and returns HTTP 401. Data was accessed via `tuikr::statistical_tables("6")` (istab type) combined with `httr::GET()` entirely within R. No manual downloads were made. This approach was approved by the course instructor.

---

## 3. Research Objective

This project forecasts the Turkish Consumer Price Index (CPI) General Index (2003=100), which measures the average change in prices paid by consumers for goods and services. Forecasting CPI is meaningful for understanding inflation trends and monetary policy implications in Turkey.

---

## 4. Use of TÜİK Data in R

TÜİK data imported through `tuikr` was used directly in R:

- **Selected variable:** CPI General Index (2003=100)
- **Time variable:** Monthly dates from January 2005
- **Data frequency:** Monthly (12 observations per year)
- **Latest observation:** December 2025
- **Forecast target:** January 2026
- **R-based adjustments:** Rows 5–25 of the Excel file extracted (index level table), wide format converted to long format, numeric conversion applied, NA values removed, chronological ordering applied. All steps performed in R only.

No manually prepared, edited, or externally created data file was used.

---

## 5. Exploratory Time Series Analysis

- **Strong upward trend:** Index rose from ~114 (Jan 2005) to ~3514 (Dec 2025)
- **Seasonality:** Consistent seasonal pattern visible in Q1 and autumn months
- **Structural break:** Accelerated inflation from 2022 onwards (post-currency crisis)
- **Missing values:** None
- **Total observations:** 252 monthly data points

---

## 6. Forecasting Methods Applied

| # | Method | Applicable |
|---|---|---|
| 1 | Naïve Forecasting | ✅ Yes |
| 2 | Moving Average (k=12) | ✅ Yes |
| 3 | Weighted Moving Average | ✅ Yes |
| 4 | Simple Exponential Smoothing | ✅ Yes |
| 5 | Holt Trend-Corrected ES | ✅ Yes — series has strong trend |
| 6 | Linear Trend Projection | ✅ Yes |
| 7 | Seasonal Indices | ✅ Yes — monthly data |
| 8 | Additive Decomposition | ✅ Yes |
| 9 | Multiplicative Decomposition | ✅ Yes |
| 10 | Regression with Trend + Seasonal Dummies | ✅ Yes |

---

## 7. Forecast Accuracy Comparison

| Method | Bias | MAD | MSE | MAPE | RSFE | Tracking Signal | Forecast (Jan 2026) |
|---|---|---|---|---|---|---|---|
| Naïve | 13.543 | 13.754 | 887.033 | 1.437 | 3399.38 | 247.158 | 3513.87 |
| Moving Average (k=12) | 73.186 | 73.186 | 21622.767 | 6.934 | 17637.88 | 241.000 | 3327.49 |
| Weighted MA | 23.096 | 23.194 | 2345.731 | 2.311 | 5751.005 | 247.947 | 3498.52 |
| Simple ES | 13.493 | 13.703 | 883.665 | 1.433 | 3400.224 | 248.144 | 3513.48 |
| **Holt (Best)** | **0.913** | **5.774** | **205.945** | **0.825** | **230.059** | **39.847** | **3570.68** |
| Linear Trend | 0.000 | 411.721 | 295567.731 | 118.853 | 0.000 | 0.000 | 3644.21 |
| Seasonal Indices | -2.046 | 409.264 | 292986.735 | 117.765 | -515.600 | -1.260 | 3598.44 |
| Additive Decomp. | 56.181 | 384.743 | 302446.727 | 104.797 | 14157.65 | 36.798 | 3598.44 |
| Multiplicative Decomp. | 56.271 | 384.832 | 302634.543 | 104.863 | 14180.39 | 36.848 | 3598.44 |
| Dummy Regression | 0.000 | 411.353 | 295250.927 | 118.892 | 0.000 | 0.000 | 3645.11 |

Full table: `outputs/tables/accuracy_comparison.csv`

---

## 8. Selection of the Superior Method

**Selected method: Holt Trend-Corrected Exponential Smoothing**

Justification:
1. **Lowest MAPE (0.825%)** — best percentage accuracy among all methods
2. **Lowest MAD (5.774)** and **lowest MSE (205.945)**
3. **Series has strong trend** — Holt explicitly models both level and trend components
4. **Tracking Signal (39.847)** is higher than ±4 due to the explosive inflation period (2022+), but still the best among trend-aware methods
5. **Fitted values** closely follow the actual series compared to other methods

---

## 9. Final Next-Period Forecast

| Field | Value |
|---|---|
| **Selected Superior Method** | Holt Trend-Corrected Exponential Smoothing |
| **Date of Data Access** | 2026-05-25 |
| **Latest Available Observation** | December 2025 (Index: 3513.87) |
| **Forecast Target Period** | January 2026 |
| **Forecasted Value** | **3570.68** (2003=100 base) |

---

## 10. Interpretation of Results

The CPI General Index is forecast to reach approximately **3570.68** in January 2026, up from 3513.87 in December 2025. This represents a monthly increase of approximately **1.6%**, consistent with the recent deceleration in Turkish inflation observed throughout 2025. The Holt method captures the persistent upward trend while adapting to recent changes in the rate of increase.

---

## 11. Limitations

- TÜİK SDMX API requires authentication; `statistical_data()` returns HTTP 401. Data accessed via `statistical_tables()` + `httr::GET()` (instructor-approved).
- The 2022 structural break (currency crisis) creates high volatility that classical methods cannot fully capture.
- Only classical forecasting methods applied (no ARIMA, no ML models).
- Tracking Signal exceeds ±4 for most methods due to the explosive 2022–2023 inflation period.
- Forecasts are point estimates with no confidence intervals reported.

---

## 12. Reproducibility

```r
# 1. Install required packages
install.packages(c("forecast", "zoo", "ggplot2", "tidyr",
                   "lubridate", "readxl", "httr", "rmarkdown", "devtools"))
devtools::install_github("emraher/tuikr")

# 2. Set working directory
setwd("~/Desktop/tuik-forecasting-project")

# 3. Render the report
rmarkdown::render("forecasting_project.Rmd")
```

Data is fetched automatically from the TUIK server on each run. No local data files are needed.

Alternatively, restore the exact package environment using renv:
```r
renv::restore()
```

---

## 13. Repository Structure
---
    
    ## 14. Author
    
    **Student Name:** Faysal Yaman  
**Student Number:** 138721021  
**Course:** Forecasting Methods  
**Term:** Spring 2026  
**GitHub:** https://github.com/faysalyaman/tuik-forecasting-project

