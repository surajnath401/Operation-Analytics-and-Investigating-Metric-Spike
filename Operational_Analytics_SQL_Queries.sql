
-- =====================================================
-- Project: Operational Analytics & Metric Spike Investigation
-- Database: MySQL
-- Author: Suraj Nath
-- =====================================================

-- ==============================
-- CASE STUDY 1: JOB DATA ANALYSIS
-- ==============================

-- Create Database and Table
CREATE DATABASE IF NOT EXISTS company;
USE company;

CREATE TABLE IF NOT EXISTS job_data (
    ds DATE,
    job_id INT,
    actor_id INT,
    event VARCHAR(20),
    language VARCHAR(20),
    time_spent INT,
    org VARCHAR(5)
);

-- ------------------------------
-- 1. Jobs Reviewed Over Time
-- Jobs reviewed per hour for each day in November 2020
-- ------------------------------
SELECT 
    ds AS review_date,
    COUNT(job_id) AS jobs_per_day,
    SUM(time_spent)/3600 AS hours_spent,
    ROUND(COUNT(job_id) / (SUM(time_spent)/3600), 2) AS jobs_reviewed_per_hour
FROM job_data
WHERE ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY ds
ORDER BY ds;

-- ------------------------------
-- 2. Throughput Analysis
-- Daily throughput (events per second)
-- ------------------------------
SELECT 
    ds,
    ROUND(COUNT(event) / SUM(time_spent), 2) AS daily_avg_throughput
FROM job_data
GROUP BY ds
ORDER BY ds;

-- Overall throughput
SELECT 
    ROUND(COUNT(event) / SUM(time_spent), 2) AS overall_avg_throughput
FROM job_data;

-- ------------------------------
-- 3. Language Share Analysis
-- Percentage share of each language
-- ------------------------------
SELECT 
    language,
    ROUND(100.0 * COUNT(*) / total.total_count, 2) AS percentage_share
FROM job_data
CROSS JOIN (
    SELECT COUNT(*) AS total_count FROM job_data
) AS total
GROUP BY language, total.total_count;

-- ------------------------------
-- 4. Duplicate Row Detection
-- ------------------------------
SELECT 
    job_id,
    COUNT(*) AS duplicate_count
FROM job_data
GROUP BY job_id
HAVING COUNT(*) > 1;


-- =========================================
-- CASE STUDY 2: INVESTIGATING METRIC SPIKES
-- =========================================

-- ------------------------------
-- Users Table
-- ------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id INT,
    created_at DATETIME,
    company_id INT,
    language VARCHAR(40),
    activated_at VARCHAR(30),
    state VARCHAR(30)
);

-- ------------------------------
-- Events Table
-- ------------------------------
CREATE TABLE IF NOT EXISTS events (
    user_id INT,
    occurred_at DATETIME,
    event_type VARCHAR(30),
    event_name VARCHAR(40),
    location VARCHAR(30),
    device VARCHAR(30),
    user_type INT
);

-- ------------------------------
-- Email Events Table
-- ------------------------------
CREATE TABLE IF NOT EXISTS email_events (
    user_id INT,
    occurred_at DATETIME,
    action VARCHAR(200),
    user_type INT
);

-- ------------------------------
-- 1. Weekly User Engagement
-- ------------------------------
SELECT 
    EXTRACT(WEEK FROM occurred_at) AS week_num,
    COUNT(DISTINCT user_id) AS active_users
FROM events
WHERE event_type = 'engagement'
GROUP BY week_num
ORDER BY week_num;

-- ------------------------------
-- 2. User Growth Analysis
-- ------------------------------
WITH weekly_users AS (
    SELECT 
        EXTRACT(YEAR FROM created_at) AS year,
        EXTRACT(WEEK FROM created_at) AS week_num,
        COUNT(DISTINCT user_id) AS new_users
    FROM users
    GROUP BY year, week_num
)
SELECT 
    year,
    week_num,
    new_users,
    SUM(new_users) OVER (ORDER BY year, week_num) AS cumulative_users
FROM weekly_users
ORDER BY year, week_num;

