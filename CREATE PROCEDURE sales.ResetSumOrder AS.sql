CREATE PROCEDURE sales.ResetSumOrder AS 
    UPDATE sales.orders
    set order_subtotal = NULL, order_total_qty= NULL,
    order_status=NULL;

DECLARE @RC int
EXECUTE @RC = [sales].[ResetSumOrder] 
GO

SELECT * FROM sales.orders WHERE order_status= 'SHIPPED'