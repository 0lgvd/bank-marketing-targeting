# This SQL script creates the bank_raw table in the database. 
# The table is designed to store raw data related to bank customers and their interactions with the bank's marketing campaigns. 

DROP TABLE IF EXISTS bank_raw;

CREATE TABLE bank_raw (
    row_id          INT PRIMARY KEY,
    age             INT NOT NULL,
    job             TEXT,
    marital         TEXT,
    education       TEXT,
    credit_default  TEXT,
    balance         INT,
    housing         TEXT,
    loan            TEXT,
    contact         TEXT,
    contact_day     INT,
    contact_month   TEXT,
    duration        INT,
    campaign        INT,
    pdays           INT,
    previous        INT,
    poutcome        TEXT,
    y               TEXT
);