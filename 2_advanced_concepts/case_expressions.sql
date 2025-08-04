SELECT 
    job_title_short,
    job_location,
    CASE
    WHEN job_location = 'Anywhere' THEN 'Remote'
    WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
LIMIT 100000;


SELECT 
    COUNT(job_id) AS count_of_jobs,
    CASE
    WHEN job_location = 'Anywhere' THEN 'Remote'
    WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst' AND
    job_country = 'United States'
GROUP BY 
    location_category
LIMIT 100000;

/*PRACTICE PROBLEM
I want to categorize the salaries of each job posting. To see if it fits in my desired salary range
    *Put salary into diferent buckets
    *Define whats a high, standard, or low salary with our own expectations
    *Why? It is easy to determine which job postings are worth looking at based on salary
    *I only want to look at 'Data Analyst' jobs
    *Order from highest to lowest*/

/*SALARY BUCKET
HIGH >= 100K
STANDARD  50K <= X < 100K
LOW <=50K*/

SELECT
    job_title_short,
    job_title,
    job_location,
    salary_year_avg,
    CASE
    WHEN salary_year_avg > 100000 THEN 'High Salary'
    WHEN salary_year_avg BETWEEN 60000 AND 100000 THEN 'Standard Salary'
    WHEN salary_year_avg <= 60000 THEN 'Low Salary'
    ELSE 'No Data'
    END AS salary_bucket,
    CASE
    WHEN job_health_insurance = TRUE THEN 'Has Health Insurance'
    WHEN job_health_insurance = FALSE THEN 'No Health Insurance'
    ELSE 'No Data'
    END AS health_insurance_coverage,
    CASE
    WHEN job_no_degree_mention = TRUE THEN 'Does Not Need Degree'
    WHEN job_no_degree_mention = FALSE THEN 'Needs Degree'
    ELSE 'No Data'
    END AS degree_demands

FROM
    job_postings_fact

WHERE
    job_title_short = 'Data Analyst'

ORDER BY
    salary_year_avg;

-- Experimenting with CASE WHEN:

SELECT
    postings.job_title_short,
    postings.job_title,
    companies.name,
    postings.job_location,
    skills.skills,
    postings.salary_year_avg,
    CASE
    WHEN salary_year_avg > 100000 THEN 'High Salary'
    WHEN salary_year_avg BETWEEN 60000 AND 100000 THEN 'Standard Salary'
    WHEN salary_year_avg <= 60000 THEN 'Low Salary'
    ELSE 'No Data'
    END AS salary_bucket,
    CASE
    WHEN job_health_insurance = TRUE THEN 'Has Health Insurance'
    WHEN job_health_insurance = FALSE THEN 'No Health Insurance'
    ELSE 'No Data'
    END AS health_insurance_coverage,
    CASE
    WHEN job_no_degree_mention = TRUE THEN 'Does Not Need Degree'
    WHEN job_no_degree_mention = FALSE THEN 'Needs Degree'
    ELSE 'No Data'
    END AS degree_demands

FROM
    job_postings_fact AS postings
    LEFT JOIN skills_job_dim AS skills_to_job ON postings.job_id = skills_to_job.job_id
    LEFT JOIN skills_dim AS skills ON skills.skill_id = skills_to_job.skill_id
    LEFT JOIN company_dim AS companies ON postings.company_id = companies.company_id
WHERE
    job_title_short = 'Data Analyst'

ORDER BY
    salary_year_avg
LIMIT 10000;