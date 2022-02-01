/*"Напишите запрос, который для активного (ActiveFlag) производителя с кредитным рейтингом (CreditRating) не более 2 и
имеющего наибольшее количество продуктов класса (Class) H = High и M = Medium, вернет список таких продуктов.
Учитывайте вероятность того, что сразу несколько производителей могут иметь одно и тоже кол-во продуктов.
- Используются таблицы: Purchasing.Vendor, Purchasing.ProductVendor, Production.Product.
  Детальное описание таблиц доступно по ссылке https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/Purchasing_Vendor_177.html
- Задействуйте оператор with
- Не используйте оператор with ties
- Рез. набор данных содержит: идент. производителя, идент. продукта, наименование продукта, цвет продукта, класс продукта
- Отсортировать рез. набор данных по идент. производителя, по идент. товара"
*/
with products as
(
select t1.BusinessEntityID,
       t3.ProductID,
	   t1.[Name],
	   t3.Color,
	   t3.Class,
	   count(t3.ProductID)over (partition by t1.BusinessEntityID) as [quantityOfProduct]
 from [Purchasing].[Vendor] as t1
inner join [Purchasing].[ProductVendor] as t2 on t2.BusinessEntityID = t1.BusinessEntityID
inner join Production.Product as t3 on t3.ProductID = t2.ProductID
                                         and t3.Class in (N'H', N'M')
where t1.ActiveFlag = 1
	  and t1.CreditRating <=2
)
   select t4.BusinessEntityID,
          t4.ProductID,
	      t4.[Name],
	      t4.Color,
	      t4.Class
     from products as t4
    where t4.quantityOfProduct = (
	                              select max(t5.quantityOfProduct)
	                                from products as t5
	                             )
order by t4.BusinessEntityID asc,
         t4.ProductID asc
;
--======================================================================================================
declare @products table(
	    [BusinessEntityID]    int,
        [ProductID]           int,
	    [Name]                nvarchar(50),
	    [Color]               nvarchar(15),
	    [Class]               nvarchar(2),
	    [quantityOfProduct]   int
);

insert into @products
select t1.BusinessEntityID,
       t3.ProductID,
	   t1.[Name],
	   t3.Color,
	   t3.Class,
	   count(t3.ProductID)over (partition by t1.BusinessEntityID) as [quantityOfProduct]
from [Purchasing].[Vendor] as t1
inner join [Purchasing].[ProductVendor] as t2 on t2.BusinessEntityID = t1.BusinessEntityID
inner join Production.Product as t3 on t3.ProductID = t2.ProductID
                                         and t3.Class in (N'H', N'M')
where t1.ActiveFlag = 1
	  and t1.CreditRating <=2
;

select t4.BusinessEntityID,
       t4.ProductID,
	   t4.[Name],
	   t4.Color,
	   t4.Class
	from @products as t4
	where t4.quantityOfProduct = (
	                              select max(t5.quantityOfProduct)
	                                from @products as t5
	                             )
order by t4.BusinessEntityID asc,
         t4.ProductID asc
;
--======================================================================================================
if object_id('[tempdb].[dbo].#products') is not null drop table #products;

select t1.BusinessEntityID,
       t3.ProductID,
	   t1.[Name],
	   t3.Color,
	   t3.Class,
	   count(t3.ProductID)over (partition by t1.BusinessEntityID) as [quantityOfProduct]
	   into #products
 from [Purchasing].[Vendor] as t1
inner join [Purchasing].[ProductVendor] as t2 on t2.BusinessEntityID = t1.BusinessEntityID
inner join Production.Product as t3 on t3.ProductID = t2.ProductID
                                         and t3.Class in (N'H', N'M')
where t1.ActiveFlag = 1
	  and t1.CreditRating <=2
;
   select t4.BusinessEntityID,
          t4.ProductID,
	      t4.[Name],
	      t4.Color,
	      t4.Class
     from #products as t4
    where t4.quantityOfProduct = (
	                              select max(t5.quantityOfProduct)
	                                from #products as t5
	                             )
order by t4.BusinessEntityID asc,
         t4.ProductID asc
;