/*
Задача №1.
Напишите запрос, возвращающий список имён служащих (без дубликатов), которые совершали заказы в период с 01.01.2008 по 31.03.2008 на продукты компании QSA.
- Используются таблицы SALESREPS, [dbo].[ORDERS].
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-92).
- Задействуйте предикат between.
- Результирующий набор содержит имя служащего.
*/

select distinct
       t2.[NАМЕ]
  from [dbo].[ORDERS] as t1
left outer join [dbo].[SALESREPS] as t2 on t2.[EMPL_NUМ] = t1.[REP]
 where t1.ORDER_DATE between '20080101' and '20080331 23:59:59'
       and t1.[MFR] = N'QSA'
;
--===========================================================================================================================
select distinct
       t2.[NАМЕ]
  from [dbo].[ORDERS] as t1
inner join [dbo].[SALESREPS] as t2 on t2.[EMPL_NUМ] = t1.[REP]
 where t1.ORDER_DATE between '20080101' and '20080331 23:59:59'
       and t1.[MFR] = N'QSA'
;

/*
Задача №2.
Напишите запрос, возвращающий для клиентов с кредитным лимитом выше 35000 общую сумму заказов на продукты компании 'ACI'.
- Используются таблицы [dbo].[CUSTOMERS], [dbo].[ORDERS].
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-92).
- Задействуйте агрегатную функцию sum.
- Результирующий набор данных содержит идентификатор клиента, наименование клиента, сумму заказов.
*/

select t1.[CUST_NUМ],
       t1.[COMPANY],
	   sum(t2.[AМOUNT]) as [TOTAL_AMOUNT]
 from [dbo].[CUSTOMERS] as t1
left outer join [dbo].[ORDERS] as t2 on t2.[CUST] = t1.[CUST_NUМ]
                                     and t2.[MFR] = N'ACI'
where [CREDITLIMIT] > 35000.00
group by t1.[CUST_NUМ],
         t1.[COMPANY]
;

/*
Задача №3.1
Напишите запрос, возвращающий данные самого старшего служащего из восточного региона.
Учитывайте вероятность того что, один и тот же возраст (AGE) может быть сразу у нескольких служащих.
- Используются таблицы [dbo].[SALESREPS], [dbo].[OFFICES].
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-89).
- Задействуйте скалярный, автономный, вложенный запрос.
- Задействуйте агрегатную функцию MAX.
- Результирующий набор данных содержит идентификатор служащего, должность, имя служащего, цель продаж, текущие продажи.
*/

select t3.EMPL_NUМ,
       t3.TITLE,
	   t3.NАМЕ,
	   t3.QUOTA,
	   t3.SALES
 from [dbo].[SALESREPS] as t3
where t3.AGE = (
				select max(t1.AGE)                            -- Находим возраст самого старшего служащего из восточного региона
                  from [dbo].[SALESREPS] as t1
				inner join [dbo].[OFFICES] as t2 on t2.OFFICE = t1.REPOFFICE
                                              and t2.REGION = N'Eastern'
               )
;
--=====================================================================================================================================
with emploees as
(
select t1.EMPL_NUМ,
       t1.TITLE,
	   t1.NАМЕ,
	   t1.QUOTA,
	   t1.SALES,
	   t1.AGE
 from [dbo].[SALESREPS] as t1
inner join [dbo].[OFFICES] as t2 on t2.OFFICE = t1.REPOFFICE
                                    and t2.REGION = N'Eastern'
)
select t3.EMPL_NUМ,
       t3.TITLE,
	   t3.NАМЕ,
	   t3.QUOTA,
	   t3.SALES
from emploees as t3
where t3.AGE = (
                  select max(t4.AGE)
				    from emploees as t4
               )
;

