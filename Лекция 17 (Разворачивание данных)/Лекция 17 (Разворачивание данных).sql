/*
Напишите запрос, который для активного (ActiveFlag) производителя с кредитным рейтингом (CreditRating) не более 2 и
имеющего наибольшее количество продуктов класса (Class) H = High и M = Medium, вернет список таких продуктов.
Учитывайте вероятность того, что сразу несколько производителей могут иметь одно и тоже кол-во продуктов.
- Используются таблицы: Purchasing.Vendor, Purchasing.ProductVendor, Production.Product.
  Детальное описание таблиц доступно по ссылке https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/Purchasing_Vendor_177.html
- Задействуйте оператор with
- Не используйте оператор with ties
- Рез. набор данных содержит: идент. производителя, идент. продукта, наименование продукта, цвет продукта, класс продукта
- Отсортировать рез. набор данных по идент. производителя, по идент. товара
*/
-- CTE
with products as 
(
select t1.BusinessEntityID, -- идент. проивзодителя
       t3.ProductID,        -- идент. продукта
	   t3.[Name],           -- наименование продукта
	   t3.Color,            -- цвет продукта
	   t3.Class             -- класс продукта
	   -- Таблица производителей
  from Purchasing.Vendor as t1 
       -- Идент. продуктов каждого отдельного производителя
 inner join Purchasing.ProductVendor as t2 on t2.BusinessEntityID = t1.BusinessEntityID
       -- Хранит информацию продуктов
 inner join Production.Product as t3 on t3.ProductID = t2.ProductID
                                     -- Продукты класса High Medium
                                    and t3.Class in (N'H', N'M')
 where -- Кредитный рейтинг не более двух
       t1.CreditRating  <= 2
    -- Активный производитель
   and t1.ActiveFlag = 1
)
-- Рез. набор данных
select * 
  from products as t3
 where t3.BusinessEntityID in (
                                -- Идент. производителей с наибольшим количеством продуктов
								select t2.BusinessEntityID
								  from products as t2 
								 group by t2.BusinessEntityID
								having count(distinct t2.ProductID) = (
								                                        -- Наибольшее кол-во продуктов в разрезе производителя
																		select top 1 
																				count(distinct t1.ProductID) as [pQty] -- кол-во уникальных идент. продуктов
																			from products as t1
																			group by t1.BusinessEntityID
																			order by [pQty] desc
																	   )
								)
order by t3.BusinessEntityID, 
         t3.ProductID
;
--==============================================================================================================================================
with products as 
(
select t1.BusinessEntityID, -- идент. проивзодителя
       t3.ProductID,        -- идент. продукта
	   t3.[Name],           -- наименование продукта
	   t3.Color,            -- цвет продукта
	   t3.Class             -- класс продукта
	   -- Таблица производителей
  from Purchasing.Vendor as t1 
       -- Идент. продуктов каждого отдельного производителя
 inner join Purchasing.ProductVendor as t2 on t2.BusinessEntityID = t1.BusinessEntityID
       -- Хранит информацию продуктов
 inner join Production.Product as t3 on t3.ProductID = t2.ProductID
                                     -- Продукты класса High Medium
                                    and t3.Class in (N'H', N'M')
 where -- Кредитный рейтинг не более двух
       t1.CreditRating  <= 2
    -- Активный производитель
   and t1.ActiveFlag = 1
)
-- Рез. набор данных
select top 1
       with ties
       * 
  from products as t3
 order by count(t3.ProductID)over(partition by t3.BusinessEntityID) desc
;
--==============================================================================================================================================
-- Разворачивание данных
select t1.CustomerID, -- Идент. клиента - Customer identification number. Foreign key to Customer.BusinessEntityID.
       convert(date, t1.OrderDate) as [OrderDate]
  from [Sales].[SalesOrderHeader] as t1
;

-- select * from [Sales].[SalesOrderHeader] as t1;

select distinct 
        convert(date, t1.OrderDate) as [orderDate]
  from [Sales].[SalesOrderHeader] as t1
 where t1.OrderDate between '20110601' and '20110630'
  order by [orderDate]


  select distinct 
        t1.CustomerID
  from [Sales].[SalesOrderHeader] as t1
  order by t1.CustomerID
--==============================================================================================================================================
-- Разворачивание данных с использованием стандартных средств. Оператор case
select t1.CustomerID, -- идент. клиента
       count(/*distinct*/ case t1.OrderDate when '20110601' then t1.SalesOrderID end ) as [20110601],
	   count(distinct case t1.OrderDate when '20110602' then t1.SalesOrderID end )     as [20110602],
	   count(distinct case t1.OrderDate when '20110603' then t1.SalesOrderID end )     as [20110603],
	   count(distinct case t1.OrderDate when '20110604' then t1.SalesOrderID end )     as [20110604],
	   count(distinct case t1.OrderDate when '20110605' then t1.SalesOrderID end ) as [20110605],
	   count(distinct case t1.OrderDate when '20110606' then t1.SalesOrderID end ) as [20110606],
	   count(distinct case t1.OrderDate when '20110607' then t1.SalesOrderID end ) as [20110607],
	   count(distinct case t1.OrderDate when '20110608' then t1.SalesOrderID end ) as [20110608],
	   count(distinct case t1.OrderDate when '20110609' then t1.SalesOrderID end ) as [20110609],
	   count(distinct case t1.OrderDate when '20110610' then t1.SalesOrderID end ) as [20110610]
  from [Sales].[SalesOrderHeader] as t1
 where t1.OrderDate between '20110601' and '20110630'
 group by t1.CustomerID
 order by t1.CustomerID asc
