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
                                            and t4.OrderDate between '20110101' and '20111231 23:59:59.998'
 inner join [Sales].[SalesOrderDetail] as t5 on t5.SalesOrderID = t4.SalesOrderID
 inner join [Production].[Product] as t6 on t6.ProductID = t5.ProductID
 where t3.Gender = N'M'
   and t3.BirthDate in (-- Список идент. работников с датой рождения, которая равна дате рождения самого старшего работника
                               select top 1 
                                      t2.BirthDate
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


-- Янина
select distinct
t5.ProductID,
t5.[Name],
t5.Color
from [HumanResources].[Employee] as t1
inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                         and t2.OrderDate between '20110101' and '20111231 23:59:59'
inner join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID = t2.SalesOrderID
inner join [Production].[Product] as t5 on t5.ProductID = t3.ProductID

and t1.BirthDate in (select top 1
                            t6.BirthDate
                       from [HumanResources].[Employee] as t6
                      where t6.Gender = N'M'
                      --group by t6.BirthDate
                      order by t6.BirthDate asc)
and t1.Gender = N'M'

order by t5.Color asc,
         t5.ProductID asc;


--------------------------------------------------------------------------------------------------------------------------------------------------
-- Елена
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
 where t2.Gender = N'M'
  and t2.BirthDate in (select [BirthDate]
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
						select -- distinct
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
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Александр
--1. Без применения CTE (with)										
	
--1.1. первоначальный вариант
use [AdventureWorks3];	                                                                              --переключение базы данных

select distinct 
       t1.[ProductID],                                                                                --идент. товара
       t1.[Name],                                                                                     --наименование товара
	   t1.[Color]                                                                                     --цвет товара
     from [Production].[Product] as t1
  inner join [Sales].[SalesOrderDetail] as t2 on t2.[ProductID]=t1.[ProductID]
  inner join [Sales].[SalesOrderHeader] as t3 on t3.[SalesOrderID]=t2.[SalesOrderID]
	                                   and t3.[OrderDate] between '20110101' and '20111231 23:59:59'  --заказы за 2011 год
  inner join [HumanResources].[Employee] as t4 on t4.[BusinessEntityID]=t3.[SalesPersonID]
	                                   and t4.[Gender]=N'M'                                           --мужской пол
	  where t4.[BirthDate]=(select min (t5.[BirthDate])                                               --самая ранняя дата рождения у работников мужского пола
		                    from [HumanResources].[Employee] as t5
							where t5.[Gender]=N'M')  
	  order by t1.[Color] asc,                                                                        --упорядочивание по цвету (по возрастанию)
	           t1.[ProductID] asc                                                                     --упорядочивание по идент. товара (по возрастанию)
;



--1.2. после ознакомления с ответом
use [AdventureWorks3];	                                                                              --переключение базы данных
select distinct

       t1.[ProductID],                                                                                --идент. товара
       t1.[Name],                                                                                     --наименование товара
	   t1.[Color]                                                                                     --цвет товара
     from [Production].[Product] as t1
  inner join [Sales].[SalesOrderDetail] as t2 on t2.[ProductID]=t1.[ProductID]
  inner join [Sales].[SalesOrderHeader] as t3 on t3.[SalesOrderID]=t2.[SalesOrderID]
	                                   and t3.[OrderDate] between '20110101' and '20111231 23:59:59'  --заказы за 2011 год
  inner join [HumanResources].[Employee] as t4 on t4.[BusinessEntityID]=t3.[SalesPersonID]
     where t4.Gender=N'M'                                                                             --мужской пол
       and t4.[BirthDate]=
                              (select top 1                                                           --самая ранняя дата рождения у работников мужского пола
							          t5.BirthDate
							     from [HumanResources].[Employee] as t5
							    where t5.Gender=N'M'
							    order by t5.BirthDate asc)
	 order by t1.[Color] asc,                                                                         --упорядочивание по цвету (по возрастанию)
	          t1.[ProductID] asc                                                                      --упорядочивание по идент. товара (по возрастанию)	
;

--мое мнение-нельзя брать BusinessEntityID во вложенном запросе так как в ответе. top 1 вернет ID сотрудника, который будет выбран первым. 
--Т.е. если бы оказалось, что таких сотрудников несколько (дата рождения самамя ранняя и совпадает), вернулся бы только один ID.
--в случае, если брать не BusinessEntityID, а BirthDate, в итоге будут выбраны все сотрудники

---------------------------------------------------------------------------------------------------------------------------------------------------

--2. С применением CTE (with)

--2.1. первоначальный вариант
use [AdventureWorks3];	                                                            --переключение базы данных


with [employee] as                                                                  --выбор сотрудников ID мужского пола с самой ранней датой рождения
(select t1.[BusinessEntityID],
        t1.[BirthDate],
		t1.[Gender]
    from [HumanResources].[Employee] as t1
   where t1.[Gender]=N'M'
	  and t1.[BirthDate]=                              
	  (select min (t1.[BirthDate])
	      from [HumanResources].[Employee] as t1
		 where t1.[Gender]=N'M')
),

[orders] as                                                                         --выбор ID заказов за 2011 год, которые соответствуют выбранным ID сотрудников
(select t2.[SalesOrderID],
        t2.[SalesPersonID],
		t2.[OrderDate]
  from [Sales].[SalesOrderHeader] as t2
 where t2.[OrderDate] between '20110101' and '20111231 23:59:59'
	 and t2.[SalesPersonID] in (select t1.[BusinessEntityID] from [employee] as t1)
),

[products_id] as                                                                    --выбор ID продуктов, которые соответствуют выбранным ID заказов
(select t3.[ProductID],
        t3.[SalesOrderID]
  from [Sales].[SalesOrderDetail] as t3
 where t3.[SalesOrderID] in (select t2.[SalesOrderID] from [orders] as t2)
),

[products] as                                                                       --выбор информации по продуктам ID которых определены
(select t4.[ProductID],
        t4.[Name],
		t4.[Color]
		
 from [Production].[Product] as t4
where t4.[ProductID] in (select distinct (t3.[ProductID]) from [products_id] as t3)
)

select t1.*                                                                         --выбор итоговых результатов
   from [products] as t1
order by 3 asc, 1 asc                                                               --упорядочивание результатов
;


--2.2. после ознакомления с ответом
use [AdventureWorks3];	                                                                                    --переключение базы данных

with [employee] as                                                                                          --выбор всех сотрудников мужского пола
(
select t1.[BusinessEntityID],
       t1.[BirthDate],
	   t1.[Gender]
   from [HumanResources].[Employee] as t1
  where t1.[Gender]=N'M'
)

select distinct                                                                                             --выбор продуктов, которые есть в заказах за 2011 год
       t2.[ProductID],
       t2.[Name],
	   t2.[Color]
	 from [Production].[Product] as t2
   inner join [Sales].[SalesOrderDetail] as t3 on t3.[ProductID]=t2.[ProductID]
   inner join [Sales].[SalesOrderHeader] as t4 on t4.[SalesOrderID]=t3.[SalesOrderID]
                                              and t4.[OrderDate] between '20110101' and '20111231 23:59:59'
		where t4.[SalesPersonID] in (
		                           select top 1                                                             --выбор ID сотрудников с самой ранней датой рождения
								        t1.[BusinessEntityID]
									 from [employee] as t1
								   order by t1.[BirthDate] asc )  
   order by t2.[Color] asc,                                                                                 --упорядочивание по цвету (по возрастанию)
	        t2.[ProductID] asc                                                                              --упорядочивание по идент. товара (по возрастанию)	
;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------Оконные функции------------------------------------------------------------------------------
-----------------------------------------------------------------------Ранжирующие функции----------------------------------------------------------------------------
-- ROW_NUMBER
select t2.*
 from (
		select t1.BusinessEntityID,
			   t1.NationalIDNumber,
			   t1.gender,
			   t1.JobTitle,
			   t1.HireDate,
			   row_number()over(partition by t1.JobTitle/*, t1.gender*/  order by t1.HireDate asc/*, t1.BusinessEntityID desc*/) as [row_number]
		  from [HumanResources].[Employee] as t1
	  ) as t2
where t2.[row_number] = 2
;

-- RANK
select t1.BusinessEntityID,
       t1.NationalIDNumber,
       t1.gender,
       t1.JobTitle,
	   t1.HireDate,
       row_number()over(partition by t1.JobTitle order by t1.HireDate asc) as [row_number],
	   rank()over(partition by t1.JobTitle order by t1.HireDate asc) as [rank]
  from [HumanResources].[Employee] as t1;

--DENSE_RANK
select t1.BusinessEntityID,
       t1.NationalIDNumber,
       t1.gender,
       t1.JobTitle,
	   t1.HireDate,
       row_number()over(partition by t1.JobTitle order by t1.HireDate asc) as [row_number],
	   rank()over(partition by t1.JobTitle order by t1.HireDate asc) as [rank],
	   dense_rank()over(partition by t1.JobTitle order by t1.HireDate asc) as [dense_rank]
  from [HumanResources].[Employee] as t1;

--NTILE
select distinct 
       t1.BusinessEntityID,
       t1.NationalIDNumber,
       t1.gender,
       t1.JobTitle,
	   t1.HireDate,
       row_number()over(partition by t1.JobTitle order by t1.HireDate asc) as [row_number],
	   rank()over(partition by t1.JobTitle order by t1.HireDate asc) as [rank],
	   dense_rank()over(partition by t1.JobTitle order by t1.HireDate asc) as [dense_rank],
	   ntile(100)over(order by t1.HireDate asc) as [ntile]
  from [HumanResources].[Employee] as t1;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------Оконно агрегатные функции--------------------------------------------------------------------------
select t1.BusinessEntityID,
       t1.NationalIDNumber,
	   t1.JobTitle,
	   t1.BirthDate,
	   t1.HireDate,
	   t1.SickLeaveHours,
	   count(t1.BusinessEntityID)over(partition by t1.JobTitle) as [overCount],
	   sum(t1.SickLeaveHours)over(partition by  t1.JobTitle) as [overSum],
	   min(t1.SickLeaveHours)over(partition by  t1.JobTitle) as [overMin],
	   max(t1.SickLeaveHours)over(partition by  t1.JobTitle) as [overMax],
	   avg(t1.SickLeaveHours)over(partition by  t1.JobTitle) as [overAVG]
  from [HumanResources].[Employee] as t1;

select t1.SalesPersonID,
       t1.OrderDate,
	   t1.SubTotal,
	   sum(t1.SubTotal)over(partition by t1.SalesPersonID order by t1.OrderDate range between unbounded preceding and current row) as [RangeOverSum],
	   sum(t1.SubTotal)over(partition by t1.SalesPersonID order by t1.OrderDate rows between unbounded preceding and current row) as [RangeOverSum]
  from [Sales].[SalesOrderHeader] as t1
 where t1.SalesPersonID is not null
order by t1.SalesPersonID asc,  t1.OrderDate asc
;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
select t1.SalesOrderID,
       t1.SalesOrderDetailID,
	   t1.LineTotal,
	   /*
	   t1.LineTotal/
	   (
	    select sum(t2.LineTotal)
		  from [Sales].[SalesOrderDetail] as t2
		 where t2.SalesOrderID = t1.SalesOrderID
	   ) * 100.00 as [dola],*/
	   -----------------------------------------------------------------
	   t1.LineTotal/ sum(t1.LineTotal)over(partition by t1.SalesOrderID) * 100.00 as [overDola]
  from [Sales].[SalesOrderDetail] as t1 
 order by t1.SalesOrderID asc, t1.SalesOrderDetailID
;
-------------------------------------------------------------------аналитические оконные функции-----------------------------------------------------------------------
-- LAG
-- LEAD
-- FIRST_VALUE
-- LAST_VALUE

select t1.SalesPersonID,
       t1.SalesOrderID,
       t1.OrderDate,
	   t1.SubTotal,
	   [lag] = LAG(t1.SubTotal, 1, 0)over(partition by t1.SalesPersonID order by t1.OrderDate),
	   [lagCurrDiff] = t1.SubTotal - LAG(t1.SubTotal, 1, 0)over(partition by t1.SalesPersonID order by t1.OrderDate)
  from [Sales].[SalesOrderHeader] as t1
 where t1.SalesPersonID is not null
 order by t1.SalesPersonID, t1.OrderDate
;

-- LEAD
select t1.SalesPersonID,
       t1.SalesOrderID,
       t1.OrderDate,
	   t1.SubTotal,
	   [lag] = LEAD(t1.SubTotal, 1, 0)over(partition by t1.SalesPersonID order by t1.OrderDate ),
	   [lagCurrDiff] = t1.SubTotal - LEAD(t1.SubTotal, 1, 0)over(partition by t1.SalesPersonID order by t1.OrderDate)
  from [Sales].[SalesOrderHeader] as t1
 where t1.SalesPersonID is not null
 order by t1.SalesPersonID, t1.OrderDate
;

-- FIRST_VALUE
select t1.SalesPersonID,
       t1.SalesOrderID,
       t1.OrderDate,
	   t1.SubTotal,
	   [FIRST_VALUE] = FIRST_VALUE(t1.SubTotal)over(partition by t1.SalesPersonID order by t1.OrderDate rows between unbounded preceding and current row ),
	   [FIRST_VALUEDiff] = t1.SubTotal - FIRST_VALUE(t1.SubTotal)over(partition by t1.SalesPersonID order by t1.OrderDate rows between unbounded preceding and current row )
  from [Sales].[SalesOrderHeader] as t1
 where t1.SalesPersonID is not null
 order by t1.SalesPersonID, t1.OrderDate
;

-- LAST_VALUE
select t1.SalesPersonID,
       t1.SalesOrderID,
       t1.OrderDate,
	   t1.SubTotal,
	   [LAST_VALUE] = LAST_VALUE(t1.SubTotal)over(partition by t1.SalesPersonID order by t1.OrderDate, t1.SalesOrderID desc  rows between current row and unbounded following),
	   [LAST_VALUEDiff] = t1.SubTotal - LAST_VALUE(t1.SubTotal)over(partition by t1.SalesPersonID order by t1.OrderDate, t1.SalesOrderID desc  rows between current row and unbounded following)
  from [Sales].[SalesOrderHeader] as t1
 where t1.SalesPersonID is not null
 order by t1.SalesPersonID, t1.OrderDate
;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Напишите запрос, котрый вернет список заказов проведенные сотрудниками мужского пола.
Учитывайте только заказы на последние 3 даты каждого отдельного работника.
*/

-- Елена
with w as 
( 
select t2.[SalesPersonID], 
       t2.SalesOrderID, 
       t2.OrderDate, 
    dense_rank()over(partition by t2.[SalesPersonID] order by t2.OrderDate desc) as  [dense_rank] 
from [Sales].[SalesOrderHeader] as t2 
where t2.[SalesPersonID] in  
                          ( 
        select t1.BusinessEntityID 
                            from [HumanResources].[Employee] as t1 
                           where t1.[Gender] = N'M' 
        ) 
) 
select * 
  from w as t3 
where t3.[dense_rank] < 4;


with w as 
( 
select t2.[SalesPersonID], 
       t2.SalesOrderID, 
       t2.OrderDate, 
      [dense_rank]  = dense_rank()over(partition by t2.[SalesPersonID] order by t2.OrderDate desc) 
from [Sales].[SalesOrderHeader] as t2 
inner join [HumanResources].[Employee] as t1 on t1.BusinessEntityID = t2.[SalesPersonID] 
                                             and t1.[Gender] = N'M' 
) 
select * 
  from w as t3 
where t3.[dense_rank] <= 3;

-- Анастасия
with s as (select t1.SalesPersonID,
       t1.SalesOrderID,
    t1.OrderDate,
    dense_rank() over(partition by t1.SalesPersonID order by t1.OrderDate desc) as [rank_orders]   
from [Sales].[SalesOrderHeader] as t1 
inner join [HumanResources].[Employee] as t2 on t2.BusinessEntityID = t1.SalesPersonID
                                            and t2.Gender = N'M')
select *
from s as t3
where t3.rank_orders < 4

-- Александр
select t1.BusinessEntityID, 
       t1.Gender, 
    t2.SalesPersonID, 
    t2.SalesOrderID, 
    t2.OrderDate, 
 dense_rank()over (partition by t1.BusinessEntityID order by t2.OrderDate desc) 
 
    from [HumanResources].[Employee] as t1 
 inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID=t1.BusinessEntityID 
 where t1.Gender=N'M' 
 order by t1.BusinessEntityID

-- Янина
select * 
  from (
select t1.SalesPersonID,
t1.SalesOrderID,
t1.OrderDate,
dense_rank() over(partition by t1.SalesPersonID order by t1.OrderDate desc) as [row_number]
from [Sales].[SalesOrderHeader] as t1
inner join [HumanResources].[Employee]as t2 on t2.BusinessEntityID = t1.SalesPersonID
and t2.Gender = N'M'
) as q
where q.[row_number] <=3


-- Дарья
select * 
 from (
select t1.BusinessEntityID,  
    t1.JobTitle, 
       t1.Gender,  
    t2.SalesPersonID,  
    t2.SalesOrderID,  
    t2.OrderDate,  
     dense_rank() over(partition by t2.SalesPersonID order by t2.OrderDate desc) as [dense_rank] 
    from [HumanResources].[Employee] as t1 
    inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID=t1.BusinessEntityID  
     where t1.Gender = N'M'   

) as q 
where q.[dense_rank] <= 3
order by q.BusinessEntityID
--============================================================================================================
with w as 
(
select t1.BusinessEntityID,
       t1.JobTitle,
	   t2.OrderDate,
	   t2.SubTotal,
	   dense_rank()over(partition by t1.BusinessEntityID order by t2.OrderDate desc) as [dense_rank]
  from [HumanResources].[Employee] as t1
  inner join  [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
 where t1.Gender = N'M'
 ) 
 select *
   from w
  where w.[dense_rank] <= 3;