/*
Задача №3.2
Напишите запрос, возвращающий список заказов за 2008 г, которые обработал (совершил продажу) самый старший служащий из восточного региона.
Учитывайте вероятность того что, один и тот же возраст (AGE) может быть сразу у нескольких служащих.
- Используются таблицы [dbo].[ORDERS], [dbo].[SALESREPS], [dbo].[OFFICES].
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-92).
- Задействуйте скалярный и табличный автономные, вложенные запросы.
- Результирующий набор данных содержит идентификатор заказа, дату заказа, идентификатор служащего, идентификатор производителя товара, 
  идентификатор товара, сумма заказа.
*/

with emploees as
(
select t1.EMPL_NUМ,
	   t1.AGE
 from [dbo].[SALESREPS] as t1
inner join [dbo].[OFFICES] as t2 on t2.OFFICE = t1.REPOFFICE
                                    and t2.REGION = N'Eastern'
)
select t2.ORDER_NUМ,
       t2.ORDER_DATE,
	   t2.REP,
	   t2.MFR,
	   t2.PRODUCT,
	   t2.AМOUNT
from [dbo].[ORDERS] as t2
where t2.ORDER_DATE between '20080101' and '20081231 23:59:59'
      and t2.REP in (
					 select t3.EMPL_NUМ
					   from emploees as t3
					  where t3.AGE = (
									  select max(t4.AGE)
										from emploees as t4
								      )
                    )
;

/*
Задача №3.3
Напишите запрос, возвращающий общую сумму заказов по каждому проданному товару за 2008 год, 
которые обработал (совершил продажу) самый старший служащий из восточного региона.
Учитывайте вероятность того что, один и тот же возраст (AGE) может быть сразу у нескольких служащих.
- Используются таблицы [dbo].[PRODUCTS], [dbo].[ORDERS], [dbo].[SALESREPS], [dbo].[OFFICES].
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-92).
- Задействуйте скалярный и табличный автономные, вложенные запросы.
- Задействуйте агрегатную функцию SUM.
- Результирующий набор данных содержит идентификатор служащего, идентификатор производителя товара, 
  идентификатор товара, описание товара, общая сумму продаж за 2008 г.
*/

with emploees as
(
select t1.EMPL_NUМ,
	   t1.AGE
 from [dbo].[SALESREPS] as t1
inner join [dbo].[OFFICES] as t2 on t2.OFFICE = t1.REPOFFICE
                                    and t2.REGION = N'Eastern'
)
select t2.REP,
	   t5.MFR_ID,
       t5.PRODUCT_ID,
	   t5.[DESCRIPTION],
	   sum(t2.AМOUNT)
from [dbo].[ORDERS] as t2
left outer join [dbo].[PRODUCTS] as t5 on t5.PRODUCT_ID = t2.PRODUCT
where t2.ORDER_DATE between '20080101' and '20081231 23:59:59'
      and t2.REP in (
					 select t3.EMPL_NUМ
					   from emploees as t3
					  where t3.AGE = (
									  select max(t4.AGE)
										from emploees as t4
								      )
                    )
group by t2.REP,  
         t5.MFR_ID,
         t5.PRODUCT_ID,
	     t5.[DESCRIPTION]
;

