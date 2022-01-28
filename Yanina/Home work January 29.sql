
  with orders as 
(
select t1.SalesOrderID,
       t1.SalesOrderDetailID,
	   t1.LineTotal
  from [Sales].[SalesOrderDetail] as t1 
)
select t3.SalesOrderID,
       t3.SalesOrderDetailID,
	   t3.LineTotal,
	   t3.LineTotal / sum(t3.LineTotal)over(partition by t3.SalesOrderID) * 100 as [DolaOverSum]
  from orders as t3 
 where t3.SalesOrderID in (
							select top 1
							count(distinct t1.SalesOrderDetailID) as [qty]
							from orders as t1
							group by t1.SalesOrderID
							order by [qty] desc
						  )
order by t3.SalesOrderID, 
         [DolaOverSum] desc
;