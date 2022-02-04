/*
"Напишите запрос, который вернет список товаров (без дубликатов) проведенные самым старшим работником мужского пола, за 2011 год.
Учитывайте вероятность того, что сразу несколько работников могут иметь одну и ту же дату рождения.
Решите задачу двумя способами, с применением CTE (with) и без. Не используйте оператор with ties.
- Используются таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- Рез. набор данных содержит идент. товара, наименование товара, цвет товара
- Отсортировать рез. набор данных по цвету товара (по возрастанию), в разрезе цвета по идент. товара (по возрастанию)"						
*/					
						

--Общие вопросы. 
--1)Почему не сработало 999 в дате? Если его поставить, подтянется и 2012-й год
--2)Что будет, если самый старый сотрудник мужского пола не продавал вообще ничего в 2011? Я так понял, что ничего не выведется тогда




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