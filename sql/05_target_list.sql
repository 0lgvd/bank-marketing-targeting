# This SQL script creates a view named `bank_target_rules` that selects the top 10,000 contacts based on business rules prioritizing segments for targeting
# The selection is based on segment priority and balance in descending order. 
# It also measures the performance of the selected target group compared to the entire dataset.
CREATE OR REPLACE VIEW bank_target_rules AS
SELECT row_id, segment, balance, converted, rang
FROM (
    SELECT row_id, segment, balance, converted,
           ROW_NUMBER() OVER (
                ORDER BY CASE LEFT(segment, 1)
                    WHEN '1' THEN 1
                    WHEN '4' THEN 2
                    WHEN '5' THEN 3
                    ELSE 4 END,
                balance DESC
           ) AS rang
    FROM bank_segments
) t
WHERE rang <= 10000;

-- Measure the performance of the selected target group compared to the entire dataset
SELECT 'Cible (règles métier)' AS population,
       COUNT(*) AS contacts,
       SUM(converted) AS souscriptions,
       ROUND(100.0 * AVG(converted), 2) AS taux_pct
FROM bank_target_rules
UNION ALL
SELECT 'Base complète', COUNT(*), SUM(converted), ROUND(100.0 * AVG(converted), 2)
FROM bank_segments;

-- Adjusted measure by period: does the target perform better than a random draw with the same temporal distribution? 
WITH d AS (
    SELECT row_id, NTILE(10) OVER (ORDER BY row_id) AS decile
    FROM bank_clean
),
r AS (
    SELECT d.decile, AVG(b.converted) AS taux_decile
    FROM d JOIN bank_clean b USING (row_id)
    GROUP BY d.decile
)
SELECT COUNT(*) AS contacts_cibles,
       SUM(t.converted) AS souscriptions_observees,
       ROUND(SUM(r.taux_decile), 0) AS attendues_tirage_meme_periode,
       ROUND(SUM(t.converted) / SUM(r.taux_decile), 2) AS lift_ajuste
FROM bank_target_rules t
JOIN d USING (row_id)
JOIN r USING (decile);