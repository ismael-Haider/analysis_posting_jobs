--     select count(job_id),
--             case 
--                 when job_location = 'Anywhere' then 'remote'
--                 when job_location = 'New York, NY' then 'localy'
--                 else 'other'
--                 end
--                 as job_category
--             from job_postings_fact 
--             group by job_category;
-- with job_jun as (SELECT * 
--                 from job_postings_fact 
--                 where EXTRACT(month from job_posted_date) = 6
--                 )
-- select * from job_jun;
select *
from job_postings_fact;
-- select company_id,
--         name
--         from company_dim 
-- where company_id in (
-- select DISTINCT company_id 
-- from job_postings_fact 
-- where job_no_degree_mention = true
-- ORDER BY company_id
-- )
-- select *
-- from job_postings_fact
-- where salary_year_avg is not null
-- limit 5;
-- select job_title,salary_year_avg,
--         case
--                 WHEN salary_year_avg < 50000 THEN 'low'
--                 WHEN salary_year_avg BETWEEN 50000 AND 100000 THEN 'medium'
--                 WHEN salary_year_avg > 100000 THEN 'high'
--                 ELSE 'unknown'
--         END as salary_category
-- from job_postings_fact
-- where job_title_short like '%Data%' and salary_year_avg is not null
-- order by salary_year_avg DESC ;
-- select e1.company_id,
--         count(e1.job_id),
--         e2.name
-- from job_postings_fact e1
--         join company_dim e2 on(e1.company_id = e2.company_id)
-- group by e1.company_id,
--         e2.name
-- order by count(e1.job_id) desc;
-- with company_job_count as (
--         SELECT company_id,
--                 count(*) as num_of_job
--         from job_postings_fact
--         group by company_id
-- )
-- select e1.name , e2.company_id, e2.num_of_job
-- from company_dim e1
--         join company_job_count e2 on e1.company_id = e2.company_id
--         where e2.num_of_job > 100
select job_id,
        count(job_id)
from skills_job_dim
group by job_id
order by 2 desc
limit 5;
select skills,
        skill_count.skill_id,
        skill_count.job
from skills_dim
        left join skill_count on skills_dim.skill_id = skill_count.skill_id;
/*
 identify the top 5 skells that are most frequently mentioned in job postings. Use a subquery to find the skill IDs 
 with the highest counts in the skills_job_dim table and then join this result with the skills_dim table to get the skill names.
 */
-- with skill_count as (
-- select skill_id,count(job_id) as num_of_job from skills_job_dim
-- group by skill_id
-- order by 2 desc
-- limit 5
-- )
-- select skills_dim.skills,
-- skill_count.skill_id,
-- skill_count.num_of_job 
-- from skills_dim
-- right join skill_count on skills_dim.skill_id = skill_count.skill_id;
/*
 Determine the size category (smaell,medium,or large) for each company by first identifying 
 the number of job postings they have. Use a subquery to calculate the total job postings per
 company. a company is considered small if has less than 10 job ,medium if the number of job is 
 between 10 and 50 and large if has more than 50 job 
 implement a subquerey to aggregate job counts per company before classifying them basekd on 
 size 
 
 */
-- alter table company_dim add column company_size varchar(10);
with company_job_count as (
        select company_id,
                count(company_id) as num_of_job
        from job_postings_fact
        group by company_id
        order by num_of_job
)
update company_dim
set company_size = (
                select case
                                when num_of_job < 10 then 'small'
                                when num_of_job between 10 and 50 then 'medium'
                                when num_of_job > 50 then 'large'
                                else 'unknown'
                        end as company_size
                from company_job_count
                where company_dim.company_id = company_job_count.company_id
        );
select company_size
from company_dim;

/*
 Find the count of the number of remote job postings per skill
 -Display the top 5 skills by thier demand in remote jobs
 -Incluse skill id , name, and count of postings requiring the skill 
 */

-- with count_remote_job_perSkill as (
-- select skill_to_job.skill_id,
--         count(*) num_of_job_remoT
-- from skills_job_dim skill_to_job
--         join job_postings_fact job on skill_to_job.job_id = job.job_id
--         where job_work_from_home = TRUE And 
--         job.job_title_short like 'Data Analyst'
--         group by skill_to_job.skill_id
-- )

-- select * from count_remote_job_perSkill
--         join skills_dim skill on count_remote_job_perSkill.skill_id = skill.skill_id
--         order by count_remote_job_perSkill.num_of_job_remoT desc
--         limit 5;



select job_id ,
        company_id,
        job_title 
from january_jobs 

UNION all

select job_id ,
        company_id,
        job_title 
from february_jobs

union all 

select job_id ,
        company_id,
        job_title 
from march_jobs;


/*
        Find job postings from the first quarter that have a salary grater than $70k
        - Combine job posting table from the first quarter of 2023 
        - Gets job postings with an average salary greater than $70k
*/

        with quarter1 as (
                select * from january_jobs
                
                union all 

                select * from february_jobs

                union all 

                select * from march_jobs
        )

        select job_title_short,
        job_location,
        job_via,
        job_posted_date::date,
        concat(floor(salary_year_avg),'$') as salary_year_avg
        from quarter1
        where salary_year_avg > 70000;
