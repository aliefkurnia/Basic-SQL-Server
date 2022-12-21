
--cursor
CREATE PROCEDURE sales.UpdateSummaryOrder(@pagenumber int,@pagesize int)AS 
DECLARE @orderId int;
DECLARE @orderDate DATETIME;
DECLARE @totalPrice money;
DECLARE @totalQty SMALLINT;
DECLARE CursorOrder CURSOR FORWARD_ONLY READ_ONLY FOR
        SELECT order_id, order_date 
        FROM sales.orders
        ORDER BY order_id
        OFFSET @pagenumber ROWS FETCH NEXT @pagesize ROWS ONLY;
BEGIN
    --1 Open Cursor
    OPEN CursorOrder;   
    --2 fetch record to variable using while
    WHILE @@FETCH_STATUS = 0
    BEGIN
        FETCH NEXT FROM CursorOrder INTO @orderId, @orderDate;
        --3 display record
        -- select @orderId as order_id, @orderDate as order_date
        SELECT @totalPrice=SUM(ordet_price),@totalQty=SUM(ordet_quantity) 
        FROM sales.orders_detail WHERE ordet_order_id= @orderId

        -- SELECT @totalPrice , @totalqty       

        -- start TRANSACTION
        BEGIN TRY
            BEGIN TRANSACTION
            -- udpate table sales.ORDER
            UPDATE sales.orders
            set order_subtotal = @totalPrice, order_total_qty= @totalQty,
                order_status='SHIPPED', order_shipped_date= GETDATE()
            WHERE order_id=@orderId;
            PRINT 'Update For '+ CAST(@orderID as NVARCHAR(25))+ ' success';

        COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK;
            PRINT 'Transaction Rollback for OrderID:' + @orderID ;
            THROW;
        END CATCH
    END;

    --4 close cursor
    close CursorOrder;
    --5 hapus cursor from memory

END;