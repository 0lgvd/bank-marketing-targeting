# This SQL script calculates key performance indicators (KPIs) for the post-campaign analysis of the bank s marketing efforts
# It provides insights into the performance of the campaign across different channels, months, and the number of contacts made during the campaign
#The analysis helps identify areas of improvement and understand where the campaign performed well or poorly

-- 1.Campaign performance by channel
SELECT COALESCE(contact, 'inconnu') AS canal, COUNT(*) AS contacts,
       SUM(converted) AS souscriptions, ROUND(100.0 * AVG(converted), 2) AS taux_pct
FROM bank_clean GROUP BY 1 ORDER BY 2 DESC;

-- 2. Campaign performance by month
SELECT contact_month, contact_month_num, COUNT(*) AS contacts,
       SUM(converted) AS souscriptions, ROUND(100.0 * AVG(converted), 2) AS taux_pct
FROM bank_clean GROUP BY 1, 2 ORDER BY 2;

-- 3. Campaign performance by number of contacts during the campaign (do the returns decrease?)
SELECT CASE WHEN campaign = 1 THEN '1'
            WHEN campaign = 2 THEN '2'
            WHEN campaign = 3 THEN '3'
            WHEN campaign BETWEEN 4 AND 5 THEN '4-5'
            ELSE '6 et +' END AS nb_contacts,
       COUNT(*) AS clients, SUM(converted) AS souscriptions,
       ROUND(100.0 * AVG(converted), 2) AS taux_pct
FROM bank_clean GROUP BY 1 ORDER BY MIN(campaign);

-- 4. Distribution of contacts by decile (to check if the distribution is uniform or skewed)
SELECT decile, MIN(row_id) AS du_row, MAX(row_id) AS au_row,
       COUNT(*) AS contacts, ROUND(100.0 * AVG(converted), 2) AS taux_pct
FROM (SELECT row_id, converted, NTILE(10) OVER (ORDER BY row_id) AS decile
      FROM bank_clean) t
GROUP BY decile ORDER BY decile;

-- 5. Unknown channel distribution by month (to check if the unknown channel is concentrated in certain months)
SELECT contact_month_num, contact_month,
       COUNT(*) FILTER (WHERE contact IS NULL) AS canal_inconnu,
       COUNT(*) AS contacts
FROM bank_clean GROUP BY 1, 2 ORDER BY 1;

-- 6. Robustness: segment-based conversion, before/after the 70/30 cutoff point
SELECT segment,
       CASE WHEN row_id <= 31648 THEN 'a. train (70 % anciens)'
            ELSE 'b. test (30 % récents)' END AS periode,
       COUNT(*) AS contacts, SUM(converted) AS souscriptions,
       ROUND(100.0 * AVG(converted), 2) AS taux_pct
FROM bank_segments GROUP BY 1, 2 ORDER BY 1, 2;

-- 7. Monthly distribution of contacts in the last decile (to check if the last decile is concentrated in certain months)
SELECT contact_month,
       ROUND(100.0 * COUNT(*) FILTER (WHERE row_id > 40690) / COUNT(*), 1) AS pct_dans_dernier_decile
FROM bank_clean GROUP BY 1 ORDER BY 2 DESC;

-- 8. Adjusted lift by period (indirect standardization by chronological decile)
-- expected = conversions if each contact in the segment converted at the average rate of its decile

WITH d AS (
    SELECT segment, converted, NTILE(10) OVER (ORDER BY row_id) AS decile
    FROM bank_segments
),
r AS (
    SELECT decile, AVG(converted) AS taux_decile
    FROM d GROUP BY decile
)
SELECT d.segment,
       COUNT(*) AS contacts,
       SUM(d.converted) AS observees,
       ROUND(SUM(r.taux_decile), 0) AS attendues,
       ROUND(SUM(d.converted) / SUM(r.taux_decile), 2) AS lift_ajuste
FROM d JOIN r USING (decile)
GROUP BY d.segment ORDER BY d.segment;