-- ------------------------------
-- 3. Weekly Retention Analysis (Cohort Based)
-- ------------------------------
-- Weekly Retention Analysis (Cohort-Based)

SELECT
    first AS week_num,
    SUM(CASE WHEN week_num = 0  THEN 1 ELSE 0 END) AS week_0,
    SUM(CASE WHEN week_num = 1  THEN 1 ELSE 0 END) AS week_1,
    SUM(CASE WHEN week_num = 2  THEN 1 ELSE 0 END) AS week_2,
    SUM(CASE WHEN week_num = 3  THEN 1 ELSE 0 END) AS week_3,
    SUM(CASE WHEN week_num = 4  THEN 1 ELSE 0 END) AS week_4,
    SUM(CASE WHEN week_num = 5  THEN 1 ELSE 0 END) AS week_5,
    SUM(CASE WHEN week_num = 6  THEN 1 ELSE 0 END) AS week_6,
    SUM(CASE WHEN week_num = 7  THEN 1 ELSE 0 END) AS week_7,
    SUM(CASE WHEN week_num = 8  THEN 1 ELSE 0 END) AS week_8,
    SUM(CASE WHEN week_num = 9  THEN 1 ELSE 0 END) AS week_9,
    SUM(CASE WHEN week_num = 10 THEN 1 ELSE 0 END) AS week_10,
    SUM(CASE WHEN week_num = 11 THEN 1 ELSE 0 END) AS week_11,
    SUM(CASE WHEN week_num = 12 THEN 1 ELSE 0 END) AS week_12,
    SUM(CASE WHEN week_num = 13 THEN 1 ELSE 0 END) AS week_13,
    SUM(CASE WHEN week_num = 14 THEN 1 ELSE 0 END) AS week_14,
    SUM(CASE WHEN week_num = 15 THEN 1 ELSE 0 END) AS week_15,
    SUM(CASE WHEN week_num = 16 THEN 1 ELSE 0 END) AS week_16,
    SUM(CASE WHEN week_num = 17 THEN 1 ELSE 0 END) AS week_17,
    SUM(CASE WHEN week_num = 18 THEN 1 ELSE 0 END) AS week_18
FROM (
    SELECT
        m.user_id,
        m.login_week,
        n.first,
        m.login_week - n.first AS week_num
    FROM (
        SELECT
            user_id,
            EXTRACT(WEEK FROM occurred_at) AS login_week
        FROM events
        GROUP BY user_id, login_week
    ) m
    JOIN (
        SELECT
            user_id,
            MIN(EXTRACT(WEEK FROM occurred_at)) AS first
        FROM events
        GROUP BY user_id
    ) n
        ON m.user_id = n.user_id
) sub
GROUP BY first
ORDER BY first;

-- ------------------------------
-- 4. Weekly Engagement Per Device
-- ------------------------------
SELECT 
    STR_TO_DATE(CONCAT(YEARWEEK(occurred_at, 3), ' Monday'), '%X%V %W') AS week_start,
    device,
    COUNT(DISTINCT user_id) AS engaged_users
FROM events
WHERE event_type = 'engagement'
GROUP BY week_start, device
ORDER BY week_start, device;

-- ------------------------------
-- 5. Email Engagement Analysis
-- ------------------------------
SELECT 
    100.0 * SUM(CASE WHEN email_action = 'email_open' THEN 1 ELSE 0 END) /
            SUM(CASE WHEN email_action = 'email_sent' THEN 1 ELSE 0 END) AS email_open_rate,
    100.0 * SUM(CASE WHEN email_action = 'email_clicked' THEN 1 ELSE 0 END) /
            SUM(CASE WHEN email_action = 'email_sent' THEN 1 ELSE 0 END) AS email_click_rate
FROM (
    SELECT 
        CASE 
            WHEN action IN ('sent_weekly_digest', 'sent_reengagement_email') THEN 'email_sent'
            WHEN action = 'email_open' THEN 'email_open'
            WHEN action = 'email_clickthrough' THEN 'email_clicked'
            ELSE NULL
        END AS email_action
    FROM email_events
) sub;
