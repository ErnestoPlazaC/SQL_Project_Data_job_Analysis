/*Diferent types of data formating*/
SELECT '2023-02-19'::DATE, --The :: is called a cast. It is used to format data
    '123'::INTEGER,
    'true'::BOOLEAN,
    '3.14'::REAL;

/*Date format*/
SELECT job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date --The ::Date is used to format the string into a date and deletes the timestamp--
FROM job_postings_fact
LIMIT 1000;

/*Timestamps & time zones*/
SELECT job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM job_postings_fact
LIMIT 1000;

/*Extract function*/
SELECT job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM job_postings_fact
LIMIT 1000;

/*Trend Analysis using SQL*/
SELECT 
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'    
GROUP BY 
    month
ORDER BY
    job_posted_count DESC
/*With this analysis we can identify wich months of the year had the most job postings*/

--PRACTICE PROBLEMS--
/*1. Write a query to find the avarege salary both yearly (salary_year_avg) and hourly
(salary_hour_avg) for job postings that were posted after june 1, 2023. Group de results
by job schedule type.*/

SELECT 
    job_schedule_type,
    AVG(salary_year_avg) AS average_yearly_salary,
    AVG(salary_hour_avg) AS average_hourly_salary
FROM 
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type

/*2. Write a query to count the number of job postings for each month in 2023, adjusting the job_posted_date
 to be 'American/New York time zone before extracting the month. Asume the job_posted_date is stored in UTC. Group by and order by the month' */

SELECT 
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(job_id) AS count_of_jobs          
FROM 
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'GMT-4') = 2023
GROUP BY
    month
ORDER BY
    month;

/*3. Write a query to find companies (including company names) that have posted jobs offering health insurance,
where these postings were made in the secon quarter of 2023. Use data extraction to filter by quarter*/

SELECT
    companies.name,
    job_postings.job_health_insurance,
    job_postings.job_posted_date
FROM
    job_postings_fact AS job_postings
    LEFT JOIN company_dim AS companies ON job_postings.company_id = companies.company_id
WHERE 
    job_postings.job_health_insurance = TRUE AND
    EXTRACT(MONTH FROM job_postings.job_posted_date) BETWEEN 4 AND 6
ORDER BY
    job_postings.job_posted_date;

