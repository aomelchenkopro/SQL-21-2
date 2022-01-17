/*
Напишите запрос, который вернет список товаров (без дубликатов) проведенные самым старшим работником мужского пола, за 2011 год.
Учитывайте вероятность того, что сразу несколько работников могут иметь одну и ту же дату рождения.
Решите задачу двумя способами, с применением CTE (with) и без. Не используйте оператор with ties.
- Используются таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- Рез. набор данных содержит идент. товара, наименование товара, цвет товара
- Отсортировать рез. набор данных по цвету товара (по возрастанию), в разрезе цвета по идент. товара (по возрастанию)
*/
select distinct 
       t6.ProductID,
	   t6.[Name],
	   t6.Color
  from [HumanResources].[Employee] as t3
 inner join [Sales].[SalesOrderHeader] as t4 on t4.SalesPersonID = t3.BusinessEntityID
                                            and t4.OrderDate between '20110101' and '20111231 23:59:59'
 inner join [Sales].[SalesOrderDetail] as t5 on t5.SalesOrderID = t4.SalesOrderID
 inner join [Production].[Product] as t6 on t6.ProductID = t5.ProductID
 where t3.Gender = N'M'
   and t3.BusinessEntityID in (-- Список идент. работников с датой рождения, которая равна дате рождения самого старшего работника
                               select top 1 
                                      t2.BusinessEntityID
                                from (-- Список работников мужского пола
                                      select t1.BusinessEntityID,
                                             t1.BirthDate
                                        from [HumanResources].[Employee] as t1
                                       where t1.Gender = N'M') as t2
                                       order by t2.BirthDate asc)
 order by t6.Color asc,
          t6.ProductID asc;
-------------------------------------------------------CTE---------------------------------------------------------------------
with employee as 
(
-- Список работников мужского пола
select t1.BusinessEntityID,
       t1.BirthDate
  from [HumanResources].[Employee] as t1
 where t1.Gender = N'M'
)
-- Список заказов, которые проводили работники с датой рождения равной дате рождения самого старшего работника
select distinct 
       t5.ProductID,
	   t5.[Name],
	   t5.Color
  from [Sales].[SalesOrderHeader] as t3
 inner join [Sales].[SalesOrderDetail] as t4 on t4.SalesOrderID = t3.SalesOrderID
 inner join [Production].[Product] as t5 on t5.ProductID = t4.ProductID
 where t3.OrderDate between '20110101' and '20111231 23:59:59'
   and t3.SalesPersonID in (-- Список идент. работников с датой рождения, которая равна дате рождения самого старшего работника
                            select t2.BusinessEntityID
                              from employee as t2
                             where t2.BirthDate = (-- Дата рождения самого старшего работника
							                       select top 1
                                                          t1.BirthDate
                                                     from employee as t1
                                                    order by t1.BirthDate asc))
 order by t5.Color asc,
          t5.ProductID asc;