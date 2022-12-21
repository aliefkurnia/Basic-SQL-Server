use AdventureWorks2019

GO
--CREATE PROCEDURE
CREATE or alter PROCEDURE [HumanResources].[UpdateNewEmployee] 
--DEKLARASI 
   @BusinessEntityID [int],
   @NationalIDNumber [nvarchar](15), 
   @BirthDate [datetime],
   @MaritalStatus [nchar](1),
   @Gender [nchar](1),
   @hireDate[datetime],
   @vacationHours[smallint],
   @sickLeaveHours[smallint],
   @Rate[money],
   @PayFrequency[tinyint],
   @EndDate[datetime],
   @jobTitle[nvarchar](50),
   @shiftID [int],
   @departmentid[int],
   @StartDate [datetime]
AS
BEGIN
    BEGIN TRY
            BEGIN TRANSACTION
            -- UPDATE KOLOM DARI MASING-MASING TABLE
                UPDATE [HumanResources].[Employee] 
                    SET [NationalIDNumber]   = @NationalIDNumber 
                        ,[BirthDate]         = @BirthDate 
                        ,[MaritalStatus]     = @MaritalStatus 
                        ,[Gender]            = @Gender
                        ,[hireDate]          = @hireDate
                        ,[vacationHours]     = @vacationHours
                        ,[sickLeaveHours]    = @sickLeaveHours
                        ,[JobTitle]          = @jobtitle
                        ,[ModifiedDate]      = default
                    WHERE [BusinessEntityID] = @BusinessEntityID;
                PRINT 'employee updated'

                UPDATE [HumanResources].[EmployeePayHistory]
                    SET  [rate]              = @Rate
                        ,[PayFrequency]      = @PayFrequency  
                        ,[ModifiedDate]      = default
                    WHERE [BusinessEntityID] = @BusinessEntityID;
                PRINT 'employee pay history updated'

                UPDATE[HumanResources].[EmployeeDepartmentHistory]
                    SET  [EndDate]           = @EndDate
                        ,[shiftID]           = @shiftID
                        ,[departmentID]      = @departmentid
                        ,[ModifiedDate]      = default
                    WHERE [BusinessEntityID] = @BusinessEntityID
                PRINT 'employee department history updated'
            COMMIT;

            PRINT 'data committed'
    END TRY
    
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Data di Rollback ' + cast(@BusinessEntityID as NVARCHAR (5))
        select ERROR_MESSAGE() as error_message
    END CATCH;
END;
GO


-- SELECT * FROM HumanResources.EmployeeDepartmentHistory
-- DROP PROCEDURE HumanResources.UpdateNewEmployee