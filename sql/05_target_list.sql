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
                            WHEN '2' THEN 2
                            WHEN '4' THEN 3
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