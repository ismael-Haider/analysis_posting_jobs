/*
qustion : what are the most optimal skills to learn (based on demand and salary) for data analysts ?
- INDENTIFY SKILLS IN HIGH DEMAND AND ASSOCIATED WITH HIGH AVERAGE SALARIES FOR DATA ANALYST ROLES 
- concetrates on remote postions with specified salaries
why ? targets skills that offer job security (high demand) and financial benefits (high salaries),
offering strategic insights for career development in data analysis.
*/

with most_demand as (select skills , 
    COUNT(skills_job_dim.job_id) as demand_count 
    from job_postings_fact 
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where job_postings_fact.job_title_short = 'Data Analyst'
    and job_work_from_home = TRUE
    and salary_year_avg is not null
    group by skills_dim.skill_id
), most_paying_jobs as (
    select skills_dim.skills,
    floor(avg(salary_year_avg)) as avg_salary
    from
        job_postings_fact
    inner join skills_job_dim 
        on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim 
        on skills_job_dim.skill_id = skills_dim.skill_id
    where job_postings_fact.job_title_short = 'Data Analyst'
        and job_work_from_home = TRUE
        and job_postings_fact.salary_year_avg is not null
    group by skills_dim.skill_id
)

-- select * from most_demand
-- join most_paying_jobs using (skills)
-- where demand_count > 10
-- order by avg_salary desc, demand_count desc
-- ;

-- rewriting this same query more concisely

select 
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count,
    round(avg(job_postings_fact.salary_year_avg)) as avg_salary
from job_postings_fact 
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where job_postings_fact.job_title_short = 'Data Analyst'
    and job_work_from_home = TRUE
    and job_postings_fact.salary_year_avg is not null
group by 
    skills_dim.skill_id
HAVING count(skills_job_dim.job_id) > 10
order by 
    avg_salary desc , 
    demand_count DESC
limit 25;