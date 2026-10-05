# This SQL script creates a view named `bank_segments` that segments the customers in the `bank_clean` view into different categories based on their balance, previous contact status, and the outcome of previous campaigns. 
#The segmentation is done using quartiles for balance and median for recency of contact, allowing for targeted marketing strategies.

CREATE OR REPLACE VIEW bank_segments AS
WITH seuils AS (
    SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY balance) AS bal_q1,
           percentile_cont(0.75) WITHIN GROUP (ORDER BY balance) AS bal_q3
    FROM bank_clean
),
recence AS (
    SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY days_since_last_contact) AS rec_mediane
    FROM bank_clean
    WHERE previously_contacted = 1
)
SELECT
    b.*,
    CASE
        WHEN b.poutcome = 'success'
            THEN '1 Ancien souscripteur'
        WHEN b.previously_contacted = 1 AND b.days_since_last_contact <= r.rec_mediane
            THEN '2 Recontacté récent (sans succès)'
        WHEN b.previously_contacted = 1
            THEN '3 Recontacté ancien (sans succès)'
        WHEN b.balance >= s.bal_q3
            THEN '4 Nouveau - solde élevé'
        WHEN b.balance >= s.bal_q1
            THEN '5 Nouveau - solde moyen'
        ELSE '6 Nouveau - solde faible'
    END AS segment,
    (b.housing = 'no' AND b.loan = 'no')::int AS sous_equipe
FROM bank_clean b
CROSS JOIN seuils s
CROSS JOIN recence r;