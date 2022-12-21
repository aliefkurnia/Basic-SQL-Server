use AdventureWorks2019

CREATE PROCEDURE 
 -- local variable @profile
 declare @firstName  nvarchar(50)
 declare @lastName   nvarchar(50)
 declare @suffix     nvarchar(10)

 -- local variable @hiring and @salary
declare @nationalIDNumber   nvarchar(15)
declare @birthDate          date
declare @MaritalStatus      nchar(1)
declare @gender             nchar(1)
declare @hireDate           date
declare @salaryRate         smallint
declare @frequency          tinyint
declare @vacationHours      smallint
declare @sickLeaveHours     smallint

-- local variables @department and @shift
declare @deparmentName      nvarchar(50)
declare @jobTitle           nvarchar(50)
declare @shiftName          nvarchar(50)           
declare @startTime          time(7)
declare @endTime            time(7)


-- create HumanResources.CreateNewEmployee()
--start transaction
    BEGIN

        begin try
            begin Transaction
            --update table person.person
            UPDATE
            set
            commit Transaction 
        END TRY
        BEGIN CATCH
            ROLLBACK;
            PRINT 'Data di Rollback'
        END CATCH
    END BEGIN;
SELECT * from Person.BusinessEntity
select 
    -- profile
    Per.FirstName + ' ' + Per.LastName as FullName,
    Per.Suffix as [Suffix(Junior,PHD)],
    -- hiring & salary
    HRe.NationalIDNumber, 
    HRe.BirthDate, 
    HRe.MaritalStatus, 
    HRe.Gender, 
    HRe.HireDate,
    HReph.Rate as SalaryRate,  
    HReph.PayFrequency as Frequency,
    HRe.VacationHours, 
    HRe.SickLeaveHours, 
    -- departement & shift
    HRd.Name as [DepartementName],
    Hre.JobTitle,
    HRs.Name as [ShiftName],
    HRs.StartTime,
    HRs.EndTime
from HumanResources.Employee as HRe
join Person.Person as Per
on HRe.BusinessEntityID = Per.BusinessEntityID
    join HumanResources.EmployeePayHistory as HReph
    on HReph.BusinessEntityID = HRe.BusinessEntityID
        join HumanResources.EmployeeDepartmentHistory as HRedh
        on HRedh.BusinessEntityID = HRe.BusinessEntityID
            join HumanResources.Department as H Rd
            on HRd.DepartmentID = HRedh.DepartmentID
                join HumanResources.Shift as HRs
                    on HRs.ShiftID = HRedh.ShiftID



select * from HumanResources.Employee 