# Introduction
 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.
 I specifically focused on data analyst jobs present in my country-**India**.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

 I used a publicly available SQL dataset by **Luke Barousse**, which contains job postings for data analysts — including salaries, locations, job titles, and required skills. 

The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs/Roles

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

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
    job_location = 'India' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

Here's a breakdown of the top Data Analyst jobs in 2023 in India :

- **Seniority Drives Salary** :
Roles with titles like "Senior", "Enterprise", or "Architect" offer 30–40% higher average salaries compared to junior positions, highlighting the value of experience and strategic skill sets.

- **Cross-Industry Demand** :
High-paying data roles appear across diverse sectors—finance (Deutsche Bank), healthcare (Clarivate), and biotech (Merck)—showing that data analytics is in demand beyond traditional tech companies.

- **Salary Range and Averages** :
The average salary across roles is $91,553 USD, with a range from $64,800 to $119,250 USD, indicating strong opportunities for both beginners and advanced professionals in India’s data job market.

![Top Paying Jobs](Assets\top_paying_jobs.png)



*Bar graph visualizing the salary for the top 10 salaries for data analysts in India; ChatGPT generated this graph from my SQL query results.

### 2. Top Paying Skills 

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' and job_country= 'India'
    AND salary_year_avg IS NOT NULL
    
GROUP BY
    skills
ORDER BY
    avg_salary DESC 
LIMIT 10;
```

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023 in India

- **Premium Skills** : Skills like PostgreSQL, GitLab, PySpark, MySQL, and Linux all command an average salary of $165,000, indicating high demand and relevance across backend development, version control, and data engineering.

- **Specialized Tools at Slightly Lower Range**:
Technologies such as Neo4j (graph DB) and GDPR (compliance) show slightly lower average salaries (~$163,782), likely due to their niche use cases or regional specificity.

- **Mid-Range Tools**:
Tools like Airflow, MongoDB, and Databricks offer salaries in the range of $135k–$138k, potentially reflecting broader adoption but also more competition in these roles.

| Skill       | Average Salary ($) |
|-------------|--------------------|
| postgresql  | 165,000            |
| gitlab      | 165,000            |
| pyspark     | 165,000            |
| mysql       | 165,000            |
| linux       | 165,000            |
| neo4j       | 163,782            |
| gdpr        | 163,782            |
| airflow     | 138,088            |
| mongodb     | 135,994            |
| databricks  | 135,994            |


### 3. Top Demanded Skills 

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT skills,
Count(skills_job_dim.job_id) as demand_count
from job_postings_fact

INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
where job_title_short='Data Analyst' and job_country='India'
group by skills
ORDER BY demand_count DESC
limit 10;
```

Here's the breakdown of the most demanded skills for data analysts in 2023:

Data Skill Demand Analysis (2025)
- **SQL Leads the Pack** :
SQL dominates the market with over 3,100 job listings, reinforcing its position as a foundational skill in data analysis, data engineering, and business intelligence roles.

- **Python & Excel Core Analytical Tools** : 
Python and Excel closely follow with 2,200+ job counts each.
Python is valued for its scalability and integration with data pipelines, while Excel remains a go-to tool for business users due to its accessibility and flexibility.

- **Visualization & Statistical Tools Holding Strong** :
Tableau and Power BI show solid demand among BI and visualization tools, highlighting the need for clear data storytelling.
Meanwhile, R and SAS continue to be relevant in statistics-heavy domains such as healthcare, academia, and research-oriented analytics.

![TOP Demanded Skills](Assets\TOP_DEMANED_SKILLS.png)



### 4. Top Optimal Skills
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

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
    and job_country='India'

GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```



Skill Demand vs Average Salary

| Skill     | Demand Count | Avg Salary (USD) |
|-----------|---------------|------------------|
| SQL       | 46            | 92,984           |
| Excel     | 39            | 88,519           |
| Python    | 36            | 95,933           |
| Tableau   | 20            | 95,103           |
| R         | 18            | 86,609           |
| Power BI  | 17            | 109,832          |
| Azure     | 15            | 98,570           |
| AWS       | 12            | 95,333           |
| Spark     | 11            | 118,332          |
| Oracle    | 11            | 104,260          |


 Here's a breakdown of the most optimal skills for Data Analysts in 2023:
 - **SQL & Excel are Essential, But Not High-Paying** :
Highest demand (SQL: 46, Excel: 39) but below-average salaries → they're baseline, must-have skills.

- **Python Balances Demand and Salary** :
Strong demand (36) and solid pay (₹95,933) make it a core skill for modern data analysts.

- **Spark & Power BI Offer High Salaries for Niche Roles** :
Spark leads in pay (₹1,18,332), Power BI follows (₹1,09,832) — both indicate high-value, specialized skills.


### 5. Top Job Paying Skills
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
with top_paying_jobs as (
    SELECT	
	job_id,
	job_title,
	salary_year_avg,

    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'India' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)
select *,skills from top_paying_jobs 
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023 for India country:

- **Core Skills in Demand** : SQL (9) and Excel (8) top the list, showing that data manipulation and reporting remain critical across roles.Python (6) and R (3) indicate a strong preference for programming and statistical analysis skills in data-centric jobs.

- **Tool Versatility is Valued** : A wide spread of Analyst Tools like Tableau, Power BI, Sheets, Word, and PowerPoint shows employers value tool fluency beyond coding — essential for communication, visualization, and reporting.

- **Emerging & Support Skills Appear Too** : Even with lower frequency, tools like TensorFlow, PyTorch, Azure, and Jira reflect demand for machine learning, cloud, and agile collaboration skills, especially for hybrid analyst-engineer roles.


| Skill       | Frequency | Type          |
|-------------|-----------|---------------|
| SQL         | 9         | Programming   |
| Excel       | 8         | Analyst Tools |
| Python      | 6         | Programming   |
| R           | 3         | Programming   |
| Word        | 3         | Analyst Tools |
| Tableau     | 2         | Analyst Tools |
| Flow        | 2         | Other         |
| Power BI    | 1         | Analyst Tools |
| Sheets      | 1         | Analyst Tools |
| PowerPoint  | 1         | Analyst Tools |
| Outlook     | 1         | Analyst Tools |
| Azure       | 1         | Cloud         |
| Oracle      | 1         | Cloud         |
| Jira        | 1         | Async         |
| Confluence  | 1         | Async         |
| TensorFlow  | 1         | Libraries     |
| PyTorch     | 1         | Libraries     |
| Windows     | 1         | OS            |
| Unix        | 1         | OS            |
| Visio       | 1         | Analyst Tools |


# What I learned 

- **Query Building Basics** : Kickstarted my ability to slice and dice data with `SELECT`, `WHERE`, `ORDER BY` and simple `JOIN`s—transforming raw tables into precise, actionable result sets.

- **Grouping & Aggregation Mastery** : Turbocharged my summaries by wielding `GROUP BY`, `COUNT()`, `SUM()`, `AVG()` and `HAVING` to distill massive datasets into clear, decision-ready metrics.

- **Analytical Wizardry** : Leveled up my real-world puzzle-solving skills, turning complex business questions into concise, insightful SQL queries.

# Conclusions

### Insights

* **Experience Drives Premium Compensation:** Senior and architect roles command 30–40% higher salaries (up to \$119K) versus junior analyst positions (\~\$65K), highlighting the direct ROI of advanced domain expertise and leadership responsibilities.
* **Core Skills Are Baseline, Niche Skills Differentiate:** SQL and Excel top demand charts (46 and 39 listings) but yield average pay of \$93K and \$88K, whereas specialized tools like Spark (\$118K) and Power BI (\$110K) unlock significantly higher earning potential.
* **Balanced Demand–Salary Sweet Spot:** Python strikes the optimal balance with 36 listings and an average salary of \$96K, making it a strategic “must-learn” for both strong employability and competitive compensation.
* **Cross-Industry Analytics Opportunities:** Top-paying data analyst roles span finance (Deutsche Bank), healthcare (Clarivate), and biotech (Merck), demonstrating that advanced analytics skills are universally valued beyond pure-tech sectors.
* **Emerging Cloud & ML Premiums:** Though less frequent, cloud platforms (Azure, AWS) and ML libraries (TensorFlow, PyTorch) appear among the top-paid skills, signaling growing market demand for analysts who can integrate analytics with scalable cloud and AI workflows.





 











