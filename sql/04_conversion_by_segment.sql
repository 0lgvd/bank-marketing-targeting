# This SQL script calculates the performance of the campaign by segment  
# Lift = taux du segment / taux global
# IC 95 % de Wilson (z = 1.96, z^2 = 3.8416)

WITH g AS (
    SELECT AVG(converted)::numeric AS p_global FROM bank_segments
),
seg AS (
    SELECT segment,
           COUNT(*)::numeric AS n,
           SUM(converted)    AS souscriptions,
           AVG(converted)::numeric AS p
    FROM bank_segments
    GROUP BY segment
)
SELECT segment,
       n::int AS contacts,
       souscriptions,
       ROUND(100 * p, 2) AS taux_pct,
       ROUND(p / g.p_global, 2) AS lift,
       ROUND(100 * ((p + 3.8416 / (2 * n)) / (1 + 3.8416 / n)
             - 1.96 * sqrt(p * (1 - p) / n + 3.8416 / (4 * n * n)) / (1 + 3.8416 / n)), 2) AS ic95_bas,
       ROUND(100 * ((p + 3.8416 / (2 * n)) / (1 + 3.8416 / n)
             + 1.96 * sqrt(p * (1 - p) / n + 3.8416 / (4 * n * n)) / (1 + 3.8416 / n)), 2) AS ic95_haut
FROM seg CROSS JOIN g
ORDER BY segment;