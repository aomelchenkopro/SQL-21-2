/* 
Задача № 6. 
Создайте хранимую процедуру. 
Процедура принимает параметры: 
- идентификатор клиента. 
- идентификатор служащего. 
- идентификатор производителя. 
- идентификатор товара. 
- количество единиц. 
 
На первом этапе, процедура проверяет наличие указанного количества единиц товара на складе 
 
далее на втором этапе, проводится расчёт суммы заказа.  
 
На третьем этапе, если сумма кредитного лимита компании больше или равна сумме заказа - уменьшается количество  
единиц товара на складе, сумма заказа вычитается из кредитного лимита компании и заказ вносится в таблицу заказов. 
 
На четвёртом этапе сумма текущих продаж служащего увеличивается на сумму заказа.  
 
На пятом этапе сумма текущих продаж офиса данного служащего, увеличивается на сумму заказа.  
 
На заключительном этапе процедура выводит сообщение о статусе операции. 
*/ 
 

use [SQL-21-2_Molchanov];                                                             -- Переключение базы данных
 

if object_id(N'ORDER_PROCEDURE', N'P') is not null drop procedure [ORDER_PROCEDURE];  
go
 
create procedure [ORDER_PROCEDURE]                                                    -- Объявление принимаемых переменных
   @CUSTOMER_ID [int], 
   @EMPL_ID [int], 
   @MFR_ID nchar(3), 
   @PRODUCT_ID nchar(5), 
   @QTY [int] 
as 
begin 

   set nocount on;                                                                     -- Отключение системных уведомлеий о количестве затронутых строк

-------------------------------------------------------------------------------------------
       declare @ERROR_CODE as [int];
	   set @ERROR_CODE=0;
	   
	   declare @QTY_ON_STORE as [int];                           
       set @QTY_ON_STORE=(    
                          select t1.[QTY_ON_HAND]
                             from [PRODUCTS] as t1  
                            where t1.[MFR_ID]=@MFR_ID and t1.[PRODUCT_ID]=@PRODUCT_ID );
       
	   declare @SUM as decimal(9,2);                                                   -- Второй этап - проводится расчёт суммы заказа
	   set @SUM=@QTY*(
		              select t2.[PRICE]
					     from [PRODUCTS] as t2
				       where t2.[MFR_ID]=@MFR_ID and t2.[PRODUCT_ID]=@PRODUCT_ID);
----------------------------------------------------------------------------------------------
	  
		if @QTY <= @QTY_ON_STORE                                                       -- Первый этап - процедура проверяет наличие указанного количества единиц товара на складе
	begin
		
----------------------------------------------------------------------------------------------
        declare @CREDITLIM decimal(9,2)                                                -- Третий этап: 
        set @CREDITLIM=(
                        select t3.[CREDITLIMIT]
				             from [CUSTOMERS] as t3 
					      where t3.[CUST_NUМ]=@CUSTOMER_ID);
		 if @SUM <= @CREDITLIM                                                         -- если сумма кредитного лимита компании больше или равна сумме заказа 
		begin
		set @QTY_ON_STORE = (@QTY_ON_STORE-@QTY);                                      -- уменьшается количество единиц товара на складе
		update [PRODUCTS]
		  set [QTY_ON_HAND] =  @QTY_ON_STORE
		    where MFR_ID=@MFR_ID and [PRODUCT_ID]=@PRODUCT_ID;
		
		set @CREDITLIM = (@CREDITLIM-@SUM)                                             -- сумма заказа вычитается из кредитного лимита компании
		update [CUSTOMERS]                                         
         set [CREDITLIMIT] = @CREDITLIM                              
           where [CUST_NUМ] = @CUSTOMER_ID;                         
        insert into [ORDERS]                                                           -- заказ вносится в таблицу заказов
            ([ORDER_NUМ]
			,[ORDER_DATE]
            ,[CUST]
            ,[REP]
            ,[MFR]
            ,[PRODUCT]
            ,[QTY]
            ,[AМOUNT]
			)
          values (
		  (select  max (ORDER_NUМ)+1     from ORDERS)
		  ,getdate()
		  ,@CUSTOMER_ID
		  ,@EMPL_ID
		  ,@MFR_ID
		  ,@PRODUCT_ID
		  ,@QTY
		  ,@SUM
		  );
----------------------------------------------------------------------------------------------

		  update [SALESREPS]                                                            -- Четвертый этап - сумма текущих продаж служащего увеличивается на сумму заказа
		    set [SALES] = ([SALES]+@SUM)
		   where [EMPL_NUМ] = @EMPL_ID;

----------------------------------------------------------------------------------------------

		  update [OFFICES]                                                               -- Пятый этап - сумма текущих продаж офиса данного служащего, увеличивается на сумму заказа  

		    set [SALES] = ([SALES]+@SUM)
		   where OFFICE = (
		             select REPOFFICE
					    from SALESREPS
						where EMPL_NUМ = @EMPL_ID
						  );

		end;
		else
		set @ERROR_CODE=2;
	end;
	else 
	  if @SUM <= (
                  select [CREDITLIMIT]
				      from [CUSTOMERS]
					where [CUST_NUМ]=@CUSTOMER_ID)
		set @ERROR_CODE=1;
		else
		set @ERROR_CODE=3;
 if @ERROR_CODE=0                                                                      -- Шестой этап - процедура выводит сообщение о статусе операции
    print (N'Операция прошла успешно');
 else
 if @ERROR_CODE=1
    print (N'Ошибка: товар отсутствует на складе в требуемом количестве');
 else
 if @ERROR_CODE=2
   print (N'Ошибка: у клиента недостаточный размер кредитного лимита');
else
 if @ERROR_CODE=3
   print (N'Ошибка: товар отсутствует на складе в требуемом количестве; у клиента недостаточный размер кредитного лимита');
else
   print (N'Произошла неизвестная ошибка');
end;


execute [ORDER_PROCEDURE] 2101, 106, N'REI', N'2A44L', 4;                              -- Выполнение хранимой процедуры

--------------------------------------------------------

update [CUSTOMERS]                                                                     -- Откат внесенных изменений в БД
   set [CREDITLIMIT] = 65000                              
      where [CUST_NUМ] = 2101;

update [PRODUCTS]
   set [QTY_ON_HAND] = 12
      where [MFR_ID]=N'REI' and [PRODUCT_ID]=N'2A44L';

delete [ORDERS]
   where [ORDER_NUМ] in (113070, 113071, 113072, 113073);

update [SALESREPS]
   set [SALES] = 299912.00
      where [EMPL_NUМ] = 106;

update [OFFICES]
   set [SALES] = 692637.00
      where [OFFICE] = 11;

----------------------------------------------------------------------------------------------
  
                                                                                        -- Просмотр таблиц
 select *
    from [CUSTOMERS] as t1;

select *
    from [PRODUCTS] as t2;

select *
    from [ORDERS] as t3;

select *
    from [SALESREPS] as t4;

select *
    from [OFFICES] as t5;
 
 
 
