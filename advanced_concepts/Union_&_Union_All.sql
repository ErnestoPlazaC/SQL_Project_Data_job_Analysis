-- PRACTICE PROBLEMS
/*
- Get the corresponding skill and skill type for each job posting in q1
- Include those without any skills too
- Why? Look at the skills and the type for each job in the first quarter that has a salary
*/ 

SELECT
    q1_job_postings.job_title_short,
    q1_job_postings.job_location,
    q1_job_postings.job_via,
    q1_job_postings.job_posted_date::DATE
FROM (
    SELECT * 
    FROM january_jobs
    UNION ALL
    SELECT * 
    FROM february_jobs
    UNION ALL
    SELECT * 
    FROM march_jobs
) q1_job_postings
WHERE
q1_job_postings.salary_year_avg > 70000
;

/*
- Get the corresponding skill and skill type for each job posting in Q1
- Include those without any skill too
- Look at the skill and skill type of each job corresponding to Q1 that has a salary > 70k
*/

SELECT
    q1_job_postings.job_title_short AS job_title,
    skills.skills AS skill_name,
    skills.type AS skill_type,
    q1_job_postings.salary_year_avg,
    q1_job_postings.job_posted_date::DATE
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS q1_job_postings

    LEFT JOIN skills_job_dim AS skills_to_job ON q1_job_postings.job_id = skills_to_job.job_id
    LEFT JOIN skills_dim AS skills ON skills_to_job.skill_id = skills.skill_id

WHERE
    q1_job_postings.salary_year_avg > 70000
LIMIT
 100000;