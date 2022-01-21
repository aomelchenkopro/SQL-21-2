/*
Напишите запрос, который возвращает наименование должности (в верхнем регистре и без пробелов в начале строки) 
с наибольшим количеством работников не проводивших продажи на товары цвета Black в 2013 году
- Используются таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- Рез. набор данных содержит: наименование должности (в верхнем регистре и без пробелов в начале строки), кол-во работников
*/

select top 1 
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