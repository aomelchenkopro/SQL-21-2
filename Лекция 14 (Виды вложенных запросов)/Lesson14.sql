/*
Задача №1
Напишите запрос, который возвращает наименование должности (в верхнем регистре и без пробелов в начале строки) 
с наибольшим количеством работников не проводивших продажи на товары цвета Black в 2013 году
- Используются таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- Рез. набор данных содержит: наименование должности (в верхнем регистре и без пробелов в начале строки), кол-во работников
*/
--======================================================================================================================================
if object_id('[tempdb].[dbo].#employee') is not null drop table #employee;
select distinct  
       t1.BusinessEntityID
  into #employee
  from [HumanResources].[Employee] as t1 
 inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                            and t2.OrderDate between '20130101' and '20131231 23:59:59'
 inner join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
 inner join [Production].[Product] as t4 on t4.ProductID = t3.ProductID
                                        and t4.Color = N'Black'
 order by t1.BusinessEntityID
;
-- select * from #employee;
--======================================================================================================================================
-- Запрос (черновик), который возвращает список работников НЕ проводивших заказы на товары цвета Black в 2013 году
select t1.BusinessEntityID,
       t2.SalesOrderID,
	   t3.SalesOrderDetailID,
	   t4.ProductID,
	   t4.Color
  from [HumanResources].[Employee] as t1
  left outer join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                                  and t2.OrderDate between '20130101' and '20131231 23:59:59'
  left outer join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
  left outer join [Production].[Product] as t4 on t4.ProductID = t3.ProductID
                                        and t4.Color = N'Black'
  -- Таблица #employee хранит список работников, которые проводили заказы на товары цвета Black в 2013 году
  inner join #employee as t5 on t5.BusinessEntityID = t1.BusinessEntityID
 where t4.ProductID is null
;

--======================================================================================================================================
if object_id('[tempdb].[dbo].#employee2') is not null drop table #employee2;
select 
       top 1 
       with ties
       upper(ltrim(t4.JobTitle))           as [jobTitle],
       count(distinct t4.BusinessEntityID) as [EmpQty]
	  
	 
 
  from [Production].[Product]          as t1
 inner join [Sales].[SalesOrderDetail] as t2 on t2.ProductID = t1.ProductID
                                            and t1.Color = N'Black'
 inner join [Sales].[SalesOrderHeader] as t3 on t3.SalesOrderID = t2.SalesOrderID
                                            and t3.OrderDate between '20130101' and '20131231 23:59:59'
 right outer join [HumanResources].[Employee] as t4 on t4.BusinessEntityID = t3.SalesPersonID
 where t3.SalesOrderID is null


 group by upper(ltrim(t4.JobTitle))
 order by [EmpQty] desc;

select distinct 
       t1.BusinessEntityID,
       t2.OrderDate,
	   t4.Color
  from #employee2  as t1
  inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID  = t1.BusinessEntityID
  inner join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
  inner join [Production].[Product]  as t4 on t4.ProductID = t3.ProductID
 where t1.BusinessEntityID = 285
 order by 2
--======================================================================================================================================

/*"Задача №1
Напишите запрос, который возвращает наименование должности (в верхнем регистре и без пробелов в начале строки) 
с наибольшим количеством работников не проводивших продажи на товары цвета Black в 2013 году
- Используются таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- Рез. набор данных содержит: наименование должности (в верхнем регистре и без пробелов в начале строки), кол-во работников"									
*/

select distinct
      t1.BusinessEntityID
 from [HumanResources].[Employee]           as t1
 left outer join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                               and t2.OrderDate between '20130101' and '20131231 23:59:59' 
 left outer join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
 left outer join [Production].[Product]     as t4 on t4.ProductID = t3.ProductID
                                               and t4.[Color] != N'Black'
