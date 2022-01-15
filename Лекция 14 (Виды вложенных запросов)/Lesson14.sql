/*
«адача є1
Ќапишите запрос, который возвращает наименование должности (в верхнем регистре и без пробелов в начале строки) 
с наибольшим количеством работников не проводивших продажи на товары цвета Black в 2013 году
- »спользуютс€ таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- –ез. набор данных содержит: наименование должности (в верхнем регистре и без пробелов в начале строки), кол-во работников
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
-- «апрос (черновик), который возвращает список работников Ќ≈ проводивших заказы на товары цвета Black в 2013 году
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
  -- “аблица #employee хранит список работников, которые проводили заказы на товары цвета Black в 2013 году
  inner join #employee as t5 on t5.BusinessEntityID = t1.BusinessEntityID
 where t4.ProductID is null
;

--======================================================================================================================================
if object_id('[tempdb].[dbo].#employee2') is not null drop table #employee2;
select /*
       top 1 
       with ties
       upper(ltrim(t4.JobTitle))           as [jobTitle],
       count(distinct t4.BusinessEntityID) as [EmpQty]
	   */
	   distinct 
	   t4.BusinessEntityID
  into #employee2
  from [Production].[Product]          as t1
 inner join [Sales].[SalesOrderDetail] as t2 on t2.ProductID = t1.ProductID
                                            and t1.Color = N'Black'
 inner join [Sales].[SalesOrderHeader] as t3 on t3.SalesOrderID = t2.SalesOrderID
                                            and t3.OrderDate between '20130101' and '20131231 23:59:59'
 right outer join [HumanResources].[Employee] as t4 on t4.BusinessEntityID = t3.SalesPersonID
 where t3.SalesOrderID is null
 ;

 -- group by upper(ltrim(t4.JobTitle))
--  order by [EmpQty] desc;

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