
/*
Задача 1
Напишите запрос возвращающий детали заказа, у которого наибольшее кол-во деталей (позиций).
Учитывайте вероятность того, что сразу несколько заказов могут иметь одно и тоже кол-во деталей.
Рассчитайте долю каждой отдельной детали к общей сумме заказа, в процентном соотношении.
- Используются таблицы: [Sales].[SalesOrderDetail]
- Задействуйте оконно агрегатную функцию sum
- Рез. набор данных содержит: Идент. заказа, идент детали заказа, сумму детали заказа, долю
- Отсортируйте рез. набор данных по идент. заказа, по доле (по убыванию)
*/
with orders as 
(
select t1.SalesOrderID,
       t1.SalesOrderDetailID,
	   t1.LineTotal,
	   t1.LineTotal / sum(t1.LineTotal)over(partition by t1.SalesOrderID) * 100 as [DolaOverSum]
  from [Sales].[SalesOrderDetail] as t1 
)
select t3.SalesOrderID,
       t3.SalesOrderDetailID,
	   t3.LineTotal,
	   t3.[DolaOverSum] 
  from orders as t3 
 where t3.SalesOrderID in (
							select t2.SalesOrderID
							  from orders as t2
							 group by t2.SalesOrderID
							having count(distinct t2.SalesOrderDetailID) = (
																			select top 1
																				   count(distinct t1.SalesOrderDetailID) as [qty]
																			  from orders as t1
																			 group by t1.SalesOrderID
																			 order by [qty] desc )
						  )
order by t3.SalesOrderID, 
         [DolaOverSum] desc
;

go
/*
Задача 2
Напишите запрос, который для работников на должностях
European Sales Manager, North American Sales Manager, Pacific Sales Manager, Sales Representative,
вернет по 3 последних заказа (за все время). Последний заказа определяется по дате заказа (OrderDate) и
по индет. заказа (SalesOrderID). Чем больше дата и идентификатор заказа, тем позднее закал был проведен.
Например, 2014-05-01 00:00:00.000 и 113164 больше чем 2014-05-01 00:00:00.000 и 112471.
Работники на указанных должностях, которые не проводили ни одного заказа остаются самом конце рез. набора данных.
Исключить из выборки сотрудников, которые проводили заказы (за все время) на товары с номерами (ProductNumber) FW-M423, FW-M762, FW-M928, FW-R762, FW-R820 .
- Используются таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- Задействуйте ранжирующую функцию dense_rank
- Результирующий набор данных содержит: Идент. работника, наименование должности (в верхнем регистре без пробелов в начале),
идент.заказа, дата проведения заказа, идент. детали заказа, сума заказа, сумма детали заказа,
номер продукта(в верхнем регистре без пробелов в начале), ранг строки.
- Отсортируйте рез. набор данных по идент. сотрудника, по дате заказа (по убыванию), по идент заказа (по убыванию)
*/

with orders as 
(
select t1.BusinessEntityID,
       upper(ltrim(t1.JobTitle)) as [JobTitle],
	   t2.SalesOrderID,
	   t2.OrderDate,
	   t3.SalesOrderDetailID,
	   t2.SubTotal,
	   t3.LineTotal,
	   t4.ProductNumber,
	   upper(ltrim(t4.[name])) as [name],
	   dense_rank()over(partition by t1.BusinessEntityID order by t2.OrderDate desc, t2.SalesOrderID desc) as [DRNK]
  from [HumanResources].[Employee] as t1 
  left outer join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
  left outer join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
  left outer join [Production].[Product] as t4 on t4.ProductID = t3.ProductID
where t1.JobTitle in (N'European Sales Manager', N'North American Sales Manager', N'Pacific Sales Manager', N'Sales Representative')

)
select t1.BusinessEntityID,   -- идент. работника
       t1.JobTitle,           -- наименование должности
	   t1.SalesOrderID,       -- идент. заказа
	   t1.OrderDate,          -- дата проведения заказа
	   t1.SalesOrderDetailID, -- идент. детали заказа
	   t1.SubTotal,
	   t1.LineTotal,          -- сумма детали заказа
	   t1.ProductNumber,      -- номер продукта
	   t1.[name],             -- наименование продукта
	   [DRNK]                 -- ранг
  from orders as t1
 where t1.BusinessEntityID not in (-- Сотрудники на должностях, European Sales Manager, North American Sales Manager, Pacific Sales Manager, Sales Representative
                                   -- у которые проводили заказа на товары с кодом FW-M423, FW-M762, FW-M928, FW-R762, FW-R820
                                   select t2.BusinessEntityID
                                     from orders as t2 
                                    where t2.ProductNumber in (N'FW-M423', N'FW-M762', N'FW-M928', N'FW-R762', N'FW-R820')
									  and t2.BusinessEntityID is not null)
  and t1.drnk <= 3
 order by case when t1.SalesOrderID is null then 1 else 0 end asc,
          t1.BusinessEntityID,
          t1.OrderDate desc,
		  t1.SalesOrderID desc
;
