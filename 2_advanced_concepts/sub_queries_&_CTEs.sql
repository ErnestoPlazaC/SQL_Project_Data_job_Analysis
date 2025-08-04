SELECT *
FROM ( -- SubQueary starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;
-- SubQuery ends here

WITH january_jobs AS ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) -- CTE  definition ends here

SELECT *
FROM january_jobs;



SELECT 
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE 
    company_id IN (
        SELECT 
            company_id
        FROM 
            job_postings_fact
        WHERE 
            job_no_degree_mention = TRUE
        ORDER BY
            company_id
    );


/*
Find the companies that have the most job openings.
- Get the total number of job postings per company id (job_posting_facts)
- Return the total number of jobs with the company name (company_dim)
*/

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
    LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    company_job_count.total_jobs DESC;



--PRACTICE PROBLEMS
/*
1. Identify the top 5 skills that are most frequently mentioned in job postings. Use a subquery to find the 
skills id with the highest number of job counts in the skills_job_dim table and the join this result with the
skills_dim table to get the skill names.
*/

-- Con SubQuery

SELECT
    skills_dim.skills,
    top_skills.job_posting_count
    
FROM(
    SELECT 
        skill_id, 
        COUNT(DISTINCT job_id) AS job_posting_count
    FROM 
        skills_job_dim
    GROUP BY 
        skill_id
    ) AS top_skills
    
    LEFT JOIN skills_dim ON top_skills.skill_id = skills_dim.skill_id
ORDER BY
    top_skills.job_posting_count DESC
LIMIT
    5
;


-- Con CTE
WITH skill_id_count AS (
    SELECT 
        skill_id,
        COUNT(*) AS total_jobs
    FROM 
        skills_job_dim
    GROUP BY
        skill_id
)

SELECT
    skills_dim.skills,
    skill_id_count.total_jobs
FROM 
    skills_dim
    LEFT JOIN skill_id_count ON skill_id_count.skill_id = skills_dim.skill_id
ORDER BY
    skill_id_count.total_jobs DESC
LIMIT
    5;


/*
2. Determine the size category ('Small','Medium', or 'Large') for each company by first identifying
the number of job postings they have. Use a subquery to calculate the total job postings per company.
A company is considered 'Small' if it has less than 10 postings, 'Medium' if the number of job postings 
is between 10 and 50, and 'Large' if it has more than 50 postings. Implement a subquery to aggregate job counts 
per company before classifying them based on size.*/


-- Con SubQuery

SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs,
    CASE 
    WHEN company_job_count.total_jobs < 10 THEN 'Small'
    WHEN company_job_count.total_jobs BETWEEN 10 AND 50 THEN 'Medium'
    WHEN company_job_count.total_jobs > 50 THEN 'Large'
    END AS job_count_bucket
FROM (
    SELECT
        company_id,
        COUNT(company_id) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY
        company_id
    ) AS company_job_count

    LEFT JOIN company_dim ON company_job_count.company_id = company_dim.company_id

-- Con CTE

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs,
    CASE 
    WHEN company_job_count.total_jobs < 10 THEN 'Small'
    WHEN company_job_count.total_jobs BETWEEN 10 AND 50 THEN 'Medium'
    WHEN company_job_count.total_jobs > 50 THEN 'Large'
    END AS job_count_bucket
FROM 
    company_dim
    LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
    ;

/*
3. Find the count of the number of remote job postings per skill
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