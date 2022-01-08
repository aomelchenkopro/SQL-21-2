/*
Напишите запрос, который вернет список работников на должностях Document Control Assistant, Document Control Manager, Research and Development Manager,
Research and Development Engineer. Учитывайте только работников, которые не желают получать рекламные уведомления и  имеющих адрес электронной почты. 
Необходимы следующие данные работников: идент. работника, дата найма, ФИО в верхнем регистре без пробелов в начале строки (Title + LastName + FirstName + MiddleName),
дата рождения, семейное положение в строковом представлении (M = Married, S = Single),  адрес электронной почты.
- Используются таблицы: [HumanResources].[Employee], [Person].[Person], [Person].[EmailAddress] 
- Задействуйте внутренние соединение ANSI-92
- Рез. набор данных содержит: идент. работника, дату найма, ФИО, дату рождения, семейное положение в строковом представлении, адрес электронной почты
*/
--===========================================================================================================================================================
if object_id('tempdb.dbo.#employee') is not null drop table #employee;
create table #employee (
       BusinessEntityID             int,
	   HireDate                     date,
	   FullName                     nvarchar(150),
	   BirthDate                    date,
	   [MaritalStatusStrReflection] nvarchar(20)
);

-- Сотрудники, у которых есть почтовый адресс и нежелающие получать рек. уведомления
--if object_id('tempdb.dbo.#employee') is not null drop table #employee;
insert into #employee (BusinessEntityID, HireDate, FullName, BirthDate, [MaritalStatusStrReflection])
select t1.BusinessEntityID,
       t1.HireDate,
	   upper(concat_ws(N' ', ltrim(t2.Title), ltrim(t2.LastName), ltrim(t2.FirstName), ltrim(t2.MiddleName))) as [full_name],
	   t1.BirthDate,
	   case t1.MaritalStatus when N'M' then N'Married'
	                         when N'S' then N'Single' end as [MaritalStatus_str_reflection]
  --into #employee -- индексы, ограничения и триггеры, определенные в исходной таблице, не переносятся в новую таблицу
                 -- может наследовать свойство identity 
  -- https://docs.microsoft.com/ru-ru/sql/t-sql/queries/select-into-clause-transact-sql?f1url=%3FappId%3DDev15IDEF1%26l%3DRU-RU%26k%3Dk(into_TSQL);k(sql13.swb.tsqlresults.f1);k(sql13.swb.tsqlquery.f1);k(MiscellaneousFilesProject);k(DevLang-TSQL)%26rd%3Dtrue&view=sql-server-ver15
  from [HumanResources].[Employee] as t1
 inner join [Person].[Person] as t2 on t2.BusinessEntityID = t1.BusinessEntityID
                                   and t2.EmailPromotion = 0
 inner join [Person].[EmailAddress] as t3 on t3.BusinessEntityID = t1.BusinessEntityID
                                         and t3.EmailAddress is not null
 where t1.JobTitle in (N'Document Control Assistant', N'Document Control Manager', 
                       N'Research and Development Manager', N'Research and Development Engineer')
 order by HireDate desc, 
          BusinessEntityID asc
;
										
select * 
  from #employee;
										
--===========================================================================================================================================================		
-- LEFT OUTER JOIN
select t1.BusinessEntityID,
       t2.*
  from [HumanResources].[Employee]        as t1 
  left outer join [Person].[EmailAddress] as t2 on t2.BusinessEntityID = t1.BusinessEntityID
 where t2.[EmailAddress]is null;								

-- delete from [Person].[EmailAddress] where BusinessEntityID = 263; 
-- delete from [Person].[EmailAddress] where BusinessEntityID = 78;
-- delete from [Person].[PersonPhone] where BusinessEntityID = 78;

-- Елена
select * 
  from [HumanResources].[Employee] as t1 
  left outer join [Person].[PersonPhone] as t2 on t2.BusinessEntityID = t1.BusinessEntityID 
  where t2.BusinessEntityID is null;

-- Дарья
select *
  from [HumanResources].[Employee] as t1
  left outer join [Person].[PersonPhone] as t2 on t2.BusinessEntityID = t1.BusinessEntityID 
 where t2.PhoneNumber is null;

-- Янина
select *
from [HumanResources].[Employee] as t1
left outer join [Person].[PersonPhone] as t2 on t2.BusinessEntityID = t1.BusinessEntityID
where t2.PhoneNumber is null
;

-- Александр
select * 
    from [HumanResources].[Employee] as t1 
 left outer join [Person].[PersonPhone] as t2 on t2.BusinessEntityID=t1.BusinessEntityID 
  where t2.BusinessEntityID is null 