--where t4.ProductID is not null
group by t1.JobTitle
;
--======================================================================================================================================
--------------------------------------------------- Вложенные запросы-------------------------------------------------------------------
select t1.* 
  from [HumanResources].[Employee] as t1 
 where t1.BirthDate = (-- Автономный вложенный скалярный гарантируемый запрос
                       select min(t2.BirthDate)
                         from [HumanResources].[Employee] as t2)
;

select t1.* 
  from [HumanResources].[Employee] as t1 
 where t1.BirthDate = (-- Автономный вложенный скалярный гарантируемый запрос
                       select min(t2.BirthDate)
                         from [HumanResources].[Employee] as t2)
;

select t1.*
  from [Sales].[SalesOrderHeader] as t1
 where t1.SalesPersonID = (-- Автономный вложенный скалярный НЕ гарантируемый запрос
                           select t1.BusinessEntityID
                             from [HumanResources].[Employee] as t1
							where t1.JobTitle = N'Accounts Manager')
;
  
--======================================================================================================================================
-- Вложенный табличный (1 столбец) автономный запрос
select t3.*
  from [HumanResources].[Employee]  as t3
 where t3.JobTitle in (
						select top 1
							   with ties
							   t1.JobTitle
						  from [HumanResources].[Employee]  as t1 
						 group by t1.JobTitle
						 order by count(distinct t1.BusinessEntityID) desc )
;
--------------------------------------------------------------------------------------------
select t3.*
  from [HumanResources].[Employee]  as t3
 where t3.JobTitle in ( -- Наименования должностей с наибольшим количеством работников
						select t2.JobTitle
						  from [HumanResources].[Employee]  as t2 
						 group by t2.JobTitle
						having count(distinct t2.BusinessEntityID) = (  -- Наибольшее кол-во работников
																		select top 1
	                                                                           count(distinct t1.BusinessEntityID) as [empQty]
                                                                          from [HumanResources].[Employee]  as t1 
                                                                         group by t1.JobTitle
                                                                         order by count(distinct t1.BusinessEntityID) desc
																	  )
						)
order by t3.JobTitle, 
         t3.HireDate desc;
--------------------------------------------------------------------------------------------
-- Обобщенное табличное выражение
select t2.*
  from (
		select t1.BusinessEntityID,
			   t1.JobTitle,
			   t1.HireDate,
			   row_number()over(partition by t1.JobTitle order by t1.HireDate) as [rowNum]
		  from [HumanResources].[Employee] as t1
		) as t2
 where t2.rowNum <= 3;
--------------------------------------------------------------------------------------------
with w (BusinessEntityID, JobTitle, HireDate, [rowNum]) as 
(
select t1.BusinessEntityID,
	   t1.JobTitle,
	   t1.HireDate,
	   row_number()over(partition by t1.JobTitle order by t1.HireDate) as [rowNum]
  from [HumanResources].[Employee] as t1
)
select * 
  from w as t1
 where t1.rowNum <= 3
;
--------------------------------------------------------------------------------------------
[Production].[Product]
[Sales].[SalesOrderDetail]
-- [Sales].[SalesOrderHeader]

-- Анастасия
select top 1
with ties 
t1.ProductID,
count (distinct t2.SalesOrderID) as [orederqty]
from [Production].[Product] as t1
inner join [Sales].[SalesOrderDetail] as t2 on t2.ProductID = t1.ProductID
inner join [Sales].[SalesOrderHeader] as t3 on t3.SalesOrderID =t2.SalesOrderID
group by t1.ProductID
order by count (distinct t2.SalesOrderID) desc

-- Елена
select * 
 from [Production].[Product] as t2 
where t2.ProductID = (select top 1 
  with ties 
  t1.[ProductID] 
 from [Sales].[SalesOrderDetail] as t1 
group by t1.[ProductID] 
order by count(t1.SalesOrderID) desc 
) 
;

-- Дарья
select top 1 
   with ties t1.ProductID, 
    count(t2.SalesOrderID) [Amount_of_order] 
   from [Production].[Product] as t1 
   inner join [Sales].[SalesOrderDetail] as t2 on t2.ProductID = t1.ProductID 
   group by t1.ProductID 
   order by count (t2.SalesOrderID) desc

