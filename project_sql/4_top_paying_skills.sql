/*
Question: What are the top skills based on salary?
    - Look at the average salary associated with each skill for Data Analyst positions
    - Focus on roles with specified salaries, regardless of location
    -Why? It reveals how different skills impact salary levels for Data Analysts and
        helps identify the most financyally rewarding skills to acquire or improve 
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim AS skills_to_job ON job_postings_fact.job_id = skills_to_job.job_id
    INNER JOIN skills_dim AS skills ON skills_to_job.skill_id = skills.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;