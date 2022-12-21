use AdventureWorks2019

-- nomor 1 
select person.persontype,
case PersonType
when 'IN' then 'Individual Customer'
when 'EM' then 'Employee'
when 'SP' then 'Sales Person'
when 'SC' then 'Sales Contact'
when 'VC' then 'Vendor Contact'
when 'GC' then 'General Contact'
end as persontype,

count(persontype) as TotalPerson
from person.Person
group by (PersonType)

        
--nomor 2

select  * from AdventureWorks2019.person.Person

select b.BusinessEntityID, b.LastName as FullName,ea.EmailAddressID, pp.PhoneNumber,(a.AddressLine1 + a.City+sp.Name+cr.Name) as Address ,at.Name as AddressType
from person.person as b 
join person.EmailAddress as ea on b.BusinessEntityID = ea.BusinessEntityID
join person.PersonPhone as pp on b.BusinessEntityID = pp.BusinessEntityID
join person.BusinessEntityAddress as bea on b.BusinessEntityID = bea.BusinessEntityID
join Person.Address as a on bea.AddressID = a.AddressID
join person.AddressType as at on bea.AddressTypeID = at.AddressTypeID
join person.StateProvince as sp on a.StateProvinceID = sp.StateProvinceID
join person.CountryRegion as cr on sp.CountryRegionCode = cr.CountryRegionCode
where Cr.Name = 'United States'

select * from Person.BusinessEntityAddress
select * from person.Address
select * from person.AddressType
select * from person.CountryRegion
where CountryRegionCode = 'US'


--nomor 3
select sp.CountryRegionCode, cr.name as CountryName,
case PersonType
when 'IN' then 'Individual Customer'
when 'EM' then 'Employee'
when 'SP' then 'Sales Person'
when 'SC' then 'Sales Contact'
when 'VC' then 'Vendor Contact'
when 'GC' then 'General Contact'
end as PersonType, count(b.BusinessEntityID) as TotalPerson
from person.person as b
join person.BusinessEntityAddress as be on b.BusinessEntityID = be.BusinessEntityID
join person.Address as a on be.AddressID = a.AddressID
join person.StateProvince as sp on a.StateProvinceID = sp.StateProvinceID
join person.CountryRegion as cr on sp.CountryRegionCode= cr.CountryRegionCode
group by b.PersonType,  sp.CountryRegionCode,cr.Name
order by   sp.CountryRegionCode,cr.Name ,TotalPerson

select * from Person.Person

--nomor 4
select * from(
	select sp.CountryRegionCode, cr.name as CountryName,
	case PersonType
	when 'IN' then 'Individual Customer'
	when 'EM' then 'Employee'
	when 'SP' then 'Sales Person'
	when 'SC' then 'Sales Contact'
	when 'VC' then 'Vendor Contact'
	when 'GC' then 'General Contact'
	end as PersonType
	from person.Person as b
	join person.BusinessEntityAddress as be on b.BusinessEntityID = be.BusinessEntityID
	join person.Address as a on be.AddressID = a.AddressID
	join person.StateProvince as sp on a.StateProvinceID = sp.StateProvinceID
	join person.CountryRegion as cr on sp.CountryRegionCode= cr.CountryRegionCode
) as t
pivot(
	count([persontype]) for [persontype]
	in([Individual Customer],[Employee],[Sales Person],[Sales Contact],[Vendor Contact],[General Contact])
)as p

--nomor 5
select edh.departmentid, d.name, count(b.JobTitle) as totalemployee
from humanresources.employee as b
join humanresources.employeedepartmenthistory as edh on b.businessentityid = edh.businessentityid
join humanresources.department as d on edh.departmentid = d.departmentid
group by edh.DepartmentID, d.Name

--nomor 6
select * from HumanResources.EmployeeDepartmentHistory
select * from HumanResources.Shift

