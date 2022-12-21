create table hr.regions(
region_id int identity(1,1),
region_name nvarchar (25) default null,
constraint pk_region_id primary key(region_id)
);

create table hr.countries(
country_id nchar(2),
country_name nvarchar(40) default null,
region_id int not null,
constraint pk_country_id primary key(country_id),
constraint fk_region_id foreign key(region_id) references hr.regions (region_id) on delete
cascade on update cascade
);

-- display table constraint
select* from INFORMATION_SCHEMA.TABLE_CONSTRAINTS

--add constraint unique
alter table hr.countries add constraint country_name_uq unique (country_name)

create table hr.locations(
location_id int identity(1,1),
street_address nvarchar (40),
postal_code nvarchar (12),
city nvarchar(30),
state_province nvarchar(25),
country_id nchar(2)
constraint pk_location_id primary key(location_id)
constraint fk_country_id foreign key(country_id) references hr.countries (country_id) on delete
cascade on update cascade
);
 
 select * from hr.departments
create table hr.departments(
department_id int identity(1,1),
department_name nvarchar(30),
manager_id int ,
location_id int not null
constraint pk_department_id primary key(department_id)
constraint fk_location_id foreign key(location_id) references hr.locations (location_id) on delete
cascade on update cascade
);

create table hr.jobs(
job_id nvarchar(10),
job_title nvarchar (35) ,
min_salary decimal(8,2),
max_salary decimal(8,2)
constraint pk_job_id primary key(job_id),
constraint job_title_uq unique(job_title)
);

create table hr.employees(
employee_id int identity(1,1),
first_name nvarchar (20) ,
last_name nvarchar (25) ,
email nvarchar(25),
phone_number nvarchar(20),
hire_date datetime,
salary decimal(8,2),
commission_pct decimal (2,2),
job_id nvarchar (10) ,
manager_id int ,
department_id int
constraint pk_employee_id primary key(employee_id),
constraint fk_job_id foreign key(job_id) references hr.jobs (job_id),
constraint fk_department_id foreign key(department_id) references hr.departments (department_id)
on delete cascade on update cascade
);


create table hr.job_history(
employee_id int ,
start_date datetime,
end_date datetime,
job_id nvarchar (10),
department_id int
constraint pk_employee_id_start_date primary key(employee_id,start_date),
constraint fk_jh_job_id foreign key(job_id) references hr.jobs (job_id),
constraint fk_jh_department_id foreign key(department_id) references hr.departments (department_id)
);

select * from hr.countries,
select * from hr.departments,
select * from hr.locations,
select * from hr.employees,
select * from hr.job_history,
select * from hr.jobs,
select * from hr.regions;

select *  from hr.countries inner join hr.departments on location_id = location_id
select *  from hr.countries full join hr.departments on location_id = location_id
select *  from hr.countries full outer join hr.departments on location_id = location_id where location_id is null or location_id is null
select * from hr.employees where first_name like 't%'
select * from hr.employees where department_id =90

--create table from table
select top(5) employee_id, first_name,salary,department_id
into tableA
from hr.employees

select top(6) employee_id, first_name,salary,department_id
into tableB
from hr.employees

select*from tableA
select*from tableB

--inner join without alias
select * from tableA join tableB on tableA.employee_id=tableB.employee_id
--inner join alias
select a.* from tableA as a join tableB as b on a.employee_id=b.employee_id

--left join
select a.* 
from tableA as a left join tableB as b 
on a.employee_id= b.employee_id
where a.department_id=60

--right join with alias columns
select b.* 
from tableA as a right join tableB as b 
on a.employee_id= b.employee_id

--full outer join
select *
from tableA as a full outer join tableB as b
on a.employee_id=b.employee_id

--countries & locations
select * from hr.countries
select * from hr.locations

select *
from hr.countries as c left join hr.locations as l
on c.country_id=l.country_id
where l.location_id is null
order by c.country_id

select * from hr.locations where country_id = 'AR'

--display department yang ada di region america / asia
select distinct l.location_id
from hr.regions as r join hr.countries as c on r.region_id= c.region_id
join hr.locations as l on c.country_id = l.country_id
where r.region_id=2

select * from hr.departments as d where d.location_id in(
select distinct l.location_id
from hr.regions as r join hr.countries as c on r.region_id= c.region_id
join hr.locations as l on c.country_id = l.country_id
where r.region_id=2
)

--aggregate
select min(salary) as min_salary, max(salary) as max_salary
from hr.employees

select min (hire_date) as senior , max(hire_date) as fresh_graduate
from hr.employees

--display oldest employee
select * from hr.employees where hire_date= (select min(hire_date) from hr.employees)

--datetime
select employee_id,first_name,hire_date,
year(hire_date) as tahun, 
MONTH(hire_date) as bulan, 
DAY(hire_date) as tanggal,
DATEDIFF(yy,hire_date,GETDATE()) as lama_kerja
from hr.employees as e

select GETDATE()

--display total employee each department
select d.department_id,department_name,count(employee_id) as total_employee
from hr.departments as d join hr.employees as e on d.department_id=e.department_id
group by department_name,d.department_id
order by total_employee desc

--having count
select sum(t.total_employee) as total_emp from(
select d.department_id,department_name,count(employee_id) as total_employee
from hr.departments as d join hr.employees as e on d.department_id=e.department_id
group by department_name,d.department_id
having count(employee_id) >=5
)t