# This SQL script creates a view named `bank_clean` that transforms the raw data from the `bank_raw` table into a cleaner format suitable for analysis and modeling
# The view includes transformations such as replacing 'unknown' values with NULL, converting categorical variables into numerical formats, and creating new columns for easier analysis
# This allows working with a more structured dataset without altering the original raw data in the `bank_raw` table

CREATE OR REPLACE VIEW bank_clean AS
SELECT
    row_id,
    age,
    NULLIF(job, 'unknown')        AS job,
    marital,
    NULLIF(education, 'unknown')  AS education,
    credit_default,
    balance,
    housing,
    loan,
    NULLIF(contact, 'unknown')    AS contact,
    contact_day,
    contact_month,
    CASE contact_month
        WHEN 'jan' THEN 1  WHEN 'feb' THEN 2  WHEN 'mar' THEN 3
        WHEN 'apr' THEN 4  WHEN 'may' THEN 5  WHEN 'jun' THEN 6
        WHEN 'jul' THEN 7  WHEN 'aug' THEN 8  WHEN 'sep' THEN 9
        WHEN 'oct' THEN 10 WHEN 'nov' THEN 11 WHEN 'dec' THEN 12
    END                           AS contact_month_num,
    duration, -- connue après l'appel
    campaign,
    NULLIF(pdays, -1)             AS days_since_last_contact,
    (pdays <> -1)::int            AS previously_contacted,
    previous,
    NULLIF(poutcome, 'unknown')   AS poutcome,
    (y = 'yes')::int              AS converted
FROM bank_raw;