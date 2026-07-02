/*
qustion : what are the top skills based on salary?
- look at the average salary associated with each skill for Data Analyst positions
- foucuses on roles with specified salaries , regardless of location 
- why ? it reveals how different skills impact salary levels for data analysts and 
helps identify the most financially rewarding skills to acquire or improve 
*/

        select skills_dim.skills,
        floor(avg(salary_year_avg)) as avg_salary
        -- avg(job_postings_fact.salary_year_avg) as average_salary
from
    job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where job_postings_fact.job_title_short = 'Data Analyst'
    and job_postings_fact.salary_year_avg is not null
    group by skills
    order by avg_salary desc
    limit 25;


    /*
    TOP SKILLS BASED ON SALARY - KEY INSIGHTS

The highest paying skill is SVN with an average salary of 400,000 dollars. This is unusually high and may represent a specialized niche role rather than a typical data analyst position.

Solidity ranks second with 179,000 dollars, reflecting the premium for blockchain and smart contract skills even in data analyst roles.

Couchbase at 160,515 dollars and DataRobot at 155,485 dollars show that database expertise and automated machine learning platforms command strong salaries.

Golang at 155,000 dollars and MXNet at 149,000 dollars indicate that programming languages and deep learning frameworks are highly valued.

Several machine learning and AI tools appear in the top 25 including Keras at 127,013 dollars, PyTorch at 125,226 dollars, TensorFlow at 120,646 dollars, and Hugging Face at 123,950 dollars. This confirms that AI and deep learning skills significantly boost earning potential.

DevOps and cloud infrastructure tools are well represented with Terraform at 146,733 dollars, Ansible at 124,370 dollars, Puppet at 129,820 dollars, and Kafka at 129,999 dollars. This suggests data analysts who understand infrastructure and data pipelines earn more.

Database technologies like Cassandra at 118,406 dollars and Couchbase show that specialized database knowledge is financially rewarding.

Collaboration and project management tools like Notion at 118,091 dollars, Atlassian at 117,965 dollars, and Bitbucket at 116,711 dollars appear in the list, indicating that workflow and team coordination skills matter for higher salaries.

R's dplyr package at 147,633 dollars demonstrates that R programming skills can still command high salaries despite not being in the top demand list.

The key takeaway is that specialized and emerging technologies pay significantly more than generalist skills. While SQL and Excel are most in demand, they do not appear in the top-paying list. This means the skills that get you hired are different from the skills that get you paid the most.

The highest salaries go to professionals who combine data analysis with other domains like blockchain, machine learning, DevOps, or specialized databases. To maximize salary, you should learn a niche skill on top of your core data analyst foundation.

Another important insight is that programming skills dominate the high-salary list with Go, Scala, and Perl appearing alongside Python-based frameworks. This shows that strong coding ability translates directly to higher pay.

The salary range for the top 25 skills is between 115,000 and 400,000 dollars, with most skills clustering between 115,000 and 160,000 dollars. This wide range indicates that specialization can dramatically increase your earning potential.
    
    */