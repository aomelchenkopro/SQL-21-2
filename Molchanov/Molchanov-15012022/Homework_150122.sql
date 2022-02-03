/*
Задача №1
Напишите запрос, который возвращает наименование должности (в верхнем регистре и без пробелов в начале строки) 
с наибольшим количеством работников не проводивших продажи на товары цвета Black в 2013 году
- Используются таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- Рез. набор данных содержит: наименование должности (в верхнем регистре и без пробелов в начале строки), кол-во работников									
*/


use [AdventureWorks3];                                                                                    --переключение базы данных
 
select top 1                                                                                              --наибольшее значение
       with ties                                                                                          --с учетом повторений
	   upper (ltrim (t4.[JobTitle])) as [JobTitle],                                                       --наименование должности (в верхнем регистре
	                                                                                                      --и без пробелов в начале строки)
	   count (t4.BusinessEntityID) as [EmpQty]                                                            --кол-во работников	
   from [Production].[Product] as t1
 inner join [Sales].[SalesOrderDetail] as t2 on t2.[ProductID]=t1.[ProductID]
                                            and t1.[Color]   =N'Black'                                    --товары цвета Black
 inner join [Sales].[SalesOrderHeader] as t3 on t3.[SalesOrderID]=t2.[SalesOrderID]
                                            and t3.[OrderDate] between '20130101' and '20131231 23:59:59' --заказ 2013 года
 right outer join [HumanResources].[Employee] as t4 on t4.[BusinessEntityID]=t3.[SalesPersonID]
 where t3.[SalesOrderID] is null                                                                          --исключение заказов с товарами цвета Black 2013 году
 group by upper (ltrim (t4.[JobTitle]))                                                                   --группировка по наименованию должности
 order by [EmpQty] desc                                                                                   --упорядочивание по  кол-ву работников по убыванию
;	