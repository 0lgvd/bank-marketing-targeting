# This SQL script calculates key performance indicators (KPIs) for the post-campaign analysis of the bank's marketing efforts
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