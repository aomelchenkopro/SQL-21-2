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

На третьем этапе, если сумма кредитного лимита компании 

больше или равна сумме заказа - уменьшается количество единиц товара на складе, сумма заказа вычитается из кредитного лимита компании и заказ вносится в таблицу заказов.


На четвёртом этапе сумма текущих продаж служащего увеличивается на сумму заказа. 

На пятом этапе сумма текущих продаж офиса 
данного служащего, увеличивается на сумму заказа. 


На заключительном этапе процедура выводит сообщение о статусе операции.
*/



--=========================================================================================================================================================================
if object_id(N'DBO.ADD_NEW_ORDER', N'P') is not null drop procedure DBO.ADD_NEW_ORDER;
go
create procedure DBO.ADD_NEW_ORDER
@CUST_NUМ   int,     -- идентификатор клиента
@EMPL_NUМ   int,     -- идентификатор служащего
@MFR_ID     char(3), -- идентификатор производителя
@PRODUCT_ID char(5), -- идентификатор товара
@QTY        int      -- количество единиц
as begin
   SET NOCOUNT ON; -- отключение системных уведомлеий о количестве затронутых строк
   declare @ERROR_STATUS as int = 0;  -- Статус хранимой процедуры. 0 - не успешно, 1 - успешно
   declare @QTY_ON_HAND as int,       -- Кол-во ед. товара на складе
           @TOTAL numeric(15, 2),     -- общая сумма заказа
		   @CREDIT_LIMIT decimal(9,2) -- кредитный лимит компании
		   ;
		 ------------------------1-2------------------------
		 -- На первом этапе, процедура проверяет наличие указанного количества единиц товара на складе
		 -- На втором этапе, проводится расчёт суммы заказа
		 -- Получение количества ед. товара на складе и расчет общей суммы заказа  

		 -- ТРАНЗАКЦИЯ 1
         select @QTY_ON_HAND = p.QTY_ON_HAND,
		        @TOTAL = @QTY * p.PRICE
		   from [dbo].[PRODUCTS] as p
		  where p.MFR_ID = @MFR_ID
		    and p.PRODUCT_ID = @PRODUCT_ID;

		   print(@QTY_ON_HAND)
		   print(@TOTAL)
         ------------------------3------------------------
		 if (@QTY <= @QTY_ON_HAND)
			begin
			print('There are enough products in the storage')
			-- Получение суммы кредитного лимита клиента
			set @CREDIT_LIMIT = (-- ТРАНЗАКЦИЯ 2
			                     select c.CREDIT_LIMIT
			                       from [dbo].[CUSTOMERS] as c
								  where c.CUST_NUМ = @CUST_NUМ)

			if @CREDIT_LIMIT >= @TOTAL
				begin
					print('There is enough money to add a new order')
					-- уменьшается количество единиц товара на складе, сумма заказа вычитается из кредитного лимита компании и заказ вносится в таблицу заказов.
					----------------
					BEGIN TRANSACTION
					-- Уменьшение кол-ва ед. товара на складе
					-- ТРАНЗАКЦИЯ 3
					update [dbo].[PRODUCTS]
					   set QTY_ON_HAND = QTY_ON_HAND - @QTY
				     where MFR_ID = @MFR_ID
		               and PRODUCT_ID = @PRODUCT_ID;
					 print('Change the quantity of the product')

					 -- Вычитание суммы заказа из кред. лимита клиента
					 -- ТРАНЗАКЦИЯ 4
					 update [dbo].[CUSTOMERS]
					    set CREDIT_LIMIT = CREDIT_LIMIT - @TOTAL
					  where CUST_NUМ = @CUST_NUМ;
					 print('Change the credit limit of the customer')

					 -- Внесение нового заказа в таблицу
					 -- ТРАНЗАКЦИЯ 5
					 insert into [dbo].[ORDERS]([ORDER_NUМ], [ORDER_DATE], [CUST], [REP], [MFR], [PRODUCT], [QTY], [AМOUNT])
					 values((select max(t1.[ORDER_NUМ])+1 from [dbo].[ORDERS] as t1),
					       SYSDATETIME(), @CUST_NUМ, @EMPL_NUМ, @MFR_ID, @PRODUCT_ID, @QTY, @TOTAL)
					 print('Add the order into the order''s table')
					-------4--------
					-- сумма текущих продаж служащего увеличивается на сумму заказа
					-- ТРАНЗАКЦИЯ 6
					update [dbo].[SALESREPS]
					   set [SALES] = [SALES] + @TOTAL
					 where [EMPL_NUМ] = @EMPL_NUМ;
					 print('Increas the sales amount of the employe')

					-------5--------
					-- На пятом этапе сумма текущих продаж офиса данного служащего, увеличивается на сумму заказа
					-- ТРАНЗАКЦИЯ 7
					update t1
					   set t1.SALES = t1.SALES + @TOTAL
					  from [dbo].[OFFICES] as t1
					 inner join [dbo].[SALESREPS] as t2 on t2.REPOFFICE = t1.OFFICE
					                                   and t2.EMPL_NUМ = @EMPL_NUМ;
					print('Increas the sales amount of the office')
					----------------
					COMMIT TRANSACTION
					set @ERROR_STATUS = 1
				end
				else
				begin
					print('There is NOT enough money to add a new order')
				end
			
			end
			else
			begin
			print('There are NOT enough products in the storage')
			end

		 

		 -------------------------------------------------
		 -- На заключительном этапе процедура выводит сообщение о статусе операции.
		 if @ERROR_STATUS = 0
		 print('The operation is NOT successfull')
		 else
		 print('The operation is successfull')

   end;
--=========================================================================================================================================================================



