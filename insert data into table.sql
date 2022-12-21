-- insert data into table hr.regions

select * from hr.regions

-- autoincrement
insert into hr.regions (region_name) values('Amerika');

-- set identity on;
set identity_insert hr.regions on;

insert into hr.regions (region_id,region_name) values(1,'Europe');

set identity_insert hr.regions off;

--delete row di table regions
delete from hr.regions


--reset identity coumn dept_id di table hr.regions
dbcc checkident('hr.regions',reseed,0)

--insert ke table hr.countries
insert into hr.countries(country_id, country_name,region_id)
values('JP','Japan',1)

select * from hr.countries
