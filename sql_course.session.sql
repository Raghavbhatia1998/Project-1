--create Table january_jobs as 





select 
count(Job_id) as number_of_jobs,
case when job_location='Anywhere' Then 'Remote'
when job_location='New York,Ny' Then 'Local'
else
'onsite'
end as location_category
from job_postings_fact
where job_title_short= 'Data Analyst'
group by location_category;
