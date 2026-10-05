# This SQL script performs quality checks on the `bank_raw` table to ensure data integrity and consistency before any analysis is conducted

-- 1. Volume (expected : 45 211)
SELECT COUNT(*) AS nb_lignes FROM bank_raw;

-- 2. Exact duplicates, excluding row_id (expected : 0 ; otherwise, to document and remove duplicates)
SELECT COUNT(*) AS nb_groupes_doublons
FROM (
    SELECT age, job, marital, education, credit_default, balance, housing, loan,
           contact, contact_day, contact_month, duration, campaign, pdays,
           previous, poutcome, y
    FROM bank_raw
    GROUP BY age, job, marital, education, credit_default, balance, housing, loan,
             contact, contact_day, contact_month, duration, campaign, pdays,
             previous, poutcome, y
    HAVING COUNT(*) > 1
) d;

-- 3. Percentage of 'unknown' values ​​per column
SELECT 'job' AS colonne,
       ROUND(100.0 * COUNT(*) FILTER (WHERE job = 'unknown') / COUNT(*), 2) AS pct_unknown
FROM bank_raw
UNION ALL SELECT 'education',
       ROUND(100.0 * COUNT(*) FILTER (WHERE education = 'unknown') / COUNT(*), 2) FROM bank_raw
UNION ALL SELECT 'contact',
       ROUND(100.0 * COUNT(*) FILTER (WHERE contact = 'unknown') / COUNT(*), 2) FROM bank_raw
UNION ALL SELECT 'poutcome',
       ROUND(100.0 * COUNT(*) FILTER (WHERE poutcome = 'unknown') / COUNT(*), 2) FROM bank_raw;

-- 4. Distribution of balance (negative values and extremes)
SELECT MIN(balance) AS minimum,
       percentile_cont(0.25) WITHIN GROUP (ORDER BY balance) AS q1,
       percentile_cont(0.50) WITHIN GROUP (ORDER BY balance) AS mediane,
       percentile_cont(0.75) WITHIN GROUP (ORDER BY balance) AS q3,
       MAX(balance) AS maximum,
       COUNT(*) FILTER (WHERE balance < 0) AS nb_soldes_negatifs
FROM bank_raw;

-- 5. Cohérence pdays / previous (expected : 0 incoherences)
SELECT COUNT(*) FILTER (WHERE (pdays = -1) <> (previous = 0)) AS incoherences
FROM bank_raw;

-- 6. Categories of key categorical variables
SELECT y, COUNT(*) FROM bank_raw GROUP BY y;
SELECT contact_month, COUNT(*) FROM bank_raw GROUP BY contact_month ORDER BY 2 DESC;
SELECT poutcome, COUNT(*) FROM bank_raw GROUP BY poutcome ORDER BY 2 DESC;