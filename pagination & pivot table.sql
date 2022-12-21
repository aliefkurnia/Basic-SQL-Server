--pagination

select * from hr.employees
order by employee_id
offset 0 rows fetch next 5 rows only

--pivot table
select * from (
select e.job_id, d.department_name,e.employee_id
from hr.departments as d 
join hr.employees as e
on d.department_id= e.department_id
where d.department_id in('20','60','80'))t
pivot(
	count (employee_id) for department_name in ([SALES], [MARKETING],[IT])
)as tp


select * from hr.employees
select * from hr.departments

select * from( 
	select 
	year(hire_date) [Tahun Bekerja], 
	case month(hire_date)
	when 1 then 'jan'
	when 2 then 'feb'
	when 3 then 'mar'
	when 4 then 'apr'
	when 5 then 'mei'
	when 6 then 'jun'
	when 7 then 'jul'
	when 8 then 'ags'
	when 9 then 'sep'
	when 10 then 'okt'
	when 11 then 'nov'
	when 12 then 'des'
	end as Bulan
	from hr.employees
)as t
pivot(
	count([Bulan]) for [Bulan]
	in ([jan],[feb],[mar],[apr],[mei],[jun],[jul],[ags],[sep],[okt],[nov],[des])
)as p


---nomor 8

SELECT TOP(5) * FROM sales.orders_detail