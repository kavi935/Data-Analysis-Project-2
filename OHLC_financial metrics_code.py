import pandas as pd
import numpy as np

def calculate_stock_metrics(df_data):
    """
    Calculates Total Return (%), Maximum Drawdown (%), and Sharpe Ratio (Annualized).

    Args:
        df_data (pd.DataFrame): DataFrame with 'start_time' (datetime or convertible)
                                and 'close' prices. Assumes 'start_time' column exists
                                and data is sorted by 'start_time'.

    Returns:
        dict: A dictionary containing the calculated metrics.
    """
    df = df_data.copy() # Work on a copy to avoid modifying original DataFrame

    # Ensure 'start_time' is datetime and set as index if not already
    # The data loading step below will ensure 'start_time' is datetime
    # and the function then uses it as is.
    if not isinstance(df.index, pd.DatetimeIndex) and 'start_time' in df.columns:
        # If 'start_time' is not index, set it as index after conversion
        df = df.set_index('start_time').sort_index()
    elif not isinstance(df.index, pd.DatetimeIndex) and 'start_time' not in df.columns:
        raise ValueError("DataFrame must have a 'start_time' column or a DatetimeIndex.")
    elif isinstance(df.index, pd.DatetimeIndex):
        # Already has DatetimeIndex, ensure it's sorted
        df = df.sort_index()


    # Calculate Daily Returns
    # Handle potential non-trading days or gaps, ensuring returns are aligned to 'close' price dates
    df['daily_return'] = df['close'].pct_change()

    # --- 1. Total Return (Percentage) ---
    # Calculate over the entire period of the DataFrame
    if not df['close'].empty and df['close'].iloc[0] != 0:
        total_return_percent = ((df['close'].iloc[-1] - df['close'].iloc[0]) / df['close'].iloc[0]) * 100
    else:
        total_return_percent = np.nan # Handle empty or zero first price
    
    # --- 2. Maximum Drawdown (Percentage) ---
    # Calculate cumulative returns (starting from 1 + first_return)
    # Corrected line: removed 'subset' argument from dropna() as it's a Series
    cum_returns = (1 + df['daily_return'].dropna()).cumprod()

    if not cum_returns.empty:
        rolling_max = cum_returns.expanding(min_periods=1).max()
        drawdown = (cum_returns / rolling_max) - 1
        max_drawdown_percent = drawdown.min() * 100
    else:
        max_drawdown_percent = np.nan # No returns to calculate drawdown

    # --- 3. Sharpe Ratio (Annualized) ---
    # Annualization factor for daily data (approx. 252 trading days)
    annualization_factor = np.sqrt(252) # Correct for daily data

    # Calculate average daily return and standard deviation of daily returns
    # Exclude NaN from daily_return
    avg_daily_return = df['daily_return'].mean() # Mean will automatically exclude NaNs
    std_daily_return = df['daily_return'].std() # Std will automatically exclude NaNs

    # Assume a Risk-Free Rate of 0 for simplicity.
    risk_free_rate_daily = 0

    if std_daily_return != 0:
        sharpe_ratio = ((avg_daily_return - risk_free_rate_daily) / std_daily_return) * annualization_factor
    else:
        sharpe_ratio = np.nan # Handle cases with zero volatility

    metrics = {
        "Total Return (%)": total_return_percent,
        "Maximum Drawdown (%)": max_drawdown_percent,
        "Sharpe Ratio (Annualized)": sharpe_ratio
    }
    return metrics


# --- START OF YOUR SCRIPT'S EXECUTION ---

# Define the path to your master_day.csv file
# Make sure the filename is 'master_day.csv' if it's in the same directory as this script.
# Use a raw string (r"...") for Windows paths to avoid errors.
csv_file_path = r"C:\Users\KAVI\Downloads\master_25min.csv" # <--- VERIFY THIS PATH!

try:
    # Load the CSV data into a DataFrame
    master_25min = pd.read_csv(csv_file_path)

    # --- Data Preparation ---
    # Your 'start_time' and 'close' columns are already correctly named.
    # Just need to convert 'start_time' to datetime objects.
    master_25min['start_time'] = pd.to_datetime(master_25min['start_time'])

    # Sort by 'start_time' to ensure correct time-series calculations
    master_25min = master_25min.sort_values(by='start_time')

    # Now, pass your prepared master_day_df to the calculation function
    calculated_metrics = calculate_stock_metrics(master_25min)

    print("--- Calculated Metrics from master_day.csv ---")
    for key, value in calculated_metrics.items():
        print(f"{key}: {value:.2f}")

    # --- Export results to CSV for Power BI ---
    metrics_df_for_pb = pd.DataFrame([calculated_metrics])
    # Using a distinct name for the output CSV to avoid confusion
    csv_export_path = "calculated_financial_metrics_master_25min.csv"
    metrics_df_for_pb.to_csv(csv_export_path, index=False)
    print(f"\nMetrics exported to: {csv_export_path}")

except FileNotFoundError:
    print(f"Error: The file '{csv_file_path}' was not found. Please check the path and filename carefully.")
except KeyError as e:
    print(f"Error: Missing expected column in the CSV. Ensure 'start_time' and 'close' columns exist. Error: {e}")
except Exception as e:
    print(f"An unexpected error occurred: {e}")