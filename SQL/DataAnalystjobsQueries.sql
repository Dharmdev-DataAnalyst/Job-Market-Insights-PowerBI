create database jobsIndia

use  jobsIndia

select * from DataAnalystJobsIndia
--sp_help DataAnalystJobsIndia
---->
select Top 5 company,avg(rating) as average_Job_rating from DataAnalystJobsIndia group by company order by 
avg(rating) desc

---->
with average_sal_location as
(
select location,avg(base_salary) as average_base_salary,avg(max_salary) as average_max_salary from DataAnalystJobsIndia group by location
)
select location,average_base_salary,average_max_salary from average_sal_location where average_base_salary>1100000 order by average_base_salary desc

---->
create or alter procedure proc_experience
as begin
update DataAnalystJobsIndia set
[min_exp]=case
			when CHARINDEX('-',experience)>0
			then cast(left(experience,charindex('-',experience)-1) as int)
			else cast(left(experience,PATINDEX('%[^0-9]%',experience)-1)as int)
		  end,
[max_exp]=case
			when CHARINDEX('-',experience)>0
			then cast(
						SUBSTRING(experience,CHARINDEX('-',experience)+1,
						PATINDEX('%[^0-9]%',SUBSTRING(experience,CHARINDEX('-',experience)+1,LEN(experience)))-1)as int)
			else cast(left(experience,PATINDEX('%[^0-9]%',experience)-1)as int)
			end
where experience is not null
end


exec proc_experience
--checking applied or not
select * from DataAnalystJobsIndia
update DataAnalystJobsIndia set experience='5-6 Yrs' where base_salary=360000
select * from DataAnalystJobsIndia
exec proc_experience
select * from DataAnalystJobsIndia

---->
alter table DataAnalystJobsIndia add postedIn_date date
alter table DataAnalystJobsIndia add job_ID int Identity(1,1)

update DataAnalystJobsIndia set postedIn_date=DATEADD(Day,-[jobListed_days_ago],cast(GETDATE() as Date))

create or alter trigger trg_updatejoblisting_daysago on DataAnalystJobsIndia
after insert
as begin
    SET NOCOUNT ON;-- for No extra messages like 1 row affected etc.

    UPDATE j
    SET jobListed_days_ago = DATEDIFF(DAY, i.[postedIn_date], CAST(GETDATE() AS DATE))
    FROM DataAnalystJobsIndia j
    INNER JOIN inserted i
        ON j.job_ID = i.job_ID
end

insert into DataAnalystJobsIndia values('Data Science-Chennai','Remarkable company','3-4 Yrs',3,4,'2.14-6L/Yr',214000,600000,'Mumbai-Ghansoli',1,'Linkdin',2.0,200,'Gaming,Inventary Domain','2026-01-30')

select * from DataAnalystJobsIndia where job_ID in (1562,1563)

---->
create or alter view vw_joblisting as select job_title,company,salary,base_salary,max_salary,location,details from DataAnalystJobsIndia where base_salary is not null and max_salary is not null

select * from vw_joblisting

