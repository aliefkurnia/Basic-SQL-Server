DECLARE @RC int
DECLARE @BusinessEntityID int
DECLARE @NationalIDNumber nvarchar(15)
DECLARE @BirthDate datetime
DECLARE @MaritalStatus nchar(1)
DECLARE @Gender nchar(1)
DECLARE @hireDate datetime
DECLARE @vacationHours smallint
DECLARE @sickLeaveHours smallint
DECLARE @Rate money
DECLARE @PayFrequency tinyint
DECLARE @EndDate datetime
DECLARE @jobTitle nvarchar(50)
DECLARE @shiftID int
DECLARE @departmentid int
DECLARE @StartDate datetime

-- TODO: Set parameter values here.

EXECUTE @RC = [HumanResources].[UpdateNewEmployee] 
   @BusinessEntityID  = 290    
  ,@NationalIDNumber  = '111111'  
  ,@BirthDate         = '2000-10-10'
  ,@MaritalStatus     = 'M'
  ,@Gender            = 'F'
  ,@hireDate          = '2000-12-12'
  ,@vacationHours     = '1'
  ,@sickLeaveHours    = '1'
  ,@Rate              = 99
  ,@PayFrequency      = 1
  ,@DepartmentID      = 1
  ,@EndDate           = '2020-12-12'
  ,@jobTitle          = [Sales Representative]
  ,@shiftID           = 3
  ,@StartDate         = '07:00:00'

GO

SELECT * FROM HumanResources.Employee
WHERE BusinessEntityID =290

SELECT * FROM HumanResources.EmployeeDepartmentHistory
WHERE BusinessEntityID =290

SELECT * FROM HumanResources.EmployeePayHistory
WHERE BusinessEntityID =290
