/*
Напишите запрос, который для активного (ActiveFlag) производителя с кредитным рейтингом (CreditRating) не более 2 и
имеющего наибольшее количество продуктов класса (Class) H = High и M = Medium, вернет список таких продуктов.
Учитывайте вероятность того, что сразу несколько производителей могут иметь одно и тоже кол-во продуктов.
- Используются таблицы: Purchasing.Vendor, Purchasing.ProductVendor, Production.Product.
  Детальное описание таблиц доступно по ссылке https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/Purchasing_Vendor_177.html
- Задействуйте оператор with
- Не используйте оператор with ties
- Рез. набор данных содержит: идент. производителя, идент. продукта, наименование продукта, цвет продукта, класс продукта
- Отсортировать рез. набор данных по идент. производителя, по идент. товара
*/
-- CTE
with products as 
(
select t1.BusinessEntityID, -- идент. проивзодителя
       t3.ProductID,        -- идент. продукта
	   t3.[Name],           -- наименование продукта
	   t3.Color,            -- цвет продукта
	   t3.Class             -- класс продукта
	   -- Таблица производителей
  from Purchasing.Vendor as t1 
       -- Идент. продуктов каждого отдельного производителя
 inner join Purchasing.ProductVendor as t2 on t2.BusinessEntityID = t1.BusinessEntityID
       -- Хранит информацию продуктов
 inner join Production.Product as t3 on t3.ProductID = t2.ProductID
                                     -- Продукты класса High Medium
                                    and t3.Class in (N'H', N'M')
 where -- Кредитный рейтинг не более двух
       t1.CreditRating  <= 2
    -- Активный производитель
   and t1.ActiveFlag = 1
)
-- Рез. набор данных
select * 
  from products as t3
 where t3.BusinessEntityID in (
                                -- Идент. производителей с наибольшим количеством продуктов
								select t2.BusinessEntityID
								  from products as t2 
								 group by t2.BusinessEntityID
								having count(distinct t2.ProductID) = (
								                                        -- Наибольшее кол-во продуктов в разрезе производителя
																		select top 1 
																				count(distinct t1.ProductID) as [pQty] -- кол-во уникальных идент. продуктов
																			from products as t1
																			group by t1.BusinessEntityID
																			order by [pQty] desc
																	   )
								)
order by t3.BusinessEntityID, 
         t3.ProductID
;
--==============================================================================================================================================
with products as 
(
select t1.BusinessEntityID, -- идент. проивзодителя
       t3.ProductID,        -- идент. продукта
	   t3.[Name],           -- наименование продукта
	   t3.Color,            -- цвет продукта
	   t3.Class             -- класс продукта
	   -- Таблица производителей
  from Purchasing.Vendor as t1 
       -- Идент. продуктов каждого отдельного производителя
 inner join Purchasing.ProductVendor as t2 on t2.BusinessEntityID = t1.BusinessEntityID
       -- Хранит информацию продуктов
 inner join Production.Product as t3 on t3.ProductID = t2.ProductID
                                     -- Продукты класса High Medium
                                    and t3.Class in (N'H', N'M')
 where -- Кредитный рейтинг не более двух
       t1.CreditRating  <= 2
    -- Активный производитель
   and t1.ActiveFlag = 1
)
-- Рез. набор данных
select top 1
       with ties
       * 
  from products as t3
 order by count(t3.ProductID)over(partition by t3.BusinessEntityID) desc
;
--==============================================================================================================================================

--==============================================================================================================================================