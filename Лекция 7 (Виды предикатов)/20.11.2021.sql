/*
"Напишите запрос, который в разрезе идентификатора карты (CreditCardID) вернет: кол-во заказов, общую сумму заказов, максимальную сумму
заказа, минимальную сумму заказа, среднюю сумму заказа. Сумма заказа - [SubTotal]. 
Не учитывайте заказы, у которых не указан идент. карты (CreditCardID is not null)
- Используется таблица [Sales].[SalesOrderHeader] 
  https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/Sales_SalesOrderHeader_185.html
- Отсортировать результат по общей сумме заказа (по убыванию)"					

*/
select count(t1.SalesOrderID) as [orderQty], -- кол-во заказов
       sum(t1.SubTotal)       as [totalSum], -- общая сумма заказов
	   max(t1.SubTotal)       as [maxSum],   -- максимальная сумма
	   min(t1.SubTotal)       as [minSum],   -- минимальная сумма
	   avg(t1.SubTotal)       as [avgSum]    -- средняя сумма
  from [Sales].[SalesOrderHeader] as t1
 where t1.CreditCardID is not null
 group by t1.CreditCardID
 order by  sum(t1.SubTotal) desc
--===========================================================================================================================================

select t1.CreditCardID,
       CHECKSUM_AGG(t1.[SalesOrderID]) as [CHECKSUM_AGG] -- 43659
  from [Sales].[SalesOrderHeader] as t1
  group by t1.CreditCardID
  order by 1

  select * from [Sales].[SalesOrderHeader]

delete from [Sales].[SalesOrderHeader] 
where SalesOrderID = 43662
--=========================================================================================================================================== 
select distinct 
       top 3
       t1.JobTitle
  from [HumanResources].[Employee] as t1
  order by t1.JobTitle;

select distinct 
       t1.JobTitle,
	   t1.Gender
  from [HumanResources].[Employee] as t1;
--===========================================================================================================================================   
-- Фильтр TOP 
select top 3 percent
       t1.*
  from [Sales].[SalesOrderHeader] as t1
 order by t1.SubTotal desc;


select top 1
       with ties
       t1.*
  from [Sales].[SalesOrderHeader] as t1
  order by t1.OrderDate  desc
--=========================================================================================================================================== 
select *
  from [Sales].[SalesOrderHeader] as t1
  order by t1.OrderDate desc
  offset 0 rows-- пропустить первые 15000 строк
  fetch next 100 rows only -- отобразить только следующие 100 строк


-- select * from [HumanResources].[Employee]
--=========================================================================================================================================== 
-- AND - И
select * 
  from [HumanResources].[Employee] as t1
 where 1 = 1
   and t1.JobTitle like '%designer%'
   and t1.Gender = N'M'
   and t1.SickLeaveHours !> 100
   and t1.MaritalStatus = N'S';

-- OR  - ИЛИ
select * 
  from [HumanResources].[Employee] as t1
 where 1 = 1
   and t1.SickLeaveHours !> 100
   and t1.MaritalStatus = N'S'
   and ( (t1.Gender = N'M' and t1.JobTitle like '%designer%') or (t1.Gender = N'F' and t1.JobTitle = N'Marketing Specialist') );

select *
  from [HumanResources].[Employee] as t1
 where year(t1.HireDate) = 2006 
   and( t1.JobTitle = N'Production Technician - WC60' or t1.JobTitle = N'Production Supervisor - WC10')
;


-- NOT - НЕТ
select * 
  from [HumanResources].[Employee] as t1
 where 1 = 1
   and not t1.JobTitle like '%designer%'
   and t1.Gender = N'M'
   and t1.SickLeaveHours !> 100
   and not t1.MaritalStatus = N'S';

--=========================================================================================================================================== 
-- Виды предикатов
-- Предикат -  это утверждение, высказанное о субъекте
-- Предикаты сравнения
/*
= (равно)	Равно
> (больше)	Больше
< (меньше)	Меньше чем
>= (больше или равно)	Больше или равно
<= (меньше или равно)	Меньше или равно
<> (не равно)	Не равно
!= (не равно)	Не равно (не определено стандартом ISO)
!< (не меньше)	Не меньше (не определено стандартом ISO)
!> (не больше чем)	Не больше (не определено стандартом ISO)
*/

-- = (равно)
select * 
  from [HumanResources].[Employee] as t1
 where not t1.JobTitle = N'Engineering Manager';

-- <> (не равно)
select * 
  from [HumanResources].[Employee] as t1
 where not t1.JobTitle <> N'Engineering Manager';

-- != (не равно)
select * 
  from [HumanResources].[Employee] as t1
 where t1.JobTitle != N'Engineering Manager';

-- > (больше)	Больше
select * 
  from [HumanResources].[Employee] as t1
 where t1.SickLeaveHours > 70;

 -- < (меньше)
select * 
  from [HumanResources].[Employee] as t1
 where t1.SickLeaveHours < 70;

-- >= (больше или равно)	Больше или равно
select * 
  from [HumanResources].[Employee] as t1
 where t1.SickLeaveHours >= 70;

-- <= (меньше или равно)	Меньше или равно
select * 
  from [HumanResources].[Employee] as t1
 where t1.SickLeaveHours <= 70;

-- !< (не меньше)	Не меньше (не определено стандартом ISO)
select * 
  from [HumanResources].[Employee] as t1
 where t1.SickLeaveHours !< 70;


-- !> (не больше чем)	Не больше
select * 
  from [HumanResources].[Employee] as t1
 where t1.SickLeaveHours !> 70;

