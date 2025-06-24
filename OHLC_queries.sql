--                                                       Nifty 50 OHLC Data(9-jan-2015 TO 25-apr-2025)

-- 1) Daily Price Range and Average Price

SELECT
    start_time::date AS trade_date,
    (high - low) AS daily_range,
    (open + high + low + close) / 4 AS avg_price
FROM
    master_day
ORDER BY
    trade_date;

-- 2) Monthly Average Closing Price

SELECT
    TO_CHAR(start_time, 'YYYY-MM') AS trade_month,
    AVG(close) AS monthly_avg_close
FROM
    master_day
GROUP BY
    trade_month
ORDER BY
    trade_month;

-- 3) Yearly High and Low Prices

SELECT
    EXTRACT(YEAR FROM start_time) AS trade_year,
    MAX(high) AS yearly_high,
    MIN(low) AS yearly_low
FROM
    master_day
GROUP BY
    trade_year
ORDER BY
    trade_year;

-- 4) Days with Significant Price Change (e.g., > 1% change from Open to Close)

SELECT
    start_time::date AS trade_date,
    open,
    close,
    ((close - open) / open) * 100 AS percentage_change
FROM
    master_day
WHERE
    ABS(((close - open) / open) * 100) > 1
ORDER BY
    trade_date;

-- 5) Consecutive Up/Down Days (using Window Functions)

SELECT
    daily_changes.trade_date,
    daily_changes.start_time, -- Original start_time from master_day
    daily_changes.close,
    daily_changes.change,
    SUM(CASE WHEN daily_changes.change > 0 THEN 1 ELSE 0 END) OVER (ORDER BY daily_changes.trade_date) -
    SUM(CASE WHEN daily_changes.change < 0 THEN 1 ELSE 0 END) OVER (ORDER BY daily_changes.trade_date) AS streak
FROM (
    SELECT
        start_time::date AS trade_date,
        start_time, -- Include original start_time in subquery for outer query
        close,
        close - LAG(close, 1, close) OVER (ORDER BY start_time) AS change
    FROM
        master_day
) AS daily_changes
WHERE ABS(daily_changes.change) > 0 -- Only consider days with actual change
ORDER BY daily_changes.trade_date;

-- 6) Trading Gaps (Open price significantly different from previous day's Close)

SELECT
    current_day.start_time::date AS trade_date,
	 current_day.start_time AS start_time,
    previous_day.close AS previous_close,
    current_day.open AS current_open,
    (current_day.open - previous_day.close) AS price_gap
FROM
    master_day AS current_day
JOIN
    master_day AS previous_day
ON
    current_day.start_time::date = (previous_day.start_time::date + INTERVAL '1 day')
WHERE
    ABS(current_day.open - previous_day.close) > (previous_day.close * 0.005); -- Example: gap > 0.5%

-- 7) Calculate Moving Averages (e.g., 20-day Simple Moving Average)

SELECT
    start_time::date AS trade_date,
    "start_time",
    "high",
    "low",
    "open",
    close,
    AVG(close) OVER (ORDER BY start_time ROWS BETWEEN 19 PRECEDING AND CURRENT ROW) AS sma_20_day
FROM
    master_day
ORDER BY
    trade_date;

-- 8) Highest Closing Price for Each Month

WITH MonthlyHigh AS (
    SELECT
        TO_CHAR(start_time, 'YYYY-MM') AS trade_month,
        MAX(close) AS highest_monthly_close
    FROM
        master_day
    GROUP BY
        trade_month
)
SELECT
    m.trade_month,
    m.highest_monthly_close,
    (SELECT start_time::date FROM master_day WHERE TO_CHAR(start_time, 'YYYY-MM') = m.trade_month AND close = m.highest_monthly_close LIMIT 1) AS date_of_highest_close
FROM
    MonthlyHigh m
ORDER BY
    m.trade_month;

-- 9) Daily Performance with Intraday Extremes from Finer Granularity

SELECT
    d."start_time"::date AS trade_date, -- Date from the daily table
    d."open" AS daily_open,
    d."close" AS daily_close,
    d."high" AS daily_high,
    d."low" AS daily_low,
    m.max_intraday_high AS twentyfive_min_high, -- Highest price from the 25-min data for that day
    m.min_intraday_low AS twentyfive_min_low -- Lowest price from the 25-min data for that day
FROM
    master_day AS d -- Your main daily data table (aliased as 'd')
JOIN ( -- This is a temporary calculation for the 25-min data
    SELECT
        "start_time"::date AS current_day_date, -- Convert 25-min timestamp to just a date
        MAX("high") AS max_intraday_high, -- Find the highest price within that day in 25-min data
        MIN("low") AS min_intraday_low -- Find the lowest price within that day in 25-min data
    FROM
        master_25min -- From your 25-minute data table
    GROUP BY
        current_day_date -- Group by date to get one high/low pair per day from 25-min data
) AS m ON d."start_time"::date = m.current_day_date -- Connect the daily table (d) with the 25-min summary (m) using the date
ORDER BY
    trade_date ASC;

-- 10) Monthly Volatility and Average Price

WITH DailyReturns AS (
    SELECT
        "start_time"::date AS trade_date,
        "close",
        -- Calculate daily_return directly in the SELECT list
        (("close" - LAG("close", 1) OVER (ORDER BY "start_time"::date)) / LAG("close", 1) OVER (ORDER BY "start_time"::date)) AS daily_return
    FROM
        master_day
)
SELECT
    TO_CHAR(trade_date, 'YYYY-MM') AS trade_month,
    AVG("close") AS monthly_avg_close,
    STDDEV_SAMP(daily_return)::NUMERIC(30, 20) AS monthly_volatility_raw -- Cast to NUMERIC with 20 decimal places
FROM
    DailyReturns
WHERE
    daily_return IS NOT NULL
GROUP BY
    trade_month
ORDER BY
    trade_month ASC;


--                                                                           END
