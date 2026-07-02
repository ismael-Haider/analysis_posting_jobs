/*
 Question: What are the top-paying data analyst jobs 
 - Identify the top 10 highest-paying Data Analyst roles that are available remotely.
 - Focuses on job postings that are specified salaries (remove nulls).
 - why? Highlight the top-pating opportunities for Data Analysts, offering insights
 */

-- update job_postings_fact
-- set job_location = 'Remote'
-- where job_location = 'Anywhere';
-- select *
-- from company_dim
-- limit 5;
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
limit 10;