;

-- SalesOrderID


--==============================================================================================================================================
-- Разворачивание данных с помощью встроенных средств SQL Server оператор Pivot
select *
  from (-- Заворачиваем данный запрос в другой для работы с оператором pivot
			select t1.CustomerID,
				   convert(date, t1.OrderDate) as [orderDate],
				   t1.SalesOrderID
			  from [Sales].[SalesOrderHeader] as t1
			 where t1.OrderDate between '20110601' and '20110630'
       ) as p
	   pivot 
	   (
	    count(SalesOrderID) for [orderDate] in ( [2011-06-02], [2011-06-01], [2011-06-03], [2011-06-04],
		[2011-06-05], [2011-06-06], [2011-06-07], [2011-06-08], [2011-06-09], [2011-06-10], [2011-06-11],
		[2011-06-12], [2011-06-13], [2011-06-14], [2011-06-15], [2011-06-16], [2011-06-17], [2011-06-18],
		[2011-06-19], [2011-06-20], [2011-06-21], [2011-06-22], [2011-06-23], [2011-06-24], [2011-06-25],
		[2011-06-26], [2011-06-27], [2011-06-28], [2011-06-29], [2011-06-30])
	   ) as [pivot]
;
--==============================================================================================================================================
-- Переменные 
declare @count int;
    set @count = 0;

go
declare @count as int = 0;
select @count
/*
go -- Команда SSMS для разделения одного пакета на несколько
declare @count as int = 0;
select @count
*/

declare @orderDate datetime;
    set @orderDate = (
						select t1.OrderDate
						  from [Sales].[SalesOrderHeader] as t1
						 where t1.SalesOrderID = 43661
					 )

declare @custId as int;
   set @custId  = (
						select t1.CustomerID
						  from [Sales].[SalesOrderHeader] as t1
						 where t1.SalesOrderID = 43661
					 )

select @orderDate, @custId
GO

declare @orderDate as datetime, 
        @custId  as int;

select @orderDate = t1.OrderDate, 
       @custId = t1.CustomerID
  from [Sales].[SalesOrderHeader] as t1
 -- where t1.SalesOrderID = 43661

select @orderDate, @custId;
--==============================================================================================================================================
declare @count as int = 0;
while @count < 100
	begin
		select 'T-SQL';

		set @count += 1;
    end
--==============================================================================================================================================
go
declare @result as table 
(
 grade int, -- группа
 qty   int  -- кол-во

);
-----------------------------------------
declare @count as int = 5000;
while @count <= 500000
	begin
		insert into @result (grade)
		values (@count);

		set @count += 5000;
    end
-----------------------------------------
update t3
   set t3.qty = (--
					select count(distinct t2.CustomerID)
					  from (
							-- Общая сумма заказов клиента за все время
							select t1.CustomerID,              -- идент. клиента
								   sum(t1.SubTotal) as [total] -- общая сумма за все время
							  from [Sales].[SalesOrderHeader] as t1
							 group by t1.CustomerID
							-- Корреляция
							having sum(t1.SubTotal) > t3.grade
							) as t2

                )--
  from @result as t3
;

select *
  from @result
--==============================================================================================================================================
-- Курсор
-- Переменная для хранения промежуточных данных т.к. дата проведения заказ
declare @curDate as date;
declare @dynamicSQL as nvarchar(max);
    set @dynamicSQL = N'select *
						  from (
									select t1.CustomerID,
										   convert(date, t1.OrderDate) as [orderDate],
										   t1.SalesOrderID
									  from [Sales].[SalesOrderHeader] as t1
									 where t1.OrderDate between ''20110601'' and ''20110630''
							   ) as p
							   pivot 
							   (
								count(SalesOrderID) for [orderDate] in (';

-- Объявление курсора
declare cur cursor for	
select distinct 
       convert(date, t1.OrderDate) as [orderDate]
  from [Sales].[SalesOrderHeader] as t1
 where t1.OrderDate between '20110601' and '20110630'
 order by [orderDate] asc
;

-- Открытие курсора
open cur;

-- Прокручивание курсора на первую строку
fetch next from cur into @curDate;
set @dynamicSQL = CONCAT(@dynamicSQL, N'[', @curDate, N'] ')

-- @@FETCH_STATUS возвращает состояние последней инструкции FETCH
while @@FETCH_STATUS = 0
	begin

		fetch next from cur into @curDate;

		if @@FETCH_STATUS = 0
		set @dynamicSQL = CONCAT(@dynamicSQL, N', [', @curDate, N'] ')

	end 
-- Закрытие курсора
close cur;

-- Освободить курсор
deallocate cur;

set  @dynamicSQL = concat(@dynamicSQL, ' )) as [pivot]')

print(@dynamicSQL)

execute sp_executesql @dynamicSQL
-- execute (@dynamicSQL)
--==============================================================================================================================================
GO
-- Динамический SQL
declare @dynamicSQL as nvarchar(150) = 'select getdate()';
print @dynamicSQL
execute sp_executesql @dynamicSQL
--==============================================================================================================================================



--==============================================================================================================================================
