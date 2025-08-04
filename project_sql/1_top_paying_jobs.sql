/*
Question: What are the top-paying data analyst jobs?
    - Identify the top 10 highest-paying Data Analyst roles that are available remotely.
    - Focus on job postings with specified salaries (remove nulls)
    - Why? Highlight the top-paying opportunities for Data Analysts, offering insights into   
*/

SELECT
    job_postings.job_id,
    job_postings.job_title,
    companies.name AS company_name,
    job_postings.job_country,
    job_postings.job_location,
    job_postings.job_schedule_type,
    job_postings.salary_year_avg,
    job_postings.job_posted_date::DATE
FROM
    job_postings_fact AS job_postings
LEFT JOIN company_dim AS companies ON job_postings.company_id = companies.company_id

WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL

ORDER BY
    salary_year_avg DESC

LIMIT 
    10;

