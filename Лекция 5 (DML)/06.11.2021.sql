-- Data definition language - язык определения данных
/*
Инструкции языка описания данных DDL определяют структуры данных. 
Эти инструкции используются для создания, изменения и удаления структур данных в базе данных. 
Эти инструкции включают в себя:
ALTER
CREATE
DROP
TRUNCATE TABLE
*/

-- CREATE - создание объекта
-- ALTER - изменение объекта
-- DROP - удаление обьекта
-- TRUNCATE TABLE
	--Удаляет все строки в таблице или указанные секции таблицы, 
	-- не записывая в журнал удаление отдельных строк. Инструкция TRUNCATE TABLE 
	-- похожа на инструкцию DELETE без предложения WHERE, однако TRUNCATE TABLE выполняется 
	-- быстрее и требует меньших ресурсов системы и журналов транзакций.

-- Полная очистка таблицы (В режиме не полного журналирования)
truncate table [BUSINESS].[EMAILS];

-- Data manipulation language - язык манипулирования данными 
-- BULK INSERT
-- DELETE - удаление строк из таблицы
-- INSERT - внесение строк в таблицу 
-- SELECT - извлечение строки из таблицы
-- UPDATE - обновления строк в таблице 
-- MERGE - слияние данных(внесение/обновления/удаление) строк в таблицах 

-- Создание таблицы для хранения данных офисов 
if object_id('[LEVELUP].[OFFICE_NEW]', 'U') is not null 
	begin
	    declare @message as nvarchar(50) = concat('The object ',object_id('[LEVELUP].[OFFICE_NEW]', 'U'), ' was deleted')
	  
	  
		drop table [LEVELUP].[OFFICE_NEW];
		print (@message)
		
	end
create table [LEVELUP].[OFFICE_NEW] (
       [OFFICE_ID]  int primary key,                      -- идент. офиса
	   [CITY]       nvarchar(50)   not null,              -- наименование города, котором расположен офиса
	   [MANAGER_ID] int            null,                  -- идент. руководителя офиса
	   [QUOTA]      numeric(15, 2) not null default 0.00, -- цель по продажам
	   [SALES]      numeric(15, 2) not null default 0.00  -- текущие продажи
);

-- DML - insert - внесение строк в таблицу
insert into [LEVELUP].[OFFICE_NEW] ([OFFICE_ID], [CITY], [MANAGER_ID], [QUOTA], [SALES])
values(1, N'NewYork', null, 30000.00, 0.00);

insert into [LEVELUP].[OFFICE_NEW] ([OFFICE_ID], [CITY], [MANAGER_ID], [QUOTA], [SALES])
values(2, N'London', null, 40000.00, 0.00),
      (3, N'Kyiv', null, 30000.00, 0.00),
	  (4, N'Bangkok', null, 30000.00, 0.00),
	  (5, N'Dnipro', null, 30000.00, 0.00);

insert into [LEVELUP].[OFFICE_NEW]
values(6, N'Tokio', null, 30000.00, 0.00);


-- DML - delete - удаление строк
delete from [LEVELUP].[OFFICE_NEW]
       from [LEVELUP].[OFFICE_NEW]
	   /*
	   inner join...
	   */
      where OFFICE_ID = 2;


-- DML - update - обновление строк в таблице
update [LEVELUP].[OFFICE_NEW] 
   set MANAGER_ID = 100,
       QUOTA = 40000.00
  from [LEVELUP].[OFFICE_NEW]  as t1
  /*
  inner join ...
  */
  where OFFICE_ID = 3;

-- select * from [LEVELUP].[OFFICE_NEW]

--==============================================================================================================================================================
-- SELECT

use [AdventureWorks3];

-- SELECT --извлечение строк из таблицы



-- Обязательные фазы 
1 select     5  -- фаза select - определяет имя столбцов результирующего набора данных

	2   from     1  -- фаза from - определяет имя таблица из которых извекаются строки 

		-- Необязательные фазы
		3  where     2  -- фаза where - фильтрует строки 
		4  group by  3  -- фаза group by формирует группы строк
		5 having     4  -- фаза having фильтрует группы строк
		6  order by  6  -- фаза order by сортирует результирующий набор данных


-- Вырожденный вариант иснтрукции select
select getdate();

-- Минимальный набор фаз инструкции select (при извлечении данных из таблицы)
select *
  from [HumanResources].[Employee];

-- Фаза where
select t1.* -- * - все столбцы таблицы/ рез. набора данных
  from [HumanResources].[Employee] as t1
    -- Фильтрация строк
 where t1.Gender = N'M'
   and t1.JobTitle = N'Network Administrator';

-- Фаза group by
select t1.JobTitle,                               -- Наименование должности
       count(t1.BusinessEntityID) as [EMP_QTY]    -- Кол-во сотрудников
  from [HumanResources].[Employee] as t1
   -- Фильтрация строк
 where t1.Gender = N'M'
  -- формирование групп строк
 group by t1.JobTitle;

/*
select t1.JobTitle,
       t1.BusinessEntityID
  from [HumanResources].[Employee] as t1 
 where t1.Gender = N'M'
   and t1.JobTitle = N'Buyer';
*/

select t1.Gender,
       count(t1.BusinessEntityID) as [EMP_QTY]
  from [HumanResources].[Employee] as t1
 group by t1.Gender;

select t1.Gender, 
       t1.JobTitle,
	   count(t1.BusinessEntityID) as [EMP_QTY]
  from [HumanResources].[Employee] as t1
 group by t1.Gender, 
          t1.JobTitle;

-- Фаза having - фильтрация строк
select t1.Gender,
       t1.JobTitle,
       count (t1.BusinessEntityID) as [EMP_QTY]
from [HumanResources].[Employee] as t1
where  t1.JobTitle != N'Accountant'
group by t1.JobTitle,
         t1.Gender
having count(t1.BusinessEntityID) > 1;


select t1.JobTitle,
       count(t1.BusinessEntityID) as [EMP_QTY]
  from [HumanResources].[Employee] as t1 
 group by t1.JobTitle
having count(t1.BusinessEntityID) = 3

-- Фаза order by  
select t1.JobTitle,
       count(t1.BusinessEntityID) as [EMP_QTY]
  from [HumanResources].[Employee] as t1 
 where t1.JobTitle != N'Marketing Assistant'
 group by t1.JobTitle
having count(t1.BusinessEntityID) > 3
order by [EMP_QTY] desc, t1.JobTitle asc;-- asc / desc

/*
Напишите запрос, который вернет кол-во сотрудников в разрезе должности и семейного положения.
Не учитывайте сотрудников женского пола. Учитывайте должности с количеством сотрудников 3 и более.
- Результирующий набор данных содержит: наименование должности, семейное положение, кол-во сотрудников
- Отсортировать результирующий набора данных по кол-ву сотрудников (по убыванию)
*/

-- Кол-во сотрудников в разрезе должности и семейного положения
select t1.JobTitle,                            -- должность
       t1.MaritalStatus,                       -- семейное положение
	   count(t1.BusinessEntityID) as [EMP_QTY] -- кол-во сотрудников
  from [HumanResources].[Employee] as t1
 where 1 = 1 
    -- Не учитывайте сотрудников женского пола
   and t1.Gender != N'F'
 group by t1.JobTitle,                            
          t1.MaritalStatus
	-- Учитывайте должности с количеством сотрудников 3 и более
having count(t1.BusinessEntityID) >= 3
 order by [EMP_QTY] desc;