/*
Задача №4.
Напишите запрос, возвращающий для каждого города наиболее продаваемый (по количеству заказов) товар.
Учитывайте вероятность того что, одно и то же количество заказов могут иметь сразу несколько товаров.
- Используются таблицы PRODUCTS, [dbo].[ORDERS], [dbo].[SALESREPS], [dbo].[OFFICES],
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-92).
- Задействуйте ранжирующую функцию DENSE_RANK.
- Задействуйте агрегатную функцию COUNT в режиме игнорирующем null.
- Результирующий набор данных содержит регион, идентификатор производителя товара, идентификатор товара, описание товара, количество заказов, ранг строки.
*/
with orders as
(
select t1.REGION,
       t1.OFFICE,
       t1.CITY, 
	   t2.EMPL_NUМ,
	   t3.ORDER_NUМ,
	   t3.MFR,
	   t3.PRODUCT,
	   t4.[DESCRIPTION],
	   count(t3.ORDER_NUМ) over (partition by t1.CITY, t3.MFR, t3.PRODUCT) as [count]
from [dbo].[OFFICES] as t1
inner join [dbo].[SALESREPS] as t2 on t2.REPOFFICE = t1.OFFICE
inner join [dbo].[ORDERS] as t3 on t3.REP = t2.EMPL_NUМ
inner join [dbo].[PRODUCTS] as t4 on t4.[MFR_ID] = t3.MFR and t4.[PRODUCT_ID] = t3.PRODUCT
)
select t6.REGION,
       t6.MFR,
	   t6.PRODUCT,
	   t6.[DESCRIPTION],
	   t6.[num] as [quantity],
	   t6.[count]
 from (
		select  distinct
				t5.REGION,
				t5.CITY,
				t5.MFR,
				t5.PRODUCT,
				t5.[DESCRIPTION],
				t5.[count],
				first_value(t5.[count])over(partition by t5.CITY order by t5.[count] desc) as [num]
		from orders as t5
	 ) as t6
where t6.[count] = t6.num
;

/*
Задача № 5.
Напишите запрос, возвращающий список товаров, которые не продавались в Chicago.
- Используются таблицы [dbo].[OFFICES], [dbo].[SALESREPS], [dbo].[ORDERS], [dbo].[PRODUCTS].
- Задействуйте внутреннее и внешние обеднения таблицы (синтаксис ANSI SQL-92).
- Результирующий набор данных содержит идентификатор производителя, идентификатор товара, описание товара, цену за единицу, количество на складе.
*/
if object_id('[tempdb].[dbo].#orders') is not null drop table #orders;

select t3.MFR,
       t3.PRODUCT
  into #orders
  from [dbo].[OFFICES] as t1
  left outer join [dbo].[SALESREPS] as t2 on t1.OFFICE = t2.REPOFFICE
  left outer join [dbo].[ORDERS] as t3 on t3.REP = t2.EMPL_NUМ
 where t1.CITY = N'Chicago'
       and t3.MFR is not null
;

select *
from #orders

select t1.*
  from [dbo].[PRODUCTS] as t1
  left outer join #orders as t2 on t2.MFR = t1.MFR_ID
                         and t2.PRODUCT = t1.PRODUCT_ID
 where t2.MFR is null
;

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
далее на втором этапе, проводится расчёт суммы заказа. На третьем этапе, если сумма кредитного лимита компании 
больше или равна сумме заказа - уменьшается количество единиц товара на складе, 
сумма заказа вычитается из кредитного лимита компании и 
заказ вносится в таблицу заказов.
На четвёртом этапе сумма текущих продаж служащего увеличивается на сумму заказа. На пятом этапе сумма текущих продаж офиса 
данного служащего, увеличивается на сумму заказа. На заключительном этапе процедура выводит сообщение о статусе операции.
*/
GO
if object_id(N'[dbo].[ADD_NEW_ORDER]', N'P') is not null drop procedure [dbo].[ADD_NEW_ORDER];

go

Create procedure dbo.[ADD_NEW_ORDER] 
 @CUST_NUМ       int,                       -- идентификатор клиента
 @EMPL_NUМ       tinyint,                   -- идентификатор служащего
 @MFR_ID         nchar(3),                  -- идентификатор производителя
 @PRODUCT_ID     nchar(5),                  -- идентификатор товара
 @QTY_ON_HAND    int                        -- количество единиц
