-- UNION
-- UNION ALL
-- INTERSECT
-- EXCEPT


-- UNION
-- 93 строки
select p.[NAME],
       p.ProductNumber
  from [Production].[Product] as p
 where p.Color = N'Black' 
union
-- 43 строки
select p.[NAME],
       p.ProductNumber
  from [Production].[Product] as p
 where p.Color = N'Silver' 
;

-- 84 строки 
select e.JobTitle,
       e.BirthDate
  from [HumanResources].[Employee] as e
 where e.Gender = N'F'
union all
-- 206 строк
select e.JobTitle,
       e.BirthDate
  from [HumanResources].[Employee] as e
 where e.Gender = N'M'

 --=======================================================================================================================================
 -- INTERSECT
 -- 84 строки 
select e.JobTitle
  from [HumanResources].[Employee] as e
 where e.Gender = N'F'
INTERSECT
-- 206 строк
select e.JobTitle
  from [HumanResources].[Employee] as e
 where e.Gender = N'M'
 --=======================================================================================================================================
 -- EXCEPT
 select e.JobTitle
  from [HumanResources].[Employee] as e
 where e.Gender = N'F'
EXCEPT
-- 206 строк
select e.JobTitle
  from [HumanResources].[Employee] as e
 where e.Gender = N'M'
 --=======================================================================================================================================
 -- Оптимизация запросов

 -- Create a clustered index on a table and use a 3-part name for the table
CREATE UNIQUE CLUSTERED INDEX index1 ON database1.schema1.table1 (column1);

 -- Create a nonclustered
CREATE UNIQUE NONCLUSTERED INDEX index1 ON database1.schema1.table1 (column1);


select * 
  from [HumanResources].[Employee] as t1 
 where t1.BusinessEntityID = 2
;
--=======================================================================================================================================
select t1.*
  from [HumanResources].[Employee] as t1
 where t1.NationalIDNumber = N'24756624';
--=======================================================================================================================================
-- CREATE UNIQUE NONCLUSTERED INDEX index_nationalidnumber ON [dbo].[Employeenonclustered] (NationalIDNumber);
select t1.*
  from [dbo].[Employeenonclustered] as t1
 where t1.NationalIDNumber = N'24756624'; 

 select t1.*
  from [dbo].[Employeenonclustered] as t1
 where right(t1.NationalIDNumber, 5) = N'56624';

  select t1.*
  from [dbo].[Employeenonclustered] as t1
 where t1.NationalIDNumber like N'%56624'
 
-- Проблема скрытых не явных преобразований типов данных
-- Проблема утери индекса при работе с вычисляемыми выражениями
--=======================================================================================================================================
-- Кол-во уникальных заказов в разрезе должности
select t1.JobTitle,                                  -- наименование должности 
       count(distinct t2.SalesOrderID) as [orderQty] -- кол-во уникальных заказов
  from [HumanResources].[Employee] as t1
  inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                                  and year(t2.OrderDate) = 2013 
  inner join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
  inner join [Production].[Product] as t4 on t4.ProductID = t3.ProductID
                                              and t4.Color in ('Black', 'Silver')
 where t1.Gender = N'M'
   and t1.MaritalStatus = N'M'
 group by t1.JobTitle
 order by [orderQty] desc
;
--=======================================================================================================================================
SELECT DISTINCT 
       T1.JOBTITLE, T2.SALESORDERID,
       T2.ORDERDATE, T3.SALESORDERDETAILID,
	   T4.[NAME],T4.COLOR
  FROM [HUMANRESOURCES].[EMPLOYEE] AS T1
  INNER JOIN [SALES].[SALESORDERHEADER] AS T2 ON T2.SALESPERSONID = T1.BUSINESSENTITYID AND YEAR(T2.ORDERDATE) = 2013 
  INNER JOIN [SALES].[SALESORDERDETAIL] AS T3 ON T3.SALESORDERID = T2.SALESORDERID INNER JOIN [PRODUCTION].[PRODUCT] AS T4 ON T4.PRODUCTID = T3.PRODUCTID
    AND T4.COLOR IN ('BLACK', 'SILVER')
 WHERE T1.GENDER = 'M' AND T1.MARITALSTATUS = 'M'
   AND T1.JOBTITLE IN (SELECT DISTINCT T1.JOBTITLE
						  FROM [HUMANRESOURCES].[EMPLOYEE] AS T1 INNER JOIN [SALES].[SALESORDERHEADER] AS T2 ON T2.SALESPERSONID = T1.BUSINESSENTITYID AND YEAR(T2.ORDERDATE) = 2013 
						  INNER JOIN [SALES].[SALESORDERDETAIL] AS T3 ON T3.SALESORDERID = T2.SALESORDERID INNER JOIN [PRODUCTION].[PRODUCT] AS T4 ON T4.PRODUCTID = T3.PRODUCTID
						AND T4.COLOR IN ('BLACK', 'SILVER')
						 WHERE T1.GENDER = 'M'
						   AND T1.MARITALSTATUS = 'M'
						 GROUP BY T1.JOBTITLE HAVING COUNT(DISTINCT T2.SALESORDERID) = (SELECT DISTINCT  TOP 1
		COUNT(DISTINCT T2.SALESORDERID) AS [ORDERQTY] 
	FROM [HUMANRESOURCES].[EMPLOYEE] AS T1 INNER JOIN [SALES].[SALESORDERHEADER] AS T2 ON T2.SALESPERSONID = T1.BUSINESSENTITYID
AND YEAR(T2.ORDERDATE) = 2013 
	INNER JOIN [SALES].[SALESORDERDETAIL] AS T3 ON T3.SALESORDERID = T2.SALESORDERID  INNER JOIN [PRODUCTION].[PRODUCT] AS T4 ON T4.PRODUCTID = T3.PRODUCTID
	AND T4.COLOR IN ('BLACK', 'SILVER')
	WHERE T1.GENDER = 'M'
	AND T1.MARITALSTATUS = 'M' GROUP BY T1.JOBTITLE
	ORDER BY [ORDERQTY] DESC))
