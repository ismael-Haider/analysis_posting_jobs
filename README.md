# 📊 Data Analyst Job Market Analysis

## Introduction
📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](project_sql)

## Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining the search for optimal jobs.

Data hails from my SQL Course. It's packed with insights on job titles, salaries, locations, and essential skills.

**The questions I wanted to answer through my SQL queries:**
* What are the top-paying data analyst jobs?
* What skills are required for these top-paying jobs?
* What skills are most in demand for data analysts?
* Which skills are associated with higher salaries?
* What are the most optimal skills to learn?

## Tools I Used
* **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
* **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
* **Visual Studio Code:** My go-to for database management and executing SQL queries.
* **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis.

## The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high-paying opportunities in the field.

```sql
SELECT	
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

#### Key Findings:
* **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
* **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
* **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        job_posted_date,
        name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short ='Data Analyst' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL 
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10 
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY    
    salary_year_avg DESC;
```

#### Key Findings:
* **SQL** is leading the pack with **8** occurrences across the top 10 jobs.
* **Python** follows closely, being requested **7** times.
* **Tableau** is also highly sought after with **6** occurrences, alongside tools like R, Snowflake, Pandas, and Excel.

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high market demand.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short='Data Analyst' AND 
    job_work_from_home = True
GROUP BY
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;
```

#### Key Findings:
* **Core Foundations:** SQL and Excel remain fundamental, emphasizing the ongoing need for strong data processing and spreadsheet skills.
* **Tech Ecosystem:** Advanced languages and visualization tools like Python, Tableau, and Power BI are essential for modern data storytelling.

| Skills | Demand Count |
| :--- | :--- |
| SQL | 7,291 |
| Excel | 4,611 |
| Python | 4,330 |
| Tableau | 3,745 |
| Power BI | 2,609 |

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which technical competencies command the highest premiums.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short='Data Analyst'  
    AND salary_year_avg IS NOT NULL 
GROUP BY
    skills
ORDER BY 
    avg_salary DESC
LIMIT 10;
```

#### Key Findings:
* **Big Data & ML Dominance:** Top salaries are commanded by analysts skilled in big data (PySpark, Couchbase) and machine learning tools (DataRobot).
* **DevOps Crossover:** Engineering tools like GitLab and engineering frameworks hint that a blend of development and analysis yields higher pay.

| Skills | Average Salary ($) |
| :--- | :--- |
| PySpark | 208,172 |
| Bitbucket | 189,155 |
| Couchbase | 160,515 |
| Watson | 160,515 |
| DataRobot | 155,486 |
| GitLab | 154,500 |
| Swift | 153,750 |
| Jupyter | 152,777 |
| Pandas | 151,821 |
| Elasticsearch | 145,000 |

### 5. Most Optimal Skills to Learn
By combining demand and salary data, this query targets "high-value" skills—those that are relatively high in demand but also offer premium average salaries.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 10;
```

#### Key Findings:
* **Cloud Infrastructure:** Skills like Snowflake, Azure, and AWS represent a sweet spot—frequently requested and yielding average salaries over $108,000.
* **Big Data & Collaboration:** Platforms like Hadoop and tools like Confluence/Jira show up as vital infrastructure skills for optimal roles.

| Skill ID | Skills | Demand Count | Average Salary ($) |
| :--- | :--- | :--- | :--- |
| 8 | Go | 27 | 115,320 |
| 234 | Confluence | 11 | 114,210 |
| 97 | Hadoop | 22 | 113,193 |
| 80 | Snowflake | 37 | 112,948 |
| 74 | Azure | 34 | 111,225 |
| 77 | BigQuery | 13 | 109,654 |
| 76 | AWS | 32 | 108,317 |
| 4 | Java | 17 | 106,906 |
| 194 | SSIS | 12 | 106,683 |
| 233 | Jira | 20 | 104,918 |

## What I Learned
* 🧩 **Complex Query Crafting:** Mastered advanced SQL techniques, utilizing CTEs, window functions, and complex multi-table joins.
* 📊 **Data Aggregation:** Successfully merged tables using `GROUP BY`, `COUNT()`, and `AVG()` to reveal clear market trends.
* 💡 **Analytical Synthesis:** Learned how to transform ambiguous market questions into precise, actionable database queries.

## Conclusions
* **Top-Paying Opportunities:** Remote roles offer impressive compensation caps, hitting up to $650,000 for elite analyst positions.
* **The Non-Negotiable Core:** SQL remains the absolute foundation of the field, boasting the highest overall volume of job postings.
* **Specialization Drives Revenue:** While core skills offer volume, niche competencies in Big Data frameworks (PySpark) and Cloud Ecosystems (Snowflake, AWS) offer the fastest path to maximizing income.
