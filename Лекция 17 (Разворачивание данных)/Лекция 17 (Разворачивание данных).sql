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
	   count(distinct case t1.OrderDate when '20110605' then t1.SalesOrderID end )     as [20110605],
	   count(distinct case t1.OrderDate when '20110606' then t1.SalesOrderID end )     as [20110606],
	   count(distinct case t1.OrderDate when '20110607' then t1.SalesOrderID end )     as [20110607],
	   count(distinct case t1.OrderDate when '20110608' then t1.SalesOrderID end )     as [20110608],
	   count(distinct case t1.OrderDate when '20110609' then t1.SalesOrderID end )     as [20110609],
	   count(distinct case t1.OrderDate when '20110610' then t1.SalesOrderID end )     as [20110610]
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
-- Елена
select t1.JobTitle, 
       count(case t1.HireDate when '20081201' then t1.[BusinessEntityID] end) as [20081201], 
    count(case t1.HireDate when '20081202' then t1.[BusinessEntityID] end) as [20081202], 
    count(case t1.HireDate when '20081203' then t1.[BusinessEntityID] end) as [20081203], 
    count(case t1.HireDate when '20081204' then t1.[BusinessEntityID] end) as [20081204], 
    count(case t1.HireDate when '20081205' then t1.[BusinessEntityID] end) as [20081205], 
    count(case t1.HireDate when '20081206' then t1.[BusinessEntityID] end) as [20081206], 
    count(case t1.HireDate when '20081207' then t1.[BusinessEntityID] end) as [20081207], 
    count(case t1.HireDate when '20081208' then t1.[BusinessEntityID] end) as [20081208], 
    count(case t1.HireDate when '20081209' then t1.[BusinessEntityID] end) as [20081209], 
    count(case t1.HireDate when '20081210' then t1.[BusinessEntityID] end) as [20081210], 
    count(case t1.HireDate when '20081211' then t1.[BusinessEntityID] end) as [20081211], 
    count(case t1.HireDate when '20081212' then t1.[BusinessEntityID] end) as [20081212], 
    count(case t1.HireDate when '20081213' then t1.[BusinessEntityID] end) as [20081213], 
    count(case t1.HireDate when '20081214' then t1.[BusinessEntityID] end) as [20081214], 
    count(case t1.HireDate when '20081215' then t1.[BusinessEntityID] end) as [20081215], 
    count(case t1.HireDate when '20081216' then t1.[BusinessEntityID] end) as [20081216], 
    count(case t1.HireDate when '20081217' then t1.[BusinessEntityID] end) as [20081217], 
    count(case t1.HireDate when '20081218' then t1.[BusinessEntityID] end) as [20081218], 
    count(case t1.HireDate when '20081219' then t1.[BusinessEntityID] end) as [20081219], 
    count(case t1.HireDate when '20081220' then t1.[BusinessEntityID] end) as [20081220], 
    count(case t1.HireDate when '20081221' then t1.[BusinessEntityID] end) as [20081221], 
    count(case t1.HireDate when '20081222' then t1.[BusinessEntityID] end) as [20081222], 
    count(case t1.HireDate when '20081223' then t1.[BusinessEntityID] end) as [20081223], 
    count(case t1.HireDate when '20081224' then t1.[BusinessEntityID] end) as [20081224], 
    count(case t1.HireDate when '20081225' then t1.[BusinessEntityID] end) as [20081225], 
    count(case t1.HireDate when '20081226' then t1.[BusinessEntityID] end) as [20081226], 
    count(case t1.HireDate when '20081227' then t1.[BusinessEntityID] end) as [20081227], 
    count(case t1.HireDate when '20081228' then t1.[BusinessEntityID] end) as [20081228], 
    count(case t1.HireDate when '20081229' then t1.[BusinessEntityID] end) as [20081229], 
    count(case t1.HireDate when '20081230' then t1.[BusinessEntityID] end) as [20081230] 
  from [HumanResources].[Employee] as t1 
  where t1.HireDate between '20081201' and '20081231' 
  group by t1.JobTitle 
  order by t1.JobTitle asc