;

-- Анастася
select t1.BusinessEntityID,
       t2.*
from [HumanResources].[Employee]       as t1
left outer join [Person].[PersonPhone] as t2 on t2.BusinessEntityID = t1.BusinessEntityID
where t2.PhoneNumber is null


select t1.BusinessEntityID,
       t2.*
  from [HumanResources].[Employee]           as t1
  left outer join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                                  and year(t2.OrderDate) = 2011
												  -- Поиск пустых значений в столбце 
												  -- and t2.[SalesOrderID] is null
	   -- Поиск null заглушек, которые образовались в рез. левого внешнего соединения 
 where t2.[SalesOrderID] is null;
--===========================================================================================================================================================
-- RIGHT OUTER JOIN
select t2.BusinessEntityID,
       t1.*
  from  [Sales].[SalesOrderHeader] as t1
  right outer join [HumanResources].[Employee] as t2 on t1.SalesPersonID = t2.BusinessEntityID
                                                   and year(t1.OrderDate) = 2011

 where t1.[SalesOrderID] is null;
--===========================================================================================================================================================
-- FULL OUTER JOIN 
select t1.BusinessEntityID,
       t2.SalesOrderID,
       t2.OrderDate,
	   t2.SalesPersonID,
	   t2.SubTotal
  from [HumanResources].[Employee]           as t1
  full outer join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                                  and year(t2.OrderDate) = 2011
;
--===========================================================================================================================================================
-- CROSS JOIN ANSI-89
select t2.BusinessEntityID,
       t2.EmailAddress
  from [HumanResources].[Employee] as t1,
       [Person].[EmailAddress] as t2
-- where t1.BusinessEntityID = t2.BusinessEntityID
select count(*) from [HumanResources].[Employee]; -- 290
select count(*) from  [Person].[EmailAddress]; -- 19970

-- CROSS JOIN ANSI-92
select t1.*,
       t2.*
  from [HumanResources].[Employee] as t1
  cross join [Person].[EmailAddress] as t2
--===========================================================================================================================================================
/*
Задача 1 
Для каждого отдельного сотрудника сформировать комплекты строк - месяца 2011 года.
Внесите список месяцов 2011 года в отдельную временную локальную таблицу
- Используется таблица [HumanResources].[Employee] 
- Задействуйте cross join
*/
-- Елена
if object_id('[tempdb].dbo.#period') is not null drop table #period; 
create table #period( 
 [month]   int,
 flag nchar(1) null
); 
 
insert into #period([month])
 values (201101), 
        (201102), 
     (201103), 
     (201104), 
     (201105), 
        (201106), 
     (201107), 
     (201108), 
     (201109), 
        (201110), 
     (201111), 
     (201112) 
; 
 
select t1.BusinessEntityID, 
  t2.[month],
  t2.flag
 from [HumanResources].[Employee] as t1 
 cross join #period as t2 
order by t1.BusinessEntityID desc  
;

-- Анастасия
drop table #months2011;
create table #months2011 ([PERIOD] nvarchar(6), flag nchar(1));
insert into #months2011 ([PERIOD])
values (N'201101'), 
(N'201102'),
(N'201103'),
(N'201104'),
(N'201105'),
(N'201106'),
(N'201107'),
(N'201108'),
(N'201109'),
(N'201110'),
(N'201111'),
(N'201112');
 
select t1.BusinessEntityID,
       t2.*
from [HumanResources].[Employee]       as t1
cross join #months2011                 as t2
order by t1.BusinessEntityID asc;

-- Александр
if object_id('[tempdb].dbo.#month') is not null drop table #month;                                   
   create table #month ([month] nvarchar (6), flag nchar) 
; 
 
insert into #month ([month]) 
 values (N'012011'), (N'022011'), (N'032011'), (N'042011'), (N'052011'), (N'062011'), (N'072011'), 
        (N'082011'), (N'092011'), (N'102011'), (N'112011'), (N'122011') 
; 
 
select t1.BusinessEntityID, t2.* 
   from [HumanResources].[Employee] as t1 
   cross join #month as t2 
  order by t1.BusinessEntityID asc 
 
;

-- Янина
 if object_id ('tempdb.dbo.#monthperiod') is not null drop table tempdb.dbo.#monthperiod
create table #monthperiod(
[monthperiod] int, flag nchar(1));
insert into #monthperiod([monthperiod])
values (201101),
(201102),
(201103),
(201104),
(201105),
(201106),
(201107),
(201108),
(201109),
(201110),
(201111),
(201112);

select t1.BusinessEntityID,
       t2.[monthperiod],
	   t2.flag
