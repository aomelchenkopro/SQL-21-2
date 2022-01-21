--самый старый работник-------- 
select top 1
with ties
min (distinct (t1.BirthDate)) as [date]
from [HumanResources].[Employee] as t1
where t1.Gender = N'M'
group by t1.BusinessEntityID
order by [date];

-------------------------------------------------------------

-----------------------------------------------------------------------------------
select distinct
t5.ProductID,
t5.[Name],
t5.Color
from [HumanResources].[Employee] as t1
inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                         and t2.OrderDate between '20110101' and '20111231 23:59:59'
inner join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
inner join [Production].[Product] as t5 on t5.ProductID = t3.ProductID

and t1.BusinessEntityID in (select top 1
                                 t6.BirthDate
                            from [HumanResources].[Employee] as t6
                            where t6.Gender = N'M'
                           group by t6.BirthDate
                           order by t6.BirthDate asc)

order by t5.Color asc,
         t5.ProductID asc;

