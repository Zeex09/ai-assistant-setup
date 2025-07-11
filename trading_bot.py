import alpaca_trade_api as tradeapi
import time
import datetime

# === CONFIG ===
API_KEY = PK2KE0L5P1D67IB27Z3D
SECRET_KEY = wb19jbWB1e5GxJ9QrJWRwNS0VnRPIfNdmWdHZfnf
BASE_URL = 'https://paper-api.alpaca.markets'
SYMBOL = 'AAPL'
QTY = 1

# === SETUP ===
api = tradeapi.REST(API_KEY, SECRET_KEY, BASE_URL, api_version='v2')

# === SIMPLE STRATEGY ===
def get_rsi():
    bars = api.get_bars(SYMBOL, tradeapi.TimeFrame.Minute, limit=15)
    closes = [bar.c for bar in bars]

    gains = []
    losses = []

    for i in range(1, len(closes)):
        delta = closes[i] - closes[i - 1]
        if delta > 0:
            gains.append(delta)
        else:
            losses.append(abs(delta))

    avg_gain = sum(gains) / len(gains) if gains else 0
    avg_loss = sum(losses) / len(losses) if losses else 1  # avoid divide-by-zero

    rs = avg_gain / avg_loss
    rsi = 100 - (100 / (1 + rs))

    return rsi

def trade():
    rsi = get_rsi()
    print(f"[{datetime.datetime.now().strftime('%H:%M:%S')}] RSI: {rsi:.2f}")

    position = api.get_position(SYMBOL) if SYMBOL in [p.symbol for p in api.list_positions()] else None

    if rsi < 30 and not position:
        print("🟢 RSI low — buying...")
        api.submit_order(symbol=SYMBOL, qty=QTY, side='buy', type='market', time_in_force='gtc')

    elif rsi > 70 and position:
        print("🔴 RSI high — selling...")
        api.submit_order(symbol=SYMBOL, qty=QTY, side='sell', type='market', time_in_force='gtc')

    else:
        print("⏸️ No action taken.")

trade()