--Янина
/*
select
count(t1.SalesOrderID) as [MAXQty]
from [Production].[Product] as t2
 where t2.ProductID = ( 
                         select top 1
                         with ties
                          t1.ProductID
                from [Sales].[SalesOrderDetail] as t1
              group by t1.ProductID
              order by [MAXQty] desc;
*/
-- [Production].[Product]
-- [Sales].[SalesOrderDetail]
-- [Sales].[SalesOrderHeader]

with orders (ProductID, SalesOrderID) as 
(
-- Заказы за 2013 год
select t2.ProductID,
       t2.SalesOrderID
  from [Sales].[SalesOrderHeader] as t1
 inner join [Sales].[SalesOrderDetail] as t2 on t2.SalesOrderID = t1.SalesOrderID
 where t1.OrderDate between '20130101' and '20131231 23:59:59.999'
)
,ordersQty(ProductID, [orderQty]) as 
(
select t3.ProductID,
       count(distinct t3.SalesOrderID) as [orderQty]
  from orders as t3
  group by t3.ProductID
),
maxOrderQty (ProductID) as
(
select top 1 
       with ties
       t4.ProductID
  from ordersQty as t4
 order by [orderQty] desc
)
--select * from orders
--select * from ordersQty

select * 
 from [Production].[Product] as t6
where t6.ProductID in (select t5.ProductID 
                         from maxOrderQty as t5);
------------------------------------------------------------------------------------------------------------------------------------
select t3.* 
  from [Production].[Product] as t3
 where t3.ProductID in (
						select top 1
								with ties
								t2.ProductID
							from [Sales].[SalesOrderHeader] as t1
							inner join [Sales].[SalesOrderDetail] as t2 on t2.SalesOrderID = t1.SalesOrderID
							where t1.OrderDate between '20130101' and '20131231 23:59:59.999'
							group by t2.ProductID
							order by count(distinct t2.SalesOrderID) desc )
;
------------------------------------------------------------------------------------------------------------------------------------
select t3.* 
  from [Production].[Product] as t3
 where t3.ProductID not in (
                            select t3.ProductID
							  from (
						    select top 1
							    	with ties
								t2.ProductID
							from [Sales].[SalesOrderHeader] as t1
							inner join [Sales].[SalesOrderDetail] as t2 on t2.SalesOrderID = t1.SalesOrderID
							where t1.OrderDate between '20130101' and '20131231 23:59:59.999'
							group by t2.ProductID
							order by count(distinct t2.SalesOrderID) desc 
						    ) t3

							)
;
------------------------------------------------------------------------------------------------------------------------------------
select t4.* 
  from [Production].[Product] as t4
 where not exists ( --=================================================================================================
                         select t3.*
						   from (
									select top 1
							    			with ties
										t2.ProductID
									from [Sales].[SalesOrderHeader] as t1
									inner join [Sales].[SalesOrderDetail] as t2 on t2.SalesOrderID = t1.SalesOrderID
									where t1.OrderDate between '20130101' and '20131231 23:59:59.999'
									group by t2.ProductID
									order by count(distinct t2.SalesOrderID) desc
							) as t3
						--------------------
						WHERE T3.ProductID = T4.ProductID
						--------------------

				)--=================================================================================================
							
;
--======================================================================================================================================
with w as 
(
select t1.SalesOrderID,
       t1.SalesOrderDetailID,
	   t1.ProductID,
	   t1.LineTotal
  from [Sales].[SalesOrderDetail] as t1
),
w2 as
(
select t2.*,

       (t2.LineTotal/
	   (select sum (t3.LineTotal) 
	      from w as t3
		 where t3.SalesOrderID = t2.SalesOrderID)) * 100 as [dola]
  from w as t2

)
select t3.*
  from w2 as t3
order by 1, 4