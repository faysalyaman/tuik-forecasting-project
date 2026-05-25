# TUIK CPI Forecasting Project

**Student:** Faysal Yaman  
**Course:** Forecasting Methods  
**Date:** May 2026

---

## Project Overview

This project forecasts the **Consumer Price Index (CPI) General Index (2003=100)** 
for Turkey using 10 classical time series forecasting methods.  
Data is accessed programmatically via the `tuikr` R package — no manual downloads.  
The target forecast period is **January 2026**.

---

## Data Source

| Field | Detail |
|---|---|
| **Source** | TUIK (Turkish Statistical Institute) |
| **Package** | `tuikr` v0.2.0 |
| **Theme** | Price Statistics (Theme ID: 6) |
| **Table** | Index numbers and rate of changes in the consumer price index |
| **Variable** | CPI General Index (Base year: 2003=100) |
| **Frequency** | Monthly |
| **Period** | January 2005 – December 2025 (252 observations) |
| **Access method** | `statistical_tables("6")` + `httr::GET()` inside R |

> **Note:** Due to HTTP 401 restrictions on the TUIK SDMX API (`nsiws.tuik.gov.tr`),  
> data is retrieved via `statistical_tables()` (istab type) combined with `httr::GET()`.  
> All data access is performed entirely in R — no manual file downloads.  
> This approach was approved by the course instructor.

---

## Research Objective

To identify the most accurate classical forecasting method for Turkish CPI  
and produce a point forecast for January 2026 by:

1. Exploring trend, seasonality, and structural breaks in the series  
2. Applying 10 forecasting methods systematically  
3. Comparing methods using 7 accuracy measures  
4. Selecting the best method with justification  

---

## Data Access with tuikr

```r
library(tuikr)
library(httr)
library(readxl)

# Step 1: Discover tables via tuikr
fiyat_tables <- statistical_tables("6")

# Step 2: Filter the CPI table
tufe_row <- fiyat_tables |>
  filter(node_type == "istab",
         grepl("Index numbers and rate of changes in the consumer price index",
               table_name, ignore.case = TRUE)) |>
  slice(1)

# Step 3: Fetch data programmatically inside R
resp <- GET(tufe_row$table_url,
  add_headers(
    `User-Agent` = "Mozilla/5.0",
    `Accept`     = "application/vnd.ms-excel, */*",
    `Referer`    = "https://veriportali.tuik.gov.tr/"
  ))
```

---

## Exploratory Analysis

Key findings from the series:

- **Strong upward trend**: Index rose from ~114 (Jan 2005) to ~3514 (Dec 2025)
- **Seasonality**: Consistent seasonal pattern, especially in Q1 and autumn months
- **Structural break**: Accelerated inflation from 2022 onwards
- **Missing values**: None
- **Total observations**: 252 monthly data points

---

## Forecasting Methods Applied

| # | Method | Notes |
|---|---|---|
| 1 | Naive | Baseline benchmark |
| 2 | Moving Average (k=12) | 12-month window captures full seasonal cycle |
| 3 | Weighted Moving Average | Weights: 0.5 / 0.3 / 0.2 (recent = higher) |
| 4 | Simple Exponential Smoothing | Alpha optimized via MSE minimization |
| 5 | Holt Trend-Corrected ES | Alpha + Beta optimized; suitable for strong trend |
| 6 | Linear Trend Projection | OLS: Y = a + b*t; slope interpreted per month |
| 7 | Seasonal Indices | Monthly indices = month avg / overall avg |
| 8 | Additive Decomposition | Y = Trend + Seasonal + Remainder |
| 9 | Multiplicative Decomposition | Y = Trend * Seasonal * Remainder |
| 10 | Trend + Seasonal Dummy Regression | 11 monthly dummies, December as reference |

---

## Accuracy Comparison

Seven accuracy measures computed for each method:

| Measure | Description |
|---|---|
| **Bias / ME** | Mean Error — systematic over/under estimation |
| **MAD** | Mean Absolute Deviation |
| **MSE** | Mean Squared Error |
| **MAPE** | Mean Absolute Percentage Error |
| **RSFE** | Running Sum of Forecast Errors |
| **Tracking Signal** | RSFE / MAD — detects systematic bias (threshold: ±4) |

Full comparison table: `outputs/tables/accuracy_comparison.csv`

---

## Best Method Selection

The best method was selected based on:

1. **Lowest MAPE** — primary criterion
2. **Tracking Signal within ±4** — no systematic bias
3. **Visual fit** — fitted values close to actual series
4. **Structural alignment** — method captures both trend and seasonality

The series exhibits a dominant upward trend with moderate seasonality,  
making trend-aware methods (Holt, Dummy Regression, Decomposition) superior  
to simple methods (Naive, MA).

---

## Final Forecast

| Field | Value |
|---|---|
| **Forecast Period** | January 2026 |
| **Best Method** | See `outputs/tables/final_forecast.csv` |
| **Forecast Value** | See `outputs/tables/final_forecast.csv` |
| **Base Year** | 2003 = 100 |

---

## Limitations

- TUIK SDMX API requires authentication; `statistical_data()` returns HTTP 401.  
  Data accessed via `statistical_tables()` + `httr::GET()` (instructor-approved).  
- Only classical forecasting methods applied (no ARIMA, no ML models).  
- Macroeconomic shocks (e.g. 2022 currency crisis) are not modelled explicitly.

---

## How to Reproduce

```r
# 1. Install required packages
install.packages(c("forecast", "zoo", "ggplot2", "tidyr",
                   "lubridate", "readxl", "httr", "rmarkdown"))
devtools::install_github("emraher/tuikr")

# 2. Set working directory
setwd("~/Desktop/tuik-forecasting-project")

# 3. Render the report
rmarkdown::render("forecasting_project.Rmd")
```

> Data is fetched automatically from the TUIK server on each run.  
> No local data files are needed.

---

## Repository Structure
---
    
    ## Author
    
    **Faysal Yaman**  
    Forecasting Methods Course — Spring 2026

