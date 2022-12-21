--Informasi jumlah department di tiap regions.
-- nomor 1
select region_name, count(d.department_id) as jumlah_department
from hr.regions as r 
left join hr.countries as c on r.region_id = c.region_id
left join hr.locations as l on c.country_id = l.country_id
left join hr.departments as d on l.location_id = d.location_id
group by region_name
order by jumlah_department desc

--Informai jumlah department tiap countries.
--nomor 2
select country_name, count(d.department_id) as jumlah_department
from hr.countries as c 
left join hr.locations as l on c.country_id = l.country_id
left join hr.departments as d on l.location_id = d.location_id
group by country_name
order by jumlah_department desc

--Informasi jumlah employee tiap department.
--nomor 3
select department_name,count(employee_id) as total_employee
from hr.departments as d 
left join hr.employees as e on d.department_id=e.department_id
group by department_name
order by total_employee desc

-- Informasi jumlah employee tiap region.
-- nomor 4
select r.region_name, count(e.employee_id) as total_employee
from hr.regions as r 
left join hr.countries as c on c.region_id = r.region_id
left join hr.locations as l on c.country_id = l.country_id
left join hr.departments as d on l.location_id = d.location_id
left join hr.employees as e on d.department_id = e.department_id
group by region_name
order by total_employee desc
select * count(employee_id) from hr.employees
select *  from hr.employees

--Informasi jumlah employee tiap countries.
--nomor 5
select c.country_name, count(e.employee_id) as total_employee
from hr.countries as c 
join hr.locations as l on c.country_id = l.country_id
join hr.departments as d on l.location_id = d.location_id
join hr.employees as e on d.department_id = e.department_id
group by country_name

--Informasi salary tertinggi tiap department.
-- nomor 6
	select department_name, max(salary) as salary_tertinggi
	from hr.employees as e
	join hr.departments as d on e.department_id = d.department_id
	group by department_name
	order by salary_tertinggi desc

-- Informasi salary terendah tiap department.
--nomor 7
select department_name, min(salary) as salary_terendah
from hr.employees as e
join hr.departments as d on e.department_id = d.department_id
group by department_name

--Informasi salary rata-rata tiap department.
-- nomor 8
select department_name, avg(salary) as rata_rata_salary
from hr.employees as e
join hr.departments as d on e.department_id = d.department_id
group by department_name

--Informasi jumlah mutasi pegawai tiap deparment.
-- nomor 9
select d.department_name,count(employee_id) as jumlah_mutasi
from hr.departments as d
left join hr.job_history as jh on d.department_id = jh.department_id
group by department_name
order by jumlah_mutasi desc

--.Informasi jumlah mutasi pegawai berdasarkan role-jobs.
-- nomor 10
select j.job_title,count(employee_id) as jumlah_mutasi
from hr.jobs as j
join hr.job_history as jh on j.job_id= jh.job_id
group by job_title

--Informasi jumlah employee yang sering dimutasi.
--nomor 11

SELECT COUNT(employee_id) AS total_mutation FROM(
	SELECT jh.employee_id, COUNT(jh.employee_id) AS total_emp 
	FROM hr.job_history AS jh
	GROUP BY jh.employee_id
	HAVING COUNT(jh.employee_id) = (
		SELECT max(q.jumlah_mutasi) 
		FROM(
		SELECT employee_id, count(employee_id) AS jumlah_mutasi
		FROM hr.job_history
		GROUP BY employee_id
		) q
	)
		-- stop having count
) XSfvdfhddf;
 
SELECT * FROM hr.job_history;


--.Informasi jumlah employee berdasarkan role jobs-nya.
--nomor 12
select j.job_title, count(employee_id) as jumlah_employee
from hr.jobs as j
left join hr.employees as e on e.job_id = j.job_id
group by j.job_title
order by jumlah_employee desc

select count(employee_id) from hr.employees
--Informasi employee paling lama bekerja di tiap deparment.
--nomor 13
SELECT CONCAT(e.first_name,' ', e.last_name) AS name, d.department_name, e.hire_date
FROM hr.employees AS e JOIN hr.departments AS d
ON e.department_id = d.department_id
WHERE e.hire_date in(
    select min(hire_date)
    from hr.departments d
    JOIN hr.employees e
    ON d.department_id = e.department_id
    GROUP BY d.department_name);

--Informasi employee baru masuk kerja di tiap department.
--nomor 14
SELECT CONCAT(e.first_name,' ', e.last_name) AS name, d.department_name, e.hire_date
FROM hr.employees AS e JOIN hr.departments AS d
ON e.department_id = d.department_id
WHERE e.hire_date in(
    select max(hire_date)
    from hr.departments d
    JOIN hr.employees e
    ON d.department_id = e.department_id
    GROUP BY d.department_name);

--Informasi lama bekerja tiap employee dalam tahun dan jumlah mutasi history-nya.
--nomor 15
select e.first_name,DATEDIFF(YY,e.hire_date,GETDATE()) as pengalaman, count(jh.employee_id) as jumlah_mutasi
from hr.employees as e left join hr.job_history as jh on e.employee_id = jh.employee_id
group by first_name, e.hire_date