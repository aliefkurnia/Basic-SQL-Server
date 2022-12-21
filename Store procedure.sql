BEGIN
PRINT 'hellow world'
end 

--declare variable

DECLARE @custId int ;
DECLARE @CustName NVARCHAR(40);
SELECT @custId=cust_id, @CustName= Cust_Name FROM sales.customers
SELECT @custId as custId ,@CustName as custname 

--if else

DECLARE @custId int ;
DECLARE @CustName NVARCHAR(40);
SELECT @custId=cust_id, @CustName= Cust_Name FROM sales.customers
    WHERE cust_id=1123123
IF @@ROWCOUNT = 1
    SELECT @custId as custId ,@CustName as custname 
ELSE
    SELECT ' no data found' as result

