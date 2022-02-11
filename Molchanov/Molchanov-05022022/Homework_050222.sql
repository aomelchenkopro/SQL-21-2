/*
"Напишите запрос, который для активного (ActiveFlag) производителя с кредитным рейтингом (CreditRating) не более 2 и
имеющего наибольшее количество продуктов класса (Class) H = High и M = Medium, вернет список таких продуктов.
Учитывайте вероятность того, что сразу несколько производителей могут иметь одно и тоже кол-во продуктов.
- Используются таблицы: Purchasing.Vendor, Purchasing.ProductVendor, Production.Product.
  Детальное описание таблиц доступно по ссылке https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/Purchasing_Vendor_177.html
- Задействуйте оператор with
- Не используйте оператор with ties
- Рез. набор данных содержит: идент. производителя, идент. продукта, наименование продукта, цвет продукта, класс продукта
- Отсортировать рез. набор данных по идент. производителя, по идент. товара"								
*/

use [AdventureWorks3];                                                                           --переключение базы данных

with ProductsData as                                                                             --оператор with
(
select t1.BusinessEntityID,                                                                      --идент. производителя
       -- t1.CreditRating,
       -- t1.ActiveFlag,
	    t2.ProductID,                                                                            --идент. продукта
	    t3.[Name],                                                                               --наименование продукта
	    t3.Color,                                                                                --цвет продукта
	    t3.Class                                                                                 --класс продукта
  from Purchasing.Vendor as t1	
 inner join Purchasing.ProductVendor as t2 on t2.BusinessEntityID=t1.BusinessEntityID	
 inner join Production.Product as t3 on t3.ProductID=t2.ProductID
                                    and t3.Class in (N'H', N'M')                                 --продукты класса (Class) H = High и M = Medium
  where t1.CreditRating<=2                                                                       --производитель с кредитным рейтингом (CreditRating) не более 2
	and t1.ActiveFlag=1                                                                          --активный (ActiveFlag) производитель
)

select t4.*                                                                                      --итоговая выборка
  from ProductsData as t4
  where t4.BusinessEntityID in (
	                            select t5.BusinessEntityID                                       --выбраны идент. производителя с наибольшим количеством деталей
                             	  from ProductsData as t5
                                 group by t5.BusinessEntityID
                                having (count (distinct t5.ProductID)) = (
                                                                          select top 1           --выбрано наибольшее количество деталей в разрезе идент. производителя
                                                                                  count (distinct t6.ProductID) 
                                                                           from ProductsData as t6
                                                                          group by t6.BusinessEntityID
                                                                          order by count (distinct t6.ProductID) desc
							                                             )
					             )


  order by t4.BusinessEntityID, t4.ProductID
;

