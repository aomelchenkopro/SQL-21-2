-- Ограничения целостности данных
	/*
	  not null    -- запрещает хранение пустых значений
	  primary key -- первичный ключ таблицы. В таблице может только один первичный ключ, который может состовным т.е. состоять сразу из нескольких аттрибутов. Обеспечивает логическую целостность
	  unique      -- резервный/ альтернативный ключ. В таблице может быть не ограниченное кол-во unique
						unique может быть составным
						Можно хранить null значения 
	  check       -- задает правила для проверки значений атрибута 
	  foreign key -- Внешний ключ. Обеспечивает ссылочную целостность
	*/

-- Определение контекста базы данных
use [AdventureWorks];

-- Создание схемы (коллекция объектов)
go
create schema LEVELUP;
	-- Удаление схемы
			-- drop schema LEVELUP;

-- Создание таблицы для хранения данных сотрудников 

-- Проверка ну существование объекта - таблица 
   -- cntrl + shift + l
go -- select object_id('[LEVELUP].[EMPLOYEE]', 'U');

if object_id('[LEVELUP].[EMPLOYEE]', 'U') is not null drop table [LEVELUP].[EMPLOYEE];
create table [LEVELUP].[EMPLOYEE] (
       [AUTO_INCREMENT] int          identity(1, 1)              not null,            -- автоинкремент (заполнять аттрибут не нужно)
	   [EMP_ID]         int                                      not null,            -- первичный ключ таблицы, который обеспечивает уникальность строк в таблице (значения аттрибута не могут дублироваться)
	   [REGION]         char(1)                                  not null,            -- регион в котором работает сотрудник
	-- [LOGIN]          nvarchar(50) primary key                 not null,            -- логин сотрудника - пример не составного первичного ключа
	   [OFFICE_ID]      int                                      null      default 0, -- идент. офиса
	   [MANAGER_ID]     int                                      null      default 0, -- идент. руководителя сотрудника
	   [INN]            nchar(12)    unique                      not null,            -- код инн
	   [NAME]           nchar(50)                                not null,            -- имя сотрудника
	   [LAST_NAME]      nchar(50)                                not null,            -- фамилия сотрудника
	   [MIDDLE_NAME]    nchar(50)                                null,                -- отчество сотруника
	   [PHONE_NUMBER]   nvarchar(25) unique                      not null,            -- номер телефона сотрдуника
	   [EMAIL]          nvarchar(50) unique                      not null,            -- адрес электронной почты
	   [BIRTH_DATE]     date                                     not null,            -- дата рождения
	   [GENDRE]         nchar(1) check([GENDRE] in (N'M', N'F')) not null             -- пол сотрудника

	   -- определние составного первичного ключа
	   constraint EMPLOYEE_PK primary key (/*REGION] desc, */[EMP_ID] asc),
	   -- определение ограничения целостности check
	   constraint INN_LEN check (len(replace([INN],' ', '')) = 12 and try_convert(int, [INN]) is not null),
	   -- определение внешнего ключа - офис
	   constraint [OFFICE_ID_FK] foreign key ([OFFICE_ID]) references [LEVELUP].[OFFICE] ([OFFICE_ID]) on delete no action on update no action,
	                                                                                                -- on delete cascade on update cascade 
																									-- on delete set default on update set default
																									-- on delete set null on updaet set null
	   -- определение внешнего ключа - руководитель сотрудника
	   constraint [MANAGER_ID_FK] foreign key ([MANAGER_ID]) references [LEVELUP].[EMPLOYEE]([EMP_ID])

	 
);
go
/*
-- Модификация объекта - изменения структуры
alter table [LEVELUP].[EMPLOYEE]
	add constraint EMPLOYEE_PK primary key (AUTO_INCREMENT, EMP_ID);

alter table [LEVELUP].[EMPLOYEE]
	add constraint INN_LEN check (len([INN]) = 12 and try_convert(bigint, [INN]) is not null);

alter table [LEVELUP].[EMPLOYEE]
	drop constraint INN_LEN;

*/




--========================================================================================================================================
-- Создание таблицы для хранения данных офисов в котором работают сотрудники
if object_id('[LEVELUP].[OFFICE]', 'U') is not null drop table [LEVELUP].[OFFICE];
create table [LEVELUP].[OFFICE] (
       [OFFICE_ID]  int          primary key not null,       -- идент. офиса
	   [CITY_ID]    int                      null default 0, -- город в котором расположен офис 
	   [NAME]       nvarchar(50)             not null,       -- наименование офиса
	   [MANAGER_ID] int                      null default 0, -- идент. руководителя офиса
	   constraint [CITY_ID_FK] foreign key ([CITY_ID]) references [LEVELUP].[CITY] ([CITY_ID])
);
go
-- Внесение данных в таблицу офисов
insert into [LEVELUP].[OFFICE]([OFFICE_ID], [CITY_ID], [NAME])
values(0, 2, 'lviv-office');

