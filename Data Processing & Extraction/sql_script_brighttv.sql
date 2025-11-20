--viewership
SELECT * FROM ziller LIMIT 20;
---user_profiles
SELECT * FROM piller LIMIT 20;



--- daily
SELECT 
    DATE_TRUNC(
        'day', 
        DATEADD(hour, 2, TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI'))
    ) AS day_sast,
    COUNT(*) AS sessions,
    SUM(
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
    ) AS total_minutes,
    COUNT(DISTINCT USERID) AS unique_users
FROM ziller
GROUP BY 1
ORDER BY 1;

--monthly usage
SELECT
    DATE_TRUNC(
        'month', 
        DATEADD(hour, 2, TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI'))
    ) AS month_sast,
    COUNT(*) AS sessions,
    SUM(
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
    ) AS total_minutes
FROM ziller
GROUP BY 1
ORDER BY 1;

--hourly
SELECT
    DATE_PART('hour', DATEADD(hour, 2, TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI'))) AS hour_of_day,
    COUNT(*) AS sessions,
    SUM(
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
    ) AS total_minutes,
    AVG(
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
    ) AS avg_session_minutes
FROM ziller
GROUP BY 1
ORDER BY 1;

--weekly
SELECT
    TO_CHAR(DATEADD(hour, 2, TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI')), 'DY') AS weekday,
    DATE_PART('dow', DATEADD(hour, 2, TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI'))) AS dow,
    COUNT(*) AS sessions,
    SUM(
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
    ) AS total_minutes
FROM ziller
GROUP BY 1,2
ORDER BY dow;

---Content Consumption by Channel
SELECT
    CHANNEL2,
    COUNT(*) AS sessions,
    SUM(
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
    ) AS total_minutes,
    AVG(
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
    ) AS avg_duration
FROM ziller
GROUP BY 1
ORDER BY total_minutes DESC;

--Top Content by Total Watch Time
SELECT
    CHANNEL2 AS content_title,
    COUNT(*) AS sessions,
    SUM(
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
        TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
    ) AS total_minutes
FROM ziller
GROUP BY 1
ORDER BY total_minutes DESC
LIMIT 20;

----checking columns
DESC TABLE piller;

------  Demographic Influence on Consumption
SELECT
    u.GENDER,
    u.AGE,
    u.PROVINCE,
    COUNT(v.USERID) AS sessions,
    SUM(
        TO_NUMBER(SPLIT_PART(v.DURATION2, ':', 1)) * 60 +
        TO_NUMBER(SPLIT_PART(v.DURATION2, ':', 2)) +
        TO_NUMBER(SPLIT_PART(v.DURATION2, ':', 3)) / 60
    ) AS total_minutes
FROM ziller v
LEFT JOIN piller u
    ON v.USERID = u.USERID
GROUP BY 1,2,3
ORDER BY total_minutes DESC;



-- Low Consumption Days (Bottom 10%)

WITH daily AS (
    SELECT 
        DATE_TRUNC('day', DATEADD(hour, 2, TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI'))) AS day_sast,
        SUM(
            TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
            TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
            TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
        ) AS total_minutes
    FROM ziller
    GROUP BY 1
)
SELECT *
FROM daily
WHERE total_minutes <= (
    SELECT APPROX_PERCENTILE(total_minutes, 0.10) FROM daily
)
ORDER BY day_sast;


---Popular Channels on Low-Consumption Days
--DESC TABLE ziller;

---convert date and show all columns
SELECT
    USERID,
    CHANNEL2,
    TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI') AS RECORDDATE2_TS,
    DURATION2
FROM ziller;

-----Group by YEAR

SELECT
    YEAR(TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS YEAR,
    COUNT(*) AS TOTAL_RECORDS
FROM ziller
GROUP BY 1
ORDER BY 1;

---Group by MONTH
SELECT
    TO_CHAR(TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI'), 'YYYY-MM') AS YEAR_MONTH,
    COUNT(*) AS TOTAL_RECORDS
FROM ziller
GROUP BY 1
ORDER BY 1;

---specific date range
SELECT *
FROM ziller
WHERE TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI')
      BETWEEN '2016-01-01' AND '2016-12-31';

---Count by CHANNEL2

SELECT
    CHANNEL2,
    COUNT(*) AS TOTAL
FROM ziller
GROUP BY CHANNEL2
ORDER BY TOTAL DESC;


----------------- Power Users (Top 5%)

WITH totals AS (
    SELECT USERID, 
        SUM(
            TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
            TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
            TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
        ) AS total_minutes
    FROM ziller
    GROUP BY 1
)
SELECT *
FROM totals
WHERE total_minutes >= (
    SELECT APPROX_PERCENTILE(total_minutes, 0.95)
    FROM totals
)
ORDER BY total_minutes DESC;

-------Light Users (Bottom 30%)

WITH totals AS (
    SELECT USERID, 
        SUM(
            TO_NUMBER(SPLIT_PART(DURATION2, ':', 1)) * 60 +
            TO_NUMBER(SPLIT_PART(DURATION2, ':', 2)) +
            TO_NUMBER(SPLIT_PART(DURATION2, ':', 3)) / 60
        ) AS total_minutes
    FROM ziller
    GROUP BY 1
)
SELECT USERID
FROM totals
WHERE total_minutes <= (
    SELECT APPROX_PERCENTILE(total_minutes, 0.30)
    FROM totals
);

--------
WITH last_seen AS (
    SELECT 
        USERID, 
        MAX(DATEADD(
            hour, 
            2, 
            TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI')
        )) AS last_activity
    FROM ziller
    GROUP BY USERID
)
SELECT
    u.USERID,
    u.GENDER,
    u.AGE,
    u.PROVINCE AS REGION,   -- closest match (you don't have REGION)
    NULL AS SUBSCRIPTION_TYPE,  -- this column does NOT exist
    ls.last_activity
FROM piller u
LEFT JOIN last_seen ls 
    ON u.USERID = ls.USERID
WHERE ls.last_activity IS NULL
   OR ls.last_activity < DATEADD(day, -90, CURRENT_TIMESTAMP());

----------
-------------------------------------------------------------------
--------THE FULLY-CORRECTED SCRIPT

SELECT 
    MIN(Age) AS MIN_AGE,
    MAX(Age) AS MAX_AGE
FROM piller;
-------
SELECT 
    MIN(TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS MIN_TIMESTAMP,
    MAX(TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS MAX_TIMESTAMP
FROM ziller;

------
SELECT COUNT(*) AS TOTAL_USERS FROM piller;

SELECT COUNT(DISTINCT USERID) AS UNIQUE_USERS FROM piller;

SELECT COUNT(*) AS TOTAL_VIEWERSHIP_RECORDS FROM ziller;

SELECT COUNT(USERID) AS NON_NULL_USERID_COUNT FROM ziller;


-----dupes for user profiles
SELECT 
    USERID,
    COUNT(*) AS DUP_COUNT
FROM piller
GROUP BY USERID
HAVING COUNT(*) > 1;

--- dupes for viewership
SELECT 
    USERID,
    CHANNEL2,
    RECORDDATE2,
    COUNT(*) AS DUP_COUNT
FROM ziller
GROUP BY USERID, CHANNEL2, RECORDDATE2
HAVING COUNT(*) > 1;

---veiwership table withno dupes

SELECT DISTINCT *
FROM ziller;

---missing value checks
SELECT * 
FROM piller
WHERE USERID IS NULL 
   OR NAME IS NULL 
   OR SURNAME IS NULL 
   OR EMAIL IS NULL 
   OR GENDER IS NULL 
   OR RACE IS NULL 
   OR AGE IS NULL 
   OR PROVINCE IS NULL 
   OR SOCIAL_MEDIA_HANDLE IS NULL;

-- -----zerooooooooooo
-- SELECT * 
-- FROM ziller
-- WHERE USERID IS NULL 
--    OR CHANNEL2 IS NULL 
--    OR RECORDDATE2 IS NULL 
--    OR DURATION2 IS NULL;





    ---
    -- ==========================================================
-- CLEAN USER PROFILES
-- ==========================================================

SELECT 
    USERID,
    NAME,
    SURNAME,
    EMAIL,
    GENDER,
    RACE,
    AGE,
    PROVINCE,
    SOCIAL_MEDIA_HANDLE,

    CASE
        WHEN AGE BETWEEN 1 AND 12 THEN 'Younger than 13'
        WHEN AGE BETWEEN 13 AND 25 THEN '13 to 25'
        WHEN AGE BETWEEN 26 AND 44 THEN '26 to 44'
        WHEN AGE >= 45 THEN '45 and older'
        ELSE 'Not Specified'
    END AS AGE_GROUP
FROM piller;

-- ==========================================================
-- CLEAN & ENRICH VIEWERSHIP TABLE
-- ==========================================================

SELECT
    USERID,
    CHANNEL2,
    RECORDDATE2,
    DURATION2,

    -- Convert RECORDDATE2 string to timestamp
    TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI') AS START_TS,

    -- Extract time portion
    TO_CHAR(TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI'), 'HH24:MI:SS') AS TIME,

    -- Extract day of week
    DAYNAME(TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS DAY,

    -- Extract month
    MONTHNAME(TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS MONTH,

    -- Extract year
    YEAR(TO_TIMESTAMP(RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS YEAR,

    -- Convert DURATION2 to minutes
    EXTRACT(HOUR FROM DURATION2) * 60
    + EXTRACT(MINUTE FROM DURATION2)
    + EXTRACT(SECOND FROM DURATION2)/60 AS DURATION_MINUTES

FROM ziller;


-- ==========================================================
--  CREATE FINAL ANALYTICS TABLE (JOIN USER + VIEWERSHIP)
-- ==========================================================



SELECT
    u.USERID,
    u.NAME,
    u.SURNAME,
    u.GENDER,
    u.RACE,
    u.PROVINCE,

    -- Compute AGE_GROUP dynamically
    CASE
        WHEN u.AGE BETWEEN 1 AND 12 THEN 'Younger than 13'
        WHEN u.AGE BETWEEN 13 AND 25 THEN '13 to 25'
        WHEN u.AGE BETWEEN 26 AND 44 THEN '26 to 44'
        WHEN u.AGE >= 45 THEN '45 and older'
        ELSE 'Not Specified'
    END AS AGE_GROUP,

    v.CHANNEL2,
    v.DURATION2,

    -- Convert DURATION2 (TIME) to minutes
    EXTRACT(HOUR FROM v.DURATION2) * 60
    + EXTRACT(MINUTE FROM v.DURATION2)
    + EXTRACT(SECOND FROM v.DURATION2)/60 AS DURATION_MINUTES,

    -- Extract timestamp components from RECORDDATE2
    TO_CHAR(TO_TIMESTAMP(v.RECORDDATE2, 'YYYY/MM/DD HH24:MI'), 'HH24:MI:SS') AS TIME,
    DAYNAME(TO_TIMESTAMP(v.RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS DAY,
    MONTHNAME(TO_TIMESTAMP(v.RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS MONTH,
    YEAR(TO_TIMESTAMP(v.RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS YEAR,

    -- Watch duration buckets
    CASE
        WHEN (EXTRACT(HOUR FROM v.DURATION2) * 60
              + EXTRACT(MINUTE FROM v.DURATION2)
              + EXTRACT(SECOND FROM v.DURATION2)/60) < 180 THEN '0 - 3 Hrs'
        WHEN (EXTRACT(HOUR FROM v.DURATION2) * 60
              + EXTRACT(MINUTE FROM v.DURATION2)
              + EXTRACT(SECOND FROM v.DURATION2)/60) < 360 THEN '3 - 6 Hrs'
        WHEN (EXTRACT(HOUR FROM v.DURATION2) * 60
              + EXTRACT(MINUTE FROM v.DURATION2)
              + EXTRACT(SECOND FROM v.DURATION2)/60) < 540 THEN '6 - 9 Hrs'
        ELSE '9 - 12 Hrs'
    END AS WATCH_DURATION,

    -- Time of day
    CASE
        WHEN TO_CHAR(TO_TIMESTAMP(v.RECORDDATE2, 'YYYY/MM/DD HH24:MI'), 'HH24:MI:SS') 
             BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN TO_CHAR(TO_TIMESTAMP(v.RECORDDATE2, 'YYYY/MM/DD HH24:MI'), 'HH24:MI:SS') 
             BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN TO_CHAR(TO_TIMESTAMP(v.RECORDDATE2, 'YYYY/MM/DD HH24:MI'), 'HH24:MI:SS') 
             BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS TIME_TYPE

FROM piller u
JOIN ziller v
    ON u.USERID = v.USERID;

-- ==========================================================
--  OPTIONAL: SAMPLE ANALYTICS QUERIES
-- ==========================================================

-- Users per channel
SELECT CHANNEL2 AS CHANNEL, COUNT(DISTINCT USERID) AS USER_COUNT
FROM ziller
GROUP BY 1
ORDER BY USER_COUNT DESC;

-- Users per age group
SELECT 
    CASE
        WHEN u.AGE BETWEEN 1 AND 12 THEN 'Younger than 13'
        WHEN u.AGE BETWEEN 13 AND 25 THEN '13 to 25'
        WHEN u.AGE BETWEEN 26 AND 44 THEN '26 to 44'
        WHEN u.AGE >= 45 THEN '45 and older'
        ELSE 'Not Specified'
    END AS AGE_GROUP,
    COUNT(DISTINCT v.USERID) AS USER_COUNT
FROM piller u
JOIN ziller v ON u.USERID = v.USERID
GROUP BY 1
ORDER BY USER_COUNT DESC;


-- Users per time of day
SELECT
    CASE
        WHEN TO_CHAR(TO_TIMESTAMP(v.RECORDDATE2, 'YYYY/MM/DD HH24:MI'), 'HH24:MI:SS') 
             BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN TO_CHAR(TO_TIMESTAMP(v.RECORDDATE2, 'YYYY/MM/DD HH24:MI'), 'HH24:MI:SS') 
             BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN TO_CHAR(TO_TIMESTAMP(v.RECORDDATE2, 'YYYY/MM/DD HH24:MI'), 'HH24:MI:SS') 
             BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS TIME_TYPE,
    COUNT(DISTINCT v.USERID) AS USER_COUNT
FROM ziller v
JOIN piller u ON u.USERID = v.USERID
GROUP BY 1
ORDER BY USER_COUNT DESC;
