/*
Find the count of the number of remote job postings per skill
    - Display the top 5 skills by their demand in remote jobs
    - Include skill ID, name, and count of postings requiring the skill
*/

WITH remote_job_skills AS (
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
        INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = TRUE AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM
    remote_job_skills
    INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT
    5;

/*
Question: What are the most in-demand skills for Data Analysts
    - Join job postings to inner join table similar ti query 2
    - Identify the top 5 in-demand skills for a data analyst
    - Focus on all job postings
    - Why? Retrieves the top 5 skills with the highest demand in the job market,
        providing insights into the most valuable skills for job seekers.
*/

SELECT 
    skills,
    COUNT(skills_to_job.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim AS skills_to_job ON job_postings_fact.job_id = skills_to_job.job_id
INNER JOIN skills_dim AS skills ON skills_to_job.skill_id = skills.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_country = 'Ecuador'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5