SELECT * FROM(
	SELECT 
		d.Name [Name],
		s.Name [Shift], 
		e.BusinessEntityID [x]
	FROM HumanResources.EmployeeDepartmentHistory AS edh 
	JOIN HumanResources.Employee AS e ON e.BusinessEntityID = edh.BusinessEntityID
	JOIN HumanResources.Shift AS s ON s.ShiftID = edh.ShiftID
	JOIN HumanResources.Department AS d ON d.DepartmentID = edh.DepartmentID
) AS x
pivot(
	Count(x) for Shift in ([Day],[Evening],[Night])
)as xp

--nomor 7
select * from(
	select v.accountnumber, v.name, 
	case status	
	when 1 then 'Pending'
	when 2 then 'Approved'
	when 3 then 'Rejected'
	when 4 then 'Completed'
	end as status
	from Purchasing.Vendor as v
	join Purchasing.PurchaseOrderHeader as poh on v.BusinessEntityID = poh.VendorID
)as t
pivot(
	count(status) for status
	in([Pending],[Approved],[Rejected],[Completed])
)as p
order by Completed	desc
select * from Purchasing.PurchaseOrderHeader

--nomor 8
SELECT TOP(5) * FROM sales.SalesOrderDetail
SELECT TOP(5) * FROM sales.SalesOrderHeader
SELECT * FROM sales.Customer

WITH CustomerSalesOrderStatus AS(
	SELECT c.CustomerID, CONCAT(p.FirstName,' ',p.LastName) AS CustomerName, 
	case soh.status
		when 1 then 'InProcess'
		when 2 then 'Approved'
		when 3 then 'BackOrdered'
		when 4 then 'Rejected'
		when 5 then 'Shipped'
		when 6 then 'Cancelled'
	end as status

	FROM sales.SalesOrderHeader AS soh 
	JOIN sales.Customer AS c ON c.CustomerID = soh.CustomerID 
	JOIN person.Person AS p ON soh.CustomerID = p.BusinessEntityID
)

select * from(
 select CustomerId, Status from CustomerSalesOrderStatus
) as y
pivot(
	count(status) for status
	in([InProcess],[Approved],[BackOrdered],[Rejected],[Shipped],[Cancelled])
)as p
order by CustomerID


select * from(
 select * from CustomerSalesOrderStatus
) as y
pivot(
	count(status) for status
	in([InProcess],[Approved],[BackOrdered],[Rejected],[Shipped],[Cancelled])
)as p
order by CustomerID


-- nomor 9
select * from Production.ProductCategory
select * from Production.TransactionHistory


select * from (
	select c.CustomerID, CONCAT( p.firstname,' ',p.lastname) as CustomerName, pc.name
	from sales.SalesOrderHeader as soh
	JOIN sales.Customer AS c ON c.CustomerID = soh.CustomerID 
	JOIN person.Person AS p ON soh.CustomerID = p.BusinessEntityID
	JOIN sales.SalesOrderDetail AS sod  ON sod.SalesOrderID = soh.SalesOrderID
	JOIN production.product as pro ON sod.ProductID = pro.ProductID
	JOIN production.productsubcategory as psc ON pro.ProductSubcategoryID = psc.ProductSubcategoryID
	JOIN production.ProductCategory as pc ON psc.ProductCategoryID = pc.ProductCategoryID 
)as y
pivot(
	count(name) for name
	in([Accessories],[Bikes],[Components],[Clothing])
)as p
	where CustomerName between 'Albert Martin' and 'Alejandro Chen'
	order by CustomerName

--nomor 10
select * from sales.SpecialOffer
select * from Purchasing.PurchaseOrderHeader
select * from Sales.SpecialOffer

	select * from(
	select pro.ProductID, pro.Name, so.DiscountPct,
	year(startdate) [Year Discount], 
		case month(startdate)
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
		end as month
		from sales.SpecialOffer as so
	JOIN sales.SpecialOfferProduct as sop ON so.SpecialOfferID = sop.SpecialOfferID
	JOIN Production.Product as pro ON sop.ProductID = pro.ProductID
	)as t
	pivot(
		count(month) for month
		in ([jan],[feb],[mar],[apr],[mei],[jun],[jul],[ags],[sep],[okt],[nov],[des])
	)as p
	order by [Year Discount] desc