as 
begin 
    SET NOCOUNT ON

    declare @QTY               as int,            -- количество на складе
            @PriceProduct      as numeric(9,2),   -- Цена продукта           
            @ERROR_STATUS      as int = 0         -- Статус хранимой процедуры. 0 - не успешно, 1 - успешно

	select @QTY = t1.QTY_ON_HAND, 
		   @PriceProduct = t1.PRICE 
	  from [dbo].[PRODUCTS] as t1 
	 where t1.PRODUCT_ID = @PRODUCT_ID
		   and t1.MFR_ID = @MFR_ID 
	declare @Check_Employee as nvarchar(15) = null;

			select @Check_Employee = t1.NАМЕ
			  from [dbo].[SALESREPS] as t1
			 where t1.EMPL_NUМ = @EMPL_NUМ
 
	if(@QTY >= @QTY_ON_HAND and @Check_Employee is not null ) -- проверяет наличие указанного количества единиц товара на складе и существует ли такой номер сотрудника
	   begin 
	        print('There are enough items in stock.');

			declare @TotalPrice as numeric(9,2)= @QTY_ON_HAND * @PriceProduct;  -- расчет суммы заказа
			declare @SumCreditLimit as decimal(9,2);                            -- сумма кредитного лимита компании
   
			select @SumCreditLimit = t2.CREDITLIMIT 
			  from [dbo].[CUSTOMERS] as t2 
			 where t2.CUST_NUМ = @CUST_NUМ 
    
			if(@TotalPrice <= @SumCreditLimit)  -- проверяется если сумма кредитного лимита компании больше или равна сумме заказа 
				begin
				    print('The size of your credit limit allows you to place an order.');

					Begin transaction

				    -- уменьшается количество единиц товара на складе
					update [dbo].[PRODUCTS]
					   set [QTY_ON_HAND] -= @QTY_ON_HAND      
					 where PRODUCT_ID = @PRODUCT_ID
							and MFR_ID = @MFR_ID
					print('The number of items in stock has been reduced.');

					-- сумма заказа вычитается из кредитного лимита компании
					update [dbo].[CUSTOMERS]
					   set [CREDITLIMIT] -= @TotalPrice  
					 where CUST_NUМ = @CUST_NUМ       
                    print('The order amount is deducted from the company''s credit limit.')

					declare @ORDER_NUМ as int;             
					 select @ORDER_NUМ = max(t1.ORDER_NUМ) + 1                   -- определение номера заказа
					   from [dbo].[ORDERS] as t1;
			 
					--заказ вносится в таблицу заказов
					insert into [dbo].[ORDERS]([ORDER_NUМ], [ORDER_DATE], [CUST], [REP], [MFR], [PRODUCT], [QTY], [AМOUNT])   
					values(@ORDER_NUМ, getdate(), @CUST_NUМ, @EMPL_NUМ, @MFR_ID, @PRODUCT_ID, @QTY_ON_HAND, @TotalPrice);
					print('The order is entered in the table of orders.')

					-- сумма текущих продаж служащего увеличивается на сумму заказа
					update [dbo].[SALESREPS]
					   set [SALES] += @TotalPrice
					 where [EMPL_NUМ] = @EMPL_NUМ
					print('The amount of the employee''s current sales is increased by the amount of the order.')
			
					-- сумма текущих продаж офиса данного служащего, увеличивается на сумму заказа
					update [dbo].[OFFICES]
					   set [SALES] += @TotalPrice
					 where [OFFICE] = (
									select t2.REPOFFICE
									  from [dbo].[SALESREPS] as t2
									 where [EMPL_NUМ] = @EMPL_NUМ
									)

					commit transaction

                    print('The amount of current sales of this employee''s office, increased by the amount of the order.')
					set @ERROR_STATUS = 1;
				end
				else
				print('The size of your credit limit doesn''t allow you to place an order.');
	   end
	   else
		   begin
		   if(@QTY < @QTY_ON_HAND)
			  print('There are not enough items in stock.');
		   if(@Check_Employee is null)
		      print('There is no employee with this ID.');
		   end

	   if @ERROR_STATUS = 1
	      print('Procedure was successful.')
	   else
		  print('Procedure was not successful.')
	   
end

execute [dbo].[ADD_NEW_ORDER] 2102, 110, N'ACI', N'41002', 1