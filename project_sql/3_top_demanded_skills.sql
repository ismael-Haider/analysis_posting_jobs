/*
qustion: what are the most in-demand skills for data analysts ?
join job postings to inner join table similar to query 2.
indentify the top 5 in-demand skills for data analysts.
focus on all job postings.
why ? retrieves the top 5 skills with the highest demand in the job market,
    providing insights into the most valuable skills for job seekers.
*/


select skills , 
    COUNT(skills_job_dim.job_id) as demand_count 
    from job_postings_fact 
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where job_postings_fact.job_title_short like 'Data Analyst'
    group by skills_dim.skill_id
    order by demand_count desc
    limit 5;


/*
The top 5 skills by demand count are:

SQL with 92,628 job postings

Excel with 67,031 job postings

Python with 57,326 job postings

Tableau with 46,554 job postings

Power BI with 39,468 job postings


CAREER STRATEGY BASED ON SKILL DEMAND DATA

Entry Level Career Stage:
Recommended Skills: SQL plus Excel plus Tableau
Rationale: This combination covers over 85 percent of job requirements for data analyst positions.
These are the foundational tools that most companies expect entry-level candidates to know.

Mid Level Career Stage:
Recommended Skills: SQL plus Python plus either Power BI or Tableau
Rationale: This adds automation capabilities and advanced analytics to your skillset.
Python allows you to handle larger datasets, perform complex analysis, and automate repetitive tasks, which is expected at the mid level.

Senior Level Career Stage:
Recommended Skills: All five skills plus a specialization area
Rationale: Having mastery of all top skills provides maximum versatility 
and salary potential. Adding a specialization such as machine learning, data engineering, or industry-specific domain knowledge makes you highly valuable and distinguishes you from other senior analysts

*/