insert into [LEVELUP].[OFFICE]([OFFICE_ID], [CITY_ID], [NAME])
values(1, 0, 'kyiv-office');

insert into [LEVELUP].[OFFICE]([OFFICE_ID], [CITY_ID], [NAME])
values(2, 1, 'dnipro-office');

insert into [LEVELUP].[OFFICE]([OFFICE_ID], [CITY_ID], [NAME])
values(3, null, 'Vancouver-office');
-- select * from [LEVELUP].[OFFICE];
--========================================================================================================================================
-- Создание таблицы для хранения данных о городах
if object_id('[LEVELUP].[CITY]', 'U') is not null drop table [LEVELUP].[CITY];
create table [LEVELUP].[CITY] (
       [CITY_ID]    int          primary key not null,       -- идент. офиса
	   [NAME]       nvarchar(50)             not null,       -- наименование офиса
	   [COUNTRY]    int                      null default 0  -- идент. страны
);

-- Внесение данных в таблицу городов
insert into [LEVELUP].[CITY] ([CITY_ID], [NAME], [COUNTRY] )
values (0, N'Kyiv', 0),
       (1, N'Dnipro', 0),
	   (2, N'Lviv', 0);

/*
insert into [LEVELUP].[CITY] ([CITY_ID], [NAME], [COUNTRY] )
values(8, N'Bangladesh', 103);
delete from [LEVELUP].[CITY]  where [CITY_ID] = 8;
*/

-- select * from [LEVELUP].[CITY]

--========================================================================================================================================
-- Выборка данных из таблицы сотрудников
SELECT [AUTO_INCREMENT]
      ,[EMP_ID]
      ,[REGION]
      ,[OFFICE_ID]
      ,[MANAGER_ID]
      ,[INN]
      ,[NAME]
      ,[LAST_NAME]
      ,[MIDDLE_NAME]
      ,[PHONE_NUMBER]
      ,[EMAIL]
      ,[BIRTH_DATE]
      ,[GENDRE]
  FROM [AdventureWorks].[LEVELUP].[EMPLOYEE]

insert into [LEVELUP].[EMPLOYEE] (/*[AUTO_INCREMENT],*/ [EMP_ID], [REGION], [OFFICE_ID], [MANAGER_ID], [INN], [NAME], [LAST_NAME], [MIDDLE_NAME], [PHONE_NUMBER], [EMAIL], [BIRTH_DATE], [GENDRE])
values (0, N'W', 0, 0, N'123456789023', N'Adan', N'Jeffress', null, N'307-617-5197', N'hgaber1@shutterfly.com', N'19700101', N'M');

insert into [LEVELUP].[EMPLOYEE] (/*[AUTO_INCREMENT],*/ [EMP_ID], [REGION], [OFFICE_ID], [MANAGER_ID], [INN], [NAME], [LAST_NAME], [MIDDLE_NAME], [PHONE_NUMBER], [EMAIL], [BIRTH_DATE], [GENDRE])
values (1, N'W', 0, 0, N'987456789023', N'Nerty', N'Lashmore', null, N'853-810-0217', N'nlashmore6@vinaora.com', N'19900220', N'F');

insert into [LEVELUP].[EMPLOYEE] (/*[AUTO_INCREMENT],*/ [EMP_ID], [REGION], [OFFICE_ID], [MANAGER_ID], [INN], [NAME], [LAST_NAME], [MIDDLE_NAME], [PHONE_NUMBER], [EMAIL], [BIRTH_DATE], [GENDRE])
values (2, N'W', 0, 1, N'733856789023', N'Creighton', N'Ilson', null, N'482-788-6304', N'wmccutheonh@dot.gov', N'19800321', N'M');
		

--delete from [LEVELUP].[EMPLOYEE] where EMP_ID = 1;

-- Тип данных строковой константы
select sql_variant_property(N'123456789023','BaseType') AS 'Base Type'
select len(N'123456789023')
select try_convert(int, N'123456789023')
--====================================================================================================================
-- Выборка данных из таблицы сотрудников
SELECT [AUTO_INCREMENT]
      ,[EMP_ID]
      ,[REGION]
      ,[OFFICE_ID]
      ,[MANAGER_ID]
      ,[INN]
      ,[NAME]
      ,[LAST_NAME]
      ,[MIDDLE_NAME]
      ,[PHONE_NUMBER]
      ,[EMAIL]
      ,[BIRTH_DATE]
      ,[GENDRE]
  FROM [AdventureWorks].[LEVELUP].[EMPLOYEE];

select * from [LEVELUP].[OFFICE];
select * from [LEVELUP].[CITY];
