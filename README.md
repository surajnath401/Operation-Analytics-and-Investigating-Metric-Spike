# 📊 Operational Analytics & Metric Spike Investigation (SQL)

## 📝 Project Overview

This project focuses on **Operational Analytics and Metric Spike Investigation** using **MySQL**. The goal of the project is to analyze end-to-end operational data, identify performance trends, and investigate sudden changes (spikes or drops) in key business metrics.

In this project, I worked as a **Lead Data Analyst**, collaborating conceptually with operations, marketing, and product teams to derive actionable insights that support **data-driven decision making**.

---

## 🏗️ Project Approach

* Created relational databases and tables in **MySQL**
* Imported CSV files into MySQL Workbench
* Cleaned and transformed raw data (date-time formatting, data validation)
* Performed analytical queries to investigate operational performance
* Summarized insights in a structured analytical report

---

## 📂 Case Study 1: Job Data Analysis

**Dataset:** `job_data`

### Key Analyses:

* **Jobs Reviewed Over Time**
  Calculated the number of jobs reviewed per hour for each day in November 2020 to analyze operational workload and efficiency.

* **Throughput Analysis**
  Measured daily throughput (events per second) and calculated the **7-day rolling average** to reduce noise and identify consistent performance trends.

* **Language Share Analysis**
  Analyzed the percentage contribution of each language in job reviews over the last 30 days.

* **Duplicate Row Detection**
  Identified duplicate job records to highlight data quality issues.

### Key Insights:

* Job review activity varied significantly by date
* Rolling averages provided more reliable throughput insights than daily metrics
* Persian language had the highest share of job reviews
* Duplicate job IDs were detected, indicating data consistency issues

---

## 📂 Case Study 2: Investigating Metric Spikes

**Datasets Used:**

* `users`
* `events`
* `email_events`

### Key Analyses:

* **Weekly User Engagement**
  Measured weekly active users to track platform engagement trends.

* **User Growth Analysis**
  Analyzed weekly user sign-ups and calculated cumulative user growth over time.

* **Weekly Retention Analysis**
  Performed cohort-based retention analysis to understand user behavior after sign-up.

* **Weekly Engagement Per Device**
  Evaluated user engagement across different devices on a weekly basis.

* **Email Engagement Analysis**
  Calculated email open rates and click-through rates to assess email campaign effectiveness.

### Key Insights:

* User engagement showed steady growth before declining in later weeks
* Certain signup cohorts demonstrated stronger long-term retention
* Mobile and laptop devices contributed most to engagement
* Email open rates were significantly higher than click-through rates

---

## 🛠️ Tools & Technologies

* **MySQL**
* SQL Joins & Aggregations
* Window Functions
* Date & Time Functions
* Rolling Averages
* Cohort Analysis
* Data Cleaning & Validation

---
🧾 Conclusion

This project showcases the use of SQL for operational analytics to analyze performance, investigate metric spikes, and derive actionable insights. By studying job reviews, user engagement, growth, retention, and email metrics, I gained hands-on experience in data cleaning, cohort analysis, and trend evaluation. Overall, the project demonstrates how structured SQL analysis supports better operational and business decisions.
