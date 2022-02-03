with products as 
(
select t1.BusinessEntityID,
       t3.ProductID,
	   t3.[Name],
	   t3.Color,
	   t3.Class
  from [Purchasing].[Vendor] as t1 
 inner join Purchasing.ProductVendor as t2 on t2.BusinessEntityID = t1.BusinessEntityID
 inner join Production.Product as t3 on t3.ProductID = t2.ProductID
                                    and t3.Class in (N'H', N'M')
 where t1.CreditRating  <= 2
   and t1.ActiveFlag = 1
)
-----------------Финальный набор данных--
select * 
  from products as t3
 where t3.BusinessEntityID in (
                                -- Идентификатор производителей с наибольшим количеством продуктов-------
								select t2.BusinessEntityID
								  from products as t2 
								 group by t2.BusinessEntityID
								having count(distinct t2.ProductID) = (
								                                        -- Наибольшее кол-во продуктов в разрезе производителя----------
																		select top 1 
																				count(distinct t1.ProductID) as [Product_Qty]
																			from products as t1
																			group by t1.BusinessEntityID
																			order by [Product_Qty] desc
																	   )
								)
order by t3.BusinessEntityID, 
         t3.ProductID
;