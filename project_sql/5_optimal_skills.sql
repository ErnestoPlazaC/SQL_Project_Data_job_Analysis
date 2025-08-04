/*
Question: What are the most optimal skills to learn (aka it's in high demand and a high paying skill)?
    - Identify skills in high demand and associated with high average salaries for Data Analyst roles 
    - Concentrate on remote positions with specified salaries
    - Why? Targeta skills that offer job security (High Demand) and financial benefits (high salaries),
        offering strategic insights for career development  in data analisys 
*/

WITH skills_demand AS(
    SELECT 
        skills.skill_id,
        skills.skills,
        COUNT(skills_to_job.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim AS skills_to_job ON job_postings_fact.job_id = skills_to_job.job_id
    INNER JOIN skills_dim AS skills ON skills_to_job.skill_id = skills.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills.skill_id
), average_salary AS (
    SELECT 
        skills.skill_id,
        skills.skills,
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
        skills.skill_id
)
SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
    INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

-- rewriting the same query more concisely 

SELECT 
    skills.skill_id,
    skills.skills,
    COUNT(skills_to_job.skill_id) AS demand_count,
    AVG(job_postings_fact.salary_year_avg) AS avg_salary
FROM
    job_postings_fact
    INNER JOIN skills_job_dim AS skills_to_job ON job_postings_fact.job_id = skills_to_job.job_id
    INNER JOIN skills_dim AS skills ON skills_to_job.skill_id = skills.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills.skill_id
HAVING
    COUNT(skills_to_job.skill_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;


