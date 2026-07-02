/*
Qusetion : what skills are required for the top paying jobs for Data Analysts?
-use the top 10 highest paying Data Analyst jobs that are available remotely
-add specific skills required for these roles 
-why ? it provides a detailed look at wich high-paying jobs demand certain skills 
    hwlping job seekers understand wich skills are most valuable in the current job market for Data Analysts
*/

with top_paying_jobs as (
select job_postings_fact.job_id,
    job_postings_fact.job_title,
    job_postings_fact.job_location,
    job_postings_fact.job_schedule_type,
    job_postings_fact.salary_year_avg,
    job_posted_date::date,
    company.name as company_name
from job_postings_fact
    left join company_dim company on job_postings_fact.company_id = company.company_id
where salary_year_avg is not null
    and job_postings_fact.job_title_short like 'Data Analyst'
    and job_postings_fact.job_location = 'Remote'
order by salary_year_avg desc
limit 10
)
select top_paying_jobs.job_id, 
        skills_job_dim.skill_id,
        skills_dim.skills
from top_paying_jobs 
inner join skills_job_dim 
    on top_paying_jobs.job_id = skills_job_dim.job_id
inner join skills_dim
    on skills_job_dim.skill_id = skills_dim.skill_id;

/*
i use inner join because each job has skills and i need to show skills but if the job don't have skills
it will not be shown in the result and i want to show only jobs with skills


SQL	9 
Python	8 
Tableau	6 
R	4 
Excel	3 
Snowflake	3 
Pandas	3 

*/