from [HumanResources].[Employee] as t1
cross join #monthperiod as t2
order by  t1.BusinessEntityID desc;

-- Дарья
if object_id('[tempdb].dbo.#employee') is not null drop table #employee; 
  create table #employee (
  
  [Date] int,
  flag nchar(1)
  )
  insert into #employee([Date])
  values (201101),
         (201102),
         (201103),
     (201104),
     (201105),
     (201106),
     (201107),
     (201108),
     (201109), 
     (201110),
     (201111),
     (201112)


  select t1.BusinessEntityID, 
  t2.[Date],
  t2.flag
 from [HumanResources].[Employee] as t1 
 cross join #employee as t2 
order by t1.BusinessEntityID desc
--===========================================================================================================================================================
[HumanResources].[Employee]
[Sales].[SalesOrderHeader]


-- Елена
select t1.BusinessEntityID, 
  count([SalesOrderID]) 
 from [HumanResources].[Employee] as t1 
inner join [Sales].[SalesOrderHeader] as t2 on t2.[SalesPersonID]= t1.BusinessEntityID 
 and year(t2.OrderDate) = 2011 
 where t1.Gender = N'M' 
group by t1.BusinessEntityID 
order by t1.BusinessEntityID desc 
;

-- Анастасия
select t1.BusinessEntityID,
    count (t3.SalesOrderID) as [QTY]
from [HumanResources].[Employee]       as t1
inner join [Sales].[SalesOrderHeader]  as t3 on t3.SalesPersonID = t1.BusinessEntityID
                                            and year (t3.OrderDate) = 2011
where t1.Gender = N'M' 
group by t1.BusinessEntityID
order by t1.BusinessEntityID asc
;

-- Янина
select t1.BusinessEntityID,
count (distinct(t2.[SalesOrderID])) as [orderID]
from [HumanResources].[Employee] as t1
inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
and year(t2.OrderDate) in (2011)

where t1.Gender = N'M'

group by t1.BusinessEntityID
order by t1.BusinessEntityID desc;

-- Александр
select t1.BusinessEntityID, 
       count (t2.[SalesOrderID]) as [OrderCount] 
       --t1.Gender 
    --t2 
  from [HumanResources].[Employee] as t1 
 
    inner join [Sales].[SalesOrderHeader] as t2 on t2.[SalesPersonID]=t1.BusinessEntityID 
                                         and year (t2.OrderDate)= 2011 
  where t1.Gender in (N'M') 
  group by t1.BusinessEntityID 
order by BusinessEntityID asc 
;
--===========================================================================================================================================================
select t2.SalesPersonID,
       count(distinct t2.SalesOrderID) as [ordQty]
  from [HumanResources].[Employee] as t1 
 inner join [Person].[EmailAddress] as t3 on t3.BusinessEntityID = t1.BusinessEntityID
                                         and t3.EmailAddress like '%@%'
 inner join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID = t1.BusinessEntityID
                                            and t2.OrderDate between '20110101' and '20111231 23:59:59'

 where t1.Gender = N'M'
 group by t2.SalesPersonID
 order by [ordQty] desc;
 --===========================================================================================================================================================
 /*
 Напишите запрос, который вернет кол-во уникальных товаров. 
 Учитывайте только товары, которые не продавались в 2011 году
 - Используются таблицы: [Production].[Product],[Sales].[SalesOrderDetail], [Sales].[SalesOrderHeader]
 - Задействуйте внешнее соединение
 - Рез. набор данных содержит: кол-во уникальных товаров
*/
select count(distinct t1.ProductID)
  from [Production].[Product] as t1 
  left outer join [Sales].[SalesOrderDetail] as t2 on t2.ProductID = t1.ProductID
  left outer join [Sales].[SalesOrderHeader] as t3 on t3.SalesOrderID = t2.SalesOrderID
                                                  and t3.OrderDate between '20110101' and '20111231 23:59:59'
where t3.[SalesOrderID] is null;


select count(t1.ProductID),
       count(distinct t1.ProductID)
  from [Production].[Product] as t1 
  left outer join [Sales].[SalesOrderDetail] as t2 on t2.ProductID = t1.ProductID
  left outer join [Sales].[SalesOrderHeader] as t3 on t3.SalesOrderID = t2.SalesOrderID
                                                  and t3.OrderDate between '20110101' and '20111231 23:59:59'
where t3.[SalesOrderID] is null;


select distinct 
       year(t1.OrderDate)
  from [Sales].[SalesOrderHeader] as t1 
  join [Sales].[SalesOrderDetail] as t2 on t2.SalesOrderID = t1.SalesOrderID
                                       and t2.ProductID = 870;

  