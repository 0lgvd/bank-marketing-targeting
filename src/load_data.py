# This script loads bank-full.csv dans PostgreSQL

import os

import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

CSV_PATH = "data/raw/bank-full.csv"

url = URL.create(
    "postgresql+psycopg2",
    username="analyst",
    password=os.environ["BANK_DB_PASSWORD"],
    host="localhost",
    port=5432,
    database="bank",
)
engine = create_engine(url)

df = pd.read_csv(CSV_PATH, sep=";")
df = df.rename(columns={
    "default": "credit_default",
    "month": "contact_month",
    "day": "contact_day",
})
df.insert(0, "row_id", range(1, len(df) + 1))  # ordre du fichier conservé

with engine.begin() as conn:
    conn.execute(text("TRUNCATE bank_raw"))  # permet de relancer sans doublons
    df.to_sql("bank_raw", conn, if_exists="append", index=False,
              method="multi", chunksize=1000)

print(f"{len(df)} lignes chargées dans bank_raw")