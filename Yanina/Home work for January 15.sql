select top 1 
       with ties
       upper(ltrim(t4.JobTitle))           as [JobTitle],
       count(distinct t4.BusinessEntityID) as [Emp_Qty]
  from [Production].[Product]          as t1
 inner join [Sales].[SalesOrderDetail] as t2 on t2.ProductID = t1.ProductID
                                            and t1.Color = N'Black'
 inner join [Sales].[SalesOrderHeader] as t3 on t3.SalesOrderID = t2.SalesOrderID
                                             and t3.OrderDate = 2013
 right outer join [HumanResources].[Employee] as t4 on t4.BusinessEntityID = t3.SalesPersonID
 where t3.SalesOrderID is null
 group by [JobTitle]
 order by [Emp_Qty] desc;
