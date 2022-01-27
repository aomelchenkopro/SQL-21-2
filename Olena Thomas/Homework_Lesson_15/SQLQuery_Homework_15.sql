/*"Напишите запрос возвращающий детали заказа, у которого наибольшее кол-во деталей (позиций).
Учитывайте вероятность того, что сразу несколько заказов могут иметь одно и тоже кол-во деталей.
Рассчитайте долю каждой отдельной детали к общей сумме заказа, в процентном соотношении.
- Используются таблицы: [Sales].[SalesOrderDetail]
- Задействуйте оконно агрегатную функцию sum
- Рез. набор данных содержит: Идент. заказа, идент детали заказа, сумму детали заказа, долю"											
*/

select t1.SalesOrderID,
       t1.SalesOrderDetailID,
	   t1.LineTotal,
	   t1.LineTotal*100/sum(t1.LineTotal)over(partition by t1.SalesOrderID) as [dola]
from [Sales].[SalesOrderDetail] as t1
where  t1.SalesOrderID in (
							select top 1
								   with ties
								   t1.SalesOrderID
							from [Sales].[SalesOrderDetail] as t1
							group by t1.SalesOrderID
							order by count(t1.ProductID) desc
                           )
order by t1.SalesOrderID, [dola] desc
;

/*"Напишите запрос, который для работников на должностях
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
номер продукта(в верхнем регистре без пробелов в начале), ранг строки."									
*/
--=============================================================================================================================

with employesID as
(
select t4.BusinessEntityID         as [BusinessEntityID],
       t4.JobTitle                 as [JobTitle]
  from [HumanResources].[Employee] as t4
 where t4.JobTitle in (N'European Sales Manager', N'North American Sales Manager', N'Pacific Sales Manager', N'Sales Representative')
       and t4.BusinessEntityID not in (
                                      select distinct
	                                         t3.SalesPersonID 
                                        from [Production].[Product] as t1
                                             left outer join [Sales].[SalesOrderDetail] as t2 on t2.ProductID = t1.ProductID 
                                             left outer join [Sales].[SalesOrderHeader] as t3 on t2.SalesOrderID = t3.SalesOrderID
                                       where t1.ProductNumber in (N'FW-M423', N'FW-M762', N'FW-M928', N'FW-R762', N'FW-R820')
                                      )
),
orderID as
(
select t1.BusinessEntityID,
       t1.JobTitle,
	   t2.OrderDate,
	   t2.SalesOrderID,
	   dense_rank()over(partition by t1.BusinessEntityID order by t2.OrderDate desc, t2.SalesOrderID desc) as [dense_rank]
  from employesID as t1
       left outer join [Sales].[SalesOrderHeader] as t2 on t1.BusinessEntityID = t2.SalesPersonID
)
select t1.BusinessEntityID,
       ltrim(upper(t1.JobTitle)),
	   t1.SalesOrderID,
	   t1.OrderDate,
	   t2.SalesOrderDetailID,
	   t3.SubTotal,
	   t2.LineTotal,
	   ltrim(upper(t4.ProductNumber)),
	   t4.[Name],
	   t1.[dense_rank]
  from orderID as t1
       left outer join [Sales].[SalesOrderDetail] as t2 on t2.SalesOrderID = t1.SalesOrderID
	   left outer join [Sales].[SalesOrderHeader] as t3 on t3.SalesOrderID = t1.SalesOrderID
	   left outer join [Production].[Product] as t4 on t4.ProductID = t2.ProductID
 where t1.[dense_rank] <= 3
 order by case when t1.SalesOrderID is null then 1 else 0 end asc,
          t1.BusinessEntityID asc, 
		  t1.[dense_rank] asc
;