;
--=========================================================================================================================================================
-- Анастасия
select t1.JobTitle, 
    count(distinct case t1.HireDate when '20081201'then t1.BusinessEntityID end)     as [2008-12-01], 
    count(distinct case t1.HireDate when '20081202'then t1.BusinessEntityID end)     as [2008-12-02], 
    count(distinct case t1.HireDate when '20081203'then t1.BusinessEntityID end)     as [2008-12-03], 
    count(distinct case t1.HireDate when '20081204'then t1.BusinessEntityID end)     as [2008-12-04], 
    count(distinct case t1.HireDate when '20081205'then t1.BusinessEntityID end)     as [2008-12-05], 
    count(distinct case t1.HireDate when '20081206'then t1.BusinessEntityID end)     as [2008-12-06], 
    count(distinct case t1.HireDate when '20081207'then t1.BusinessEntityID end)     as [2008-12-07], 
    count(distinct case t1.HireDate when '20081208'then t1.BusinessEntityID end)     as [2008-12-08], 
    count(distinct case t1.HireDate when '20081209'then t1.BusinessEntityID end)     as [2008-12-09], 
    count(distinct case t1.HireDate when '20081210'then t1.BusinessEntityID end)     as [2008-12-10], 
    count(distinct case t1.HireDate when '20081211'then t1.BusinessEntityID end)     as [2008-12-11], 
    count(distinct case t1.HireDate when '20081212'then t1.BusinessEntityID end)     as [2008-12-12], 
    count(distinct case t1.HireDate when '20081213'then t1.BusinessEntityID end)     as [2008-12-13], 
    count(distinct case t1.HireDate when '20081214'then t1.BusinessEntityID end)     as [2008-12-14], 
    count(distinct case t1.HireDate when '20081215'then t1.BusinessEntityID end)     as [2008-12-15], 
    count(distinct case t1.HireDate when '20081216'then t1.BusinessEntityID end)     as [2008-12-16], 
    count(distinct case t1.HireDate when '20081217'then t1.BusinessEntityID end)     as [2008-12-17], 
    count(distinct case t1.HireDate when '20081218'then t1.BusinessEntityID end)     as [2008-12-18], 
    count(distinct case t1.HireDate when '20081219'then t1.BusinessEntityID end)     as [2008-12-19], 
    count(distinct case t1.HireDate when '20081220'then t1.BusinessEntityID end)     as [2008-12-20], 
    count(distinct case t1.HireDate when '20081221'then t1.BusinessEntityID end)     as [2008-12-21], 
    count(distinct case t1.HireDate when '20081222'then t1.BusinessEntityID end)     as [2008-12-22], 
    count(distinct case t1.HireDate when '20081223'then t1.BusinessEntityID end)     as [2008-12-23], 
    count(distinct case t1.HireDate when '20081224'then t1.BusinessEntityID end)     as [2008-12-24], 
    count(distinct case t1.HireDate when '20081225'then t1.BusinessEntityID end)     as [2008-12-25], 
    count(distinct case t1.HireDate when '20081226'then t1.BusinessEntityID end)     as [2008-12-26], 
    count(distinct case t1.HireDate when '20081227'then t1.BusinessEntityID end)     as [2008-12-27], 
    count(distinct case t1.HireDate when '20081228'then t1.BusinessEntityID end)     as [2008-12-28], 
    count(distinct case t1.HireDate when '20081229'then t1.BusinessEntityID end)     as [2008-12-29], 
    count(distinct case t1.HireDate when '20081230'then t1.BusinessEntityID end)     as [2008-12-30], 
    count(distinct case t1.HireDate when '20081231'then t1.BusinessEntityID end)     as [2008-12-31] 
    from [HumanResources].[Employee] as t1 
   where t1.HireDate between '20081201' and '20081231' 
group by t1.JobTitle 
order by t1.JobTitle asc

--=========================================================================================================================================================
select t1.JobTitle, -- идент. клиента
           count(distinct (case  when t1.HireDate between '20091201' and '20091231' then t1.BusinessEntityID end)) as [200912],
         count(distinct (case when t1.HireDate between  '20091101' and '20091130' then  t1.BusinessEntityID end)) as[200911],
       count(distinct (case t1.HireDate when '20091001' then t1.BusinessEntityID end)) as[20091001],
           count(distinct (case t1.HireDate when '20090901' then t1.BusinessEntityID end)) as[20090901],
           count(distinct (case t1.HireDate when '20090801' then t1.BusinessEntityID end)) as[20090801],
       count(distinct (case t1.HireDate when '20090701' then t1.BusinessEntityID end)) as[20090701],
       count(distinct (case t1.HireDate when '20090601' then t1.BusinessEntityID end)) as[20090601],
       count(distinct (case t1.HireDate when '20090501' then t1.BusinessEntityID end)) as[20090501],
       count(distinct (case t1.HireDate when '20090401' then t1.BusinessEntityID end)) as[20090401]
  from [HumanResources].[Employee] as t1
 where t1.HireDate between '20091201' and '20100101'
 group by t1.JobTitle
 order by t1.JobTitle asc
;