execute DBO.ADD_NEW_ORDER 2101, 103, 'ACI', '41001', 30;

--select * from sys.objects  where type = N'P'
-- select * from [dbo].[PRODUCTS] where MFR_ID = 'BIC' and PRODUCT_ID = '41089'

/*
select * 
  from [dbo].[ORDERS]
  where year(ORDER_DATE) = 2007
    and (qty > 10 or [AМOUNT] > 10000)
*/

-- select 65000.00 - 1650 = 63350.00
select * from [dbo].[CUSTOMERS] where CUST_NUМ = 2101
-- 1650 select 277 - 30 = 247
select *, 30 * 55 from [dbo].[PRODUCTS] where MFR_ID = 'ACI' and PRODUCT_ID = '41001'

-- select 286775.00 + 1650 = 288425.00
select * from [dbo].[SALESREPS] where EMPL_NUМ = 103

-- select 735042.00 + 1650 = 736692.00
select * from [dbo].[OFFICES] where [OFFICE] = 12

select * from [dbo].[ORDERS]
--=========================================================================================================================================================================
-- TCL - Transaction control language
-- BEGIN TRANSACTION – служит для определения начала транзакции;
-- COMMIT TRANSACTION – применяет транзакцию;
-- ROLLBACK TRANSACTION – откатывает все изменения, сделанные в контексте текущей транзакции;
-- SAVE TRANSACTION – устанавливает промежуточную точку сохранения внутри транзакции.
--=========================================================================================================================================================================
BEGIN TRAN 

SAVE TRANSACTION SAVEPOINT1

delete from [dbo].[ORDERS]

SAVE TRANSACTION SAVEPOINT2

ROLLBACK TRANSACTION SAVEPOINT1



 select * from [dbo].[ORDERS]
/*
delete
insert
update
*/

-- select 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

select XACT_STATE()  

BEGIN TRAN 
update [dbo].[ORDERS]
   set [ORDER_DATE] = SYSDATETIME()
 where ORDER_NUМ = 112961 
 commit tran


 select count(distinct ORDER_NUМ) as [orderQty], sum([AМOUNT]) as[total]  from [dbo].[ORDERS] where MFR = 'ACI'


 insert into [dbo].[ORDERS] 
 values(1, SYSDATETIME(), 2101, 103, 'ACI', '41001', 100, 100.00)


 113071	2022-02-26	2101	103	ACI	41001	30	1650.00

 select * from [dbo].[ORDERS]

 	2A44G

-- ACID

select * from [dbo].[ORDERS]

begin tran
delete from [dbo].[ORDERS]
ROLLBACK TRANSACTION 



select * from [dbo].[ORDERS] where ORDER_NUМ = 112961  with (READUNCOMMITTED) 



SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

begin tran
--select qty, [AМOUNT] from [dbo].[ORDERS] with (SERIALIZABLE) where ORDER_NUМ = 112961   -- READ COMMITTED
select count(distinct ORDER_NUМ) as [orderQty], sum([AМOUNT]) as[total]  from [dbo].[ORDERS] with (REPEATABLEREAD) where MFR = 'ACI'

ROLLBACK TRANSACTION 

select XACT_STATE()  

13	85615.00
14	85715.00


/*
Скопируйте строки из файла с данными (без заголовков) в текстовый файл (.txt).

Загрузка данных с помощью BCP.
1. Запустите командную строку (от имени администратора).
2. Выполните команду - bcp <ИМЯ_БАЗЫ_ДАННЫХ>.<ИМЯ_СХЕМЫ>.<ИМЯ_ТАБЛИЦЫ> in ПУТЬ К ФАЙЛУ(.txt) -c -S 159.224.194.250 -U sa -P Rei4Hv5

Выгрузка данных с помощью BCP.
1. Запустите командную строку (от имени администратора).
2. Выполните команду - bcp <ИМЯ_БАЗЫ_ДАННЫХ>.<ИМЯ_СХЕМЫ>.<ИМЯ_ТАБЛИЦЫ> out ПУТЬ К ФАЙЛУ(.txt) -c -S 159.224.194.250 -U sa -P Rei4Hv5
*/


-- rLC9s39J7h


select * into bcp.orders from [dbo].[ORDERS] where 1 != 1

select * from [bcp].[orders]
select * from [dbo].[ORDERS]


bcp db2.bcp.orders in C:\Storage\orders.txt -c -S 159.224.194.250 -U sa -P rLC9s39J7h

bcp db2.bcp.orders out C:\Storage\orders_out.txt -c -S 159.224.194.250 -U sa -P rLC9s39J7h



Загрузка данных с помощью BCP.
1. Запустите командную строку (от имени администратора).
2. Выполните команду - bcp <ИМЯ_БАЗЫ_ДАННЫХ>.<ИМЯ_СХЕМЫ>.<ИМЯ_ТАБЛИЦЫ> in ПУТЬ К ФАЙЛУ(.txt) -c -S 159.224.194.250 -U sa -P Rei4Hv5
bcp db2.bcp.orders in C:\Storage\orders.txt -c -S 159.224.194.250 -U sa -P rLC9s39J7h


Выгрузка данных с помощью BCP.
1. Запустите командную строку (от имени администратора).
2. Выполните команду - bcp <ИМЯ_БАЗЫ_ДАННЫХ>.<ИМЯ_СХЕМЫ>.<ИМЯ_ТАБЛИЦЫ> out ПУТЬ К ФАЙЛУ(.txt) -c -S 159.224.194.250 -U sa -P Rei4Hv5
bcp db2.bcp.orders out C:\Storage\orders_out.txt -c -S 159.224.194.250 -U sa -P rLC9s39J7h