--Предикат принадлежности диапазону - between 
select t1.*
  from [HumanResources].[Employee] as t1 
 where t1.SickLeaveHours >= 50 
   and t1.SickLeaveHours <= 100;

select *
  from [HumanResources].[Employee] as t1 
 where not t1.SickLeaveHours not between 50 and 100;

--Предикат принадлежности множеству - in
 select *
  from [HumanResources].[Employee] as t1 
 where t1.BusinessEntityID not in (3, 5, 6, 7)
 /*
       (t1.BusinessEntityID = 3 
	or t1.BusinessEntityID = 5
	or t1.BusinessEntityID = 6
	or t1.BusinessEntityID = 7)
	*/

--Предикат соответствия  шаблону - Like
select *
  from [HumanResources].[Employee] as t1 
 where -- t1.JobTitle like N'Tool_Des%';
                        -- Tool Designer
     not  t1.NationalIDNumber not  like N'[^1-6][^1-6][^1-6][^1-6][^1-6][^1-6][^1-6][^1-6]'
-- Трафаретные символыы
-- % - любое кол-во любых символов
-- _ - любой один сивол
-- [] - диапазон значений для символа - [0-9], [A-z][a-z], [А-я][а-я]
-- [^] - символ вне диапазона
-- escape -- экранирование трафаретного символа
select *
  from [HumanResources].[Employee] as t1 
 where not t1.JobTitle not like N'%#%%' escape '#'

 -- like '[0-9]'

/*
update [HumanResources].[Employee]
   set  JobTitle = N'Chief Exe%cutive Officer'
  where BusinessEntityID = 1
1
*/ 
-- Перидикат соответсвия NULL - IS
select * 
  from [HumanResources].[Employee] as t1 
 where t1.OrganizationLevel IS NULL
 --
--=====================================================================================================================
-- Наименование должности с наибольшим кол-вом сотр.
select top 1 
       with ties
       t1.JobTitle
  from [HumanResources].[Employee] as t1 
 group by t1.JobTitle
 order by count(distinct t1.BusinessEntityID) desc;
 /*
 Production Technician - WC40
Production Technician - WC50
Production Technician - WC60
 */

-- Наименование должности с наименьшим кол-вом сотр.
select top 1 
       with ties
       t1.JobTitle
  from [HumanResources].[Employee] as t1 
 group by t1.JobTitle
 order by count(distinct t1.BusinessEntityID) asc
 go
-- Рез. набор данных
select t1.*
  from [HumanResources].[Employee] as t1
 where 1 = 1
   and year(t1.HireDate) = 2008
   and (t1.JobTitle = N'Production Technician - WC40'
   or t1.JobTitle = N'Production Technician - WC50'
   or t1.JobTitle = N'Production Technician - WC60'
   or t1.jobTitle = N'Accounts Manager'
   or t1.jobTitle = N'Chief Financial Officer'
   or t1.jobTitle = N'Assistant to the Chief Financial Officer'
   or t1.jobTitle = N'Benefits Specialist'
   or t1.jobTitle = N'Document Control Manager'
   or t1.jobTitle = N'Engineering Manager'
   or t1.jobTitle = N'European Sales Manager'
   or t1.jobTitle = N'Facilities Administrative Assistant'
   or t1.jobTitle = N'Facilities Manager'
   or t1.jobTitle = N'Finance Manager'
   or t1.jobTitle = N'Human Resources Manager'
   or t1.jobTitle = N'Information Services Manager'
   or t1.jobTitle = N'Maintenance Supervisor'
   or t1.jobTitle = N'Marketing Manager'
   or t1.jobTitle = N'Master Scheduler'
   or t1.jobTitle = N'Network Manager'
   or t1.jobTitle = N'North American Sales Manager'
   or t1.jobTitle = N'Pacific Sales Manager'
   or t1.jobTitle = N'Production Control Manager'
   or t1.jobTitle = N'Purchasing Manager'
   or t1.jobTitle = N'Quality Assurance Manager'
   or t1.jobTitle = N'Quality Assurance Supervisor'
   or t1.jobTitle = N'Senior Design Engineer'
   or t1.jobTitle = N'Shipping and Receiving Supervisor'
   or t1.jobTitle = N'Vice President of Engineering'
   or t1.jobTitle = N'Vice President of Production'
   or t1.jobTitle = N'Vice President of Sales')
;


select t1.*
  from [HumanResources].[Employee] as t1
 where 1 = 1
   and year(t1.HireDate) = 2008
   and t1.jobTitle in (N'Production Technician - WC40',  N'Production Technician - WC50', N'Production Technician - WC60',
                       N'Accounts Manager', N'Chief Financial Officer', N'Assistant to the Chief Financial Officer', N'Benefits Specialist',
					   N'Document Control Manager', N'Engineering Manager', N'European Sales Manager', N'Facilities Administrative Assistant',
					   N'Facilities Manager', N'Finance Manager', N'Human Resources Manager', N'Information Services Manager', N'Maintenance Supervisor',
					   N'Marketing Manager', N'Master Scheduler', N'Network Manager', N'Purchasing Manager', N'Quality Assurance Manager', N'Quality Assurance Supervisor',
					   N'Senior Design Engineer', N'Shipping and Receiving Supervisor', N'Vice President of Engineering', N'Vice President of Production', N'Vice President of Sales', N'North American Sales Manager',
					   N'Pacific Sales Manager', N'Production Control Manager');










