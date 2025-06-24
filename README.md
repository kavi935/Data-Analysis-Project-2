# Data-Analysis-Project-2

# 📊 NIFTY 50 OHLC Dashboard Project (Daily, 5-Minute, 25-Minute)

This project presents a **multi-timeframe analysis** of NIFTY 50 stock market data using **Python, SQL, and Power BI**. It showcases technical indicators like RSI, MACD, SMA, and Bollinger Bands — all brought together into interactive dashboards for **daily**, **5-minute**, and **25-minute** intervals.

---

## 🖼️ Dashboard Previews

### 📅 Daily View  
![NIFTY OHLC Dashboard - Daily](Screenshot(day).png)

### ⏱️ 5-Minute View  
![NIFTY OHLC Dashboard - 5Min](Screenshot(5min).png)

### ⏱️ 25-Minute View  
![NIFTY OHLC Dashboard - 25Min](Screenshot(25min).png)

> 🧭 All dashboards are built with identical structure and filters to enable seamless time-based comparisons.

---

## 🎥 Dashboard Walkthrough

▶️ [Click here to watch full NIFTY dashboard demo](https://drive.google.com/uc?export=download&id=1ynnISazsBVBx6XZywOWQHHjozF91CU7P)


---

## 🐍 Python Script – Financial Calculations

All indicator logic is written in:

- `OHLC_financial_metrics__code.py` - computes Total Return,Sharp Ratio,Max Drawdown
- Output CSVs:
  - `calculated_financial_metrics_master_day.csv`
  - `calculated_financial_metrics_master_5min.csv`
  - `calculated_financial_metrics_master_25min.csv`

📦 Additional cleaned and zipped outputs:

- `OHLC_indicators_code.py` – computes MACD, RSI, drawdown, return, Bollinger Bands, etc.  
- Outputs:
- `master_day_macd_rsi_bb_output.zip`  
- `master_5min_macd_rsi_bb_clean.zip`  
- `master_25min_macd_rsi_bb_clean.csv`

> 🔁 To generate output for different timeframes (5-min or 25-min), change the  name from master_day to respective 5min & 25min in code.

---

## 🗃️ SQL Queries – Data Preparation

All preprocessing is done via:
- `OHLC_queries.sql`

🟩 Computes:
- SMA values  
- Monthly volatility  
- Price gaps  
- Streak and trend logic
- Consecutive Up/Down Days

🔄 **To switch from day to 5min or 25min**, just change the  name from master_day to respective 5min & 25min in query.

---

## 📁 Project Files

| File Name                                 | Description |
|------------------------------------------|-------------|
| `Screenshot(day).png`                    | Dashboard preview – Daily view |
| `Screenshot(5min).png`                   | Dashboard preview – 5-Minute view |
| `Screenshot(25min).png`                  | Dashboard preview – 25-Minute view |
| `OHLC_queries.sql`                       | SQL file for preparing OHLC base tables |
| `OHLC_financial_metrics_code.py`         | Python code to compute technical indicators |
| `OHLC_indicators_code`                   | Additional indicator calculations (custom logic) |
| `calculated_financial_metrics_master_day.csv`     | Output metrics for daily data |
| `calculated_financial_metrics_master_5min.csv`    | Output metrics for 5-min data |
| `calculated_financial_metrics_master_25min.csv`   | Output metrics for 25-min data |
| `master_day_macd_rsi_bb_output.zip`              | Zipped result with technical indicators – Daily |
| `master_5min_macd_rsi_bb_clean.zip`              | Zipped result with indicators – 5-Minute |
| `master_25min_macd_rsi_bb_clean.csv`             | Indicators – 25-Minute data |

---

### 🔹 Dataset Coverage:
- Timeframes: **Daily, 5min, 25min**
- Parameters: **Open, High, Low, Close, Volume**
- Derived indicators: **MACD, RSI, SMA (20/50), Bollinger Bands**, Volatility, Price Gaps

---

### 🔹 Key Observations (Daily Example-(Day)):
- 📈 **Total Return**: +190.19%, **Sharp Ratio**: 0.72 → Indicates decent long-term risk-adjusted performance  
- 📉 **Max Drawdown**: –38.44% → Risk exposure during market dips  
- 🔄 **Price Gaps & Volatility**: High gap activity and volatility in March 2020 (COVID crash)  
- 📊 **MACD, RSI, Bollinger Bands**: Show trend shifts, overbought/oversold zones, and breakout setups

---

### 💡 What This Dashboard Helps With:
- ✅ Quickly identify bullish/bearish trends and momentum shifts  
- ✅ Spot volatile periods and manage portfolio risk  
- ✅ Compare trading behavior across timeframes  
- ✅ Useful for investors (daily) and intraday traders (5min/25min)

---


## 🧰 Tools Used

- 🐍 Python (Pandas, NumPy, matplotlib logic)  
- 🗃️ SQL (Preprocessing and feature engineering)  
- 📊 Power BI (Interactive visuals and dashboards)  
- 🎥 Google Drive (for video walkthrough)

---