ORDER BY T1.JOBTITLE ASC,
         T2.ORDERDATE
;

--=======================================================================================================================================
with orders as
(
select t1.JobTitle, 
       t2.SalesOrderID,
       t2.OrderDate,
	   t3.SalesOrderDetailID,
	   t4.[Name],
	   t4.Color
  from [HumanResources].[Employee] as t1
  inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                                  and t2.OrderDate between '20130101' and '20131231 23:59:59'
  inner join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
  inner join [Production].[Product] as t4 on t4.ProductID = t3.ProductID
                                              and t4.Color in (N'Black', N'Silver')
 where t1.Gender = N'M'
   and t1.MaritalStatus = N'M'
) 
select t3.* 
  from orders as t3
 where t3.JobTitle in ( -- Наименование должности с наибольшим количеством искомых заказов
						select t2.JobTitle
							from orders as t2
							group by t2.JobTitle
						having count(distinct t2.SalesOrderID) = (  -- Наибольшее кол-во заказов (в разрезе должности), которые были проведены в 2013 году, женатыми работниками
																	-- мужского пола. Учитываем только заказы, в которых есть товары цвета Black и Silver
																	select top 1
																			count(distinct t1.SalesOrderID) as [orderQty] 
																		from orders as t1
																		group by t1.JobTitle
																		order by [orderQty] desc
																	)
                      )
;
--=======================================================================================================================================
declare @orders table(
        [JobTitle] nvarchar(50),
        [SalesOrderID] int,
        [OrderDate] datetime,
        [SalesOrderDetailID] int,
        [Name] nvarchar(50),
        [Color] nvarchar(15)
);

insert into @orders
select t1.JobTitle, 
       t2.SalesOrderID,
       t2.OrderDate,
	   t3.SalesOrderDetailID,
	   t4.[Name],
	   t4.Color
  from [HumanResources].[Employee] as t1
  inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                                  and t2.OrderDate between '20130101' and '20131231 23:59:59'
  inner join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
  inner join [Production].[Product] as t4 on t4.ProductID = t3.ProductID
                                              and t4.Color in (N'Black', N'Silver')
 where t1.Gender = N'M'
   and t1.MaritalStatus = N'M'
;

select t3.* 
  from @orders as t3
 where t3.JobTitle in ( -- Наименование должности с наибольшим количеством искомых заказов
						select t2.JobTitle
							from @orders as t2
							group by t2.JobTitle
						having count(distinct t2.SalesOrderID) = (  -- Наибольшее кол-во заказов (в разрезе должности), которые были проведены в 2013 году, женатыми работниками
																	-- мужского пола. Учитываем только заказы, в которых есть товары цвета Black и Silver
																	select top 1
																			count(distinct t1.SalesOrderID) as [orderQty] 
																		from @orders as t1
																		group by t1.JobTitle
																		order by [orderQty] desc
																	)
                      )
;

--=======================================================================================================================================
if object_id('[tempdb].[dbo].#orders') is not null drop table #orders;
--if object_id('[tempdb].[dbo].##orders') is not null drop table ##orders;
select t1.JobTitle, 
       t2.SalesOrderID,
       t2.OrderDate,
	   t3.SalesOrderDetailID,
	   t4.[Name],
	   t4.Color
  into #orders
  from [HumanResources].[Employee] as t1
  inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                                  and t2.OrderDate between '20130101' and '20131231 23:59:59'
  inner join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
  inner join [Production].[Product] as t4 on t4.ProductID = t3.ProductID
                                              and t4.Color in (N'Black', N'Silver')
 where t1.Gender = N'M'
   and t1.MaritalStatus = N'M'
;

select t3.* 
  from #orders as t3
 where t3.JobTitle in ( -- Наименование должности с наибольшим количеством искомых заказов
						select t2.JobTitle
							from #orders as t2
							group by t2.JobTitle
						having count(distinct t2.SalesOrderID) = (  -- Наибольшее кол-во заказов (в разрезе должности), которые были проведены в 2013 году, женатыми работниками
																	-- мужского пола. Учитываем только заказы, в которых есть товары цвета Black и Silver
																	select top 1
																			count(distinct t1.SalesOrderID) as [orderQty] 
																		from #orders as t1
																		group by t1.JobTitle
																		order by [orderQty] desc
																	)
                      )
;
