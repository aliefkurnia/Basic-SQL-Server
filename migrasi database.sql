--migrasi tabel categoires dari database northwind
select categoryname,description from Northwind.dbo.Categories

insert into sales.categories(cate_name,cate_description)
select categoryname,description from Northwind.dbo.Categories

select * from sales.categories

--migrate customer

alter table sales.customers add cust_code nvarchar(5)

select companyname,customerid from Northwind.dbo.Customers
select * from Northwind.dbo.Customers
-- migrasi sales.customers dari database northwind
insert into sales.customers(cust_name,cust_code)
select companyname,customerid from Northwind.dbo.Customers

select * from sales.customers

--migrasi sales.shipper dari database northwind
select * from sales.shippers
select * from Northwind.dbo.shippers

insert into sales.shippers(ship_name,ship_phone)
select companyname, phone from Northwind.dbo.shippers


select * from sales.orders
select * from Northwind.dbo.Orders
--mengubah tipe data dari xcust_id
ALTER TABLE sales.orders ALTER column xcust_id varchar (5)

-- memasukan data dari northwind.dbo.orders ke sales.orders
set identity_insert  sales.orders on
insert into sales.orders(order_id, order_date, order_required_date, order_shipped_date, order_freight,
			order_ship_city, order_ship_address, order_ship_id, xemployee_id, xcust_id)
select orderid, orderdate, requireddate, shippeddate, freight, shipcity, shipaddress, shipvia, employeeid,customerid
from Northwind.dbo.Orders
set identity_insert  sales.orders off

--update order_cust_id berdasarkan xcust_id
update so
set order_cust_id = (select cust_id from sales.customers
where cust_code=so.xcust_id)
from sales.orders so

--migrate suppliers
select * from sales.suppliers
select * from Northwind.dbo.suppliers

set identity_insert  sales.suppliers on
insert into sales.suppliers(supr_id, supr_name, supr_contact_name)
select supplierid, companyname, contactname
from Northwind.dbo.Suppliers
set identity_insert  sales.suppliers off

--migrate prdoucts
select * from sales.products
select * from Northwind.dbo.products

set identity_insert  sales.products on
insert into sales.products(prod_id, prod_name, prod_quantity, prod_price, prod_in_stock, prod_reorder_level, 
			prod_discontinued, prod_cate_id, prod_supr_id)
select productid, productname, quantityperunit, unitprice, unitsinstock, reorderlevel, discontinued, categoryid, supplierid
from Northwind.dbo.Products
set identity_insert  sales.products off

--migrate order details
select * from sales.orders_detail
select * from Northwind.dbo.[Order Details]

insert into sales.orders_detail(ordet_order_id, ordet_prod_id, ordet_price, ordet_quantity, ordt_discount)
select orderid, productid, unitprice, quantity, discount
from Northwind.dbo.[Order Details]

select * from sales.orders
select * from Northwind.dbo.Orders

alter table sales.customers add cust_city nvarchar(25)

--merge table sales.customer & northwind.dbo.customer
merge into sales.customers as tg
using
(select companyname, city, customerid from northwind.dbo.customers)src
on tg.cust_name = src.companyname
when matched then update set tg.cust_name=src.companyname
when not matched then
insert ( cust_name, cust_city, cust_code)
values(src.companyname, src.city, src.customerid);

select * from sales.customers

update cust 
set cust_city = (select city from northwind.dbo.Customers where CustomerID=cust_code)
from sales.customers as cust;

update cust
set cust_location_id=( 
select distinct location_id from hr.locations
where lower(city) like lower(concat('%',cust_city,'%'))
)
from sales.customers cust

select * from sales.orders
select * from sales.customers
select * from Northwind.dbo.Customers

select d.department_id, d.department_name, min(hire_date) as oldest_hire_date,
COUNT(1) as total_employeee
from hr.departments as d join hr.employees as e
on d.department_id = e.department_id
group by d.department_id, d.department_name

select e.department_id, d.department_name, e.employee_id, e.first_name, e.last_name, e.hire_date
from hr.employees as e join hr.departments as d on e.department_id = d.department_id
where hire_date in (
	select min(hire_date)oldest_hire_date
	from hr.departments as d join hr.employees as e
	on d.department_id = e.department_id
	group by d.department_id, d.department_name
) order by e.department_id

--with clause

with emps as(
	select e.department_id, d.department_name, e.employee_id, e.first_name, e.last_name, e.hire_date
	from hr.employees as e join hr.departments as d on e.department_id = d.department_id
) select * from emps

--membandingkan 2 join dengan 2 join lain
with emps as(
	select e.department_id, d.department_name, e.employee_id, e.first_name, e.last_name, e.hire_date
	from hr.employees as e join hr.departments as d on e.department_id = d.department_id
	),
	senior as(
	select d.department_id, d.department_name, min(hire_date) as oldest_hire_date,
	COUNT(1) as total_employeee
	from hr.departments as d join hr.employees as e
	on d.department_id = e.department_id
	group by d.department_id, d.department_name
	)
select * from emps as e join senior as s on e.department_id = s.department_id
where e.hire_date = s.oldest_hire_date