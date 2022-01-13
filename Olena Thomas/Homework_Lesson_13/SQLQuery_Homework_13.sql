/*"Задача №1
Напишите запрос, который возвращает наименование должности (в верхнем регистре и без пробелов в начале строки) 
с наибольшим количеством работников не проводивших продажи на товары цвета Black в 2013 году
- Используются таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- Рез. набор данных содержит: наименование должности (в верхнем регистре и без пробелов в начале строки), кол-во работников"									
*/

select top 1
       with ties
       upper(ltrim(t1.JobTitle))            as [JobTitle],
	   count(distinct t1.BusinessEntityID)  as [EmpQty]
 from [HumanResources].[Employee]           as t1
 left outer join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                               and t2.OrderDate between '20130101' and '20131231 23:59:59' 
 left outer join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
 left outer join [Production].[Product]     as t4 on t4.ProductID = t3.ProductID
                                               and t4.[Color] != N'Black'
--where t4.ProductID is not null
group by t1.JobTitle
order by [EmpQty] desc
;

