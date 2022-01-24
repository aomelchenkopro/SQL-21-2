/*"Напишите запрос, который вернет список товаров (без дубликатов) проведенные самым старшим работником мужского пола, за 2011 год.
Учитывайте вероятность того, что сразу несколько работников могут иметь одну и ту же дату рождения.
Решите задачу двумя способами, с применением CTE (with) и без. Не используйте оператор with ties.
- Используются таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- Рез. набор данных содержит идент. товара, наименование товара, цвет товара
- Отсортировать рез. набор данных по цвету товара (по возрастанию), в разрезе цвета по идент. товара (по возрастанию)"		
*/

with birthDateEmployee as
(
select min(t1.BirthDate) as [BirthDate]                    -- Находим дату рождениния самого старшего работника
  from [HumanResources].[Employee] as t1
 where t1.Gender = N'M' 
),
oldestEmployee as                                          -- Сотрудники с этой датой рождения
(
select t2.BusinessEntityID
  from [HumanResources].[Employee] as t2
  where t2.BirthDate in (select *
						from birthDateEmployee
						)
),
productsID as                                              -- ID продуктов, которые продали эти сотрудники 
(
select distinct
      t3.ProductID
	from [Sales].[SalesOrderDetail] as t3
	inner join [Sales].[SalesOrderHeader] as t4 on t3.[SalesOrderID] = t4.[SalesOrderID]
	                                               and t4.[OrderDate] between '20110101' and '20111231 23:59:59.998'
												   and t4.SalesPersonID =(
																			select *
																			from oldestEmployee
																		 ) 
),
productInfo as                                            -- Информация по этим продуктам (идент. товара, наименование товара, цвет товара)
(
select t5.[ProductID],
       t5.[Name],
	   t5.[Color]
	from [Production].[Product] as t5
where t5.ProductID in (
                       select *
					   from productsID
					  )
)
select *
  from productInfo as t6
order by t6.Color asc, t6.ProductID asc
;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

select t5.[ProductID],                                                                                                             -- Информация по этим продуктам (идент. товара, наименование товара, цвет товара)
       t5.[Name],
	   t5.[Color]
  from [Production].[Product] as t5
 where t5.ProductID in(
						select distinct
							   t3.ProductID                                                                                         -- ID продуктов, которые продали эти сотрудники 
						  from [Sales].[SalesOrderDetail] as t3
					      inner join [Sales].[SalesOrderHeader] as t4 on t3.[SalesOrderID] = t4.[SalesOrderID]
																	  and t4.[OrderDate] between '20110101' and '20111231 23:59:59.998'
																   	  and t4.SalesPersonID =(
																							 select t2.BusinessEntityID             -- Сотрудники с этой датой рождения
																							   from [HumanResources].[Employee] as t2
																							  where t2.BirthDate in (
																													select min(t1.BirthDate) as [BirthDate]  -- Находим дату рождениния самого старшего работника
																													  from [HumanResources].[Employee] as t1
																													 where t1.Gender = N'M' 
																													)
																							) 
					  )
order by t5.Color asc, t5.ProductID asc
;



--select distinct
--      t3.ProductID,
--	  t4.OrderDate
--	from [Sales].[SalesOrderDetail] as t3
--	inner join [Sales].[SalesOrderHeader] as t4 on t3.[SalesOrderID] = t4.[SalesOrderID]
--	                                               and t4.[OrderDate] between '20110101' and '20111231 23:59:59.999'
--												   and t4.SalesPersonID = 274
--;

