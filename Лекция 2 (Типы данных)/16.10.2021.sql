/*
Создать таблицу (в вашей схеме - your_surname ) 
Customers (уникальный идент, имя, фамилия, отчество, пол, дата рождения, возраст,
номер телефона, электронный адре, адрес проживания)
*/

-- Создание схемы (коллекция объектов)
create schema [omelchenko];
go
-- Создание таблицы для хранения данных о клиентах
create table [omelchenko].[Customers] (
       [ID]           int           -- идент. клиента
	  ,[NAME]         nvarchar(50)  -- имя 
	  ,[LAST_NAME]    nvarchar(50)  -- фамилия 
	  ,[MIDDLE_NAME]  nvarchar(50)  -- отчество
	  ,[GENDER]       char(1)       -- пол f/m
	  ,[BIRTH_DATE]   date          -- дата рождения
	  ,[AGE]          tinyint       -- кол-во лет
	  ,[PHONE_NUMBER] nvarchar(50)  -- номер телефона
	  ,[EMAIL]        nvarchar(50)  -- адрес электронной почтыы
	  ,[ADDRESS]      nvarchar(500) -- адрес проживания
);

-- Александр
--Создать таблицу (в вашей схеме - your_surname ) Customers (уникальный идент, имя, фамилия, отчество, пол, дата рождения, возраст, номер телефона, электронный адре, адрес проживания)
create table [Molchanov].[Customers] (
       [ID]         int            --уникальный идент
	  ,[NAME]       nvarchar(50)   --имя
	  ,[SURNAME]    nvarchar(50)   --фамилия
	  ,[PATRONYMIC] nvarchar(50)   --отчество
	  ,[GENDER]     nvarchar (20)  --пол
	  ,[BIRTH_DATE] date           --дата рождения
	  ,[AGE]        tinyint        --возраст
	  ,[PHONE]      nvarchar (20)  --номер телефона
	  ,[EMAIL]      nvarchar (50)  --электронный адрес
      ,[ADRESS]     nvarchar (500) --адрес проживания  
);

-- Удаление объектов с помощью команды drop
-- drop table [Molchanov].[Customers];
-- drop schema [Molchanov];

--================================================================================

/*
Автор скрипта Янина
Дата 14.10.2021
*/

--create schema Yanina
create table [YANINA].[DATA_CUSTOMERS]
(
  [ID]           int
 ,[NAME]         nvarchar(50)
 ,[LAST_NAME]    nvarchar(50)
 ,[MIDDLE_NAME]  nvarchar(50)
 ,[AGE]          int
 ,[BIRTHDAY]     date
 ,[GENDER]       char(1)
 ,[PHONE_NUMBER] nchar (15)
 ,[EMAIL]        nvarchar(40)
 ,[ADDRESS]      nvarchar(50)
 );

--================================================================================
use AdventureWorks2012
go
create schema SQL21_1_MIROSHNYCHENKO  
create table [SQL21_1_MIROSHNYCHENKO].[Customers](
      [ID]            int
	 ,[NAME]          nvarchar (30)
	 ,[LAST_NAME]     nvarchar (40)
	 ,[MIDDLE_NAME]   nvarchar (40)
	 ,[GENDER]        char(1)
	 ,[DATE_OF_BIRTH] date
	 ,[AGE]           tinyint
	 ,[PHONE_NUMBER]  nvarchar (20)
	 ,[EMAIL]         nvarchar (40)
	 ,[ADRESS]        nvarchar (500)
	 );
--================================================================================
-- Создание таблицы
create table [Paseka].[Customers](
         [ID]                 int             -- уникальный идент
		,[first_name]         nvarchar(50)    -- имя
	    ,[last_name]          nvarchar(50)    -- фамилия
		,[patronymic]         nvarchar(50)    -- отчество
		,[gender]             char(1)         -- пол
		,[date_of_birth]      date            -- дата рождения
		,[age]                tinyint         -- возраст
	    ,[phone_number]       tinyint         -- номер телефона
		,[email_address]      nvarchar(50)    -- электронный адреc
		,[residence_address]  nvarchar(500)    -- адрес проживания
);
--================================================================================
-- уникальный идент, имя, фамилия, отчество, пол, дата рождения, возраст, номер телефона, электронный адре, адрес проживания
create table [THOMAS].[CUSTOMERS](
			 [ID]                  int          -- уникальный идент
			,[NAME]                varchar(50)  -- имя
			,[LAST_NAME]           varchar(50)  -- фамилия
			,[SECOND_NAME]         varchar(50)  -- отчество
			,[GENDER]              char(1)      -- пол
			,[DATE_OF_BIRTH]       date         -- дата рождения
			,[AGE]                 tinyint      -- возраст
			,[PHONE_NUMBER]        varchar(15)  -- номер телефона  
			,[E_MAIL]              varchar(20)  -- электронный адреc
			,[ADDRESS]             varchar(100) -- адрес проживания
);
--=======================================================================================================================================================
-- Удаление объекта - таблицы
--drop table [omelchenko].[employee];
-- Создание таблицы работник
create table [omelchenko].[employee](
       [ID]           bigint  identity(1, 1) not null             -- автоинкремент
      ,[EMP_ID]       bigint                 not null             -- идент. работника
	  ,[NAME]         nvarchar(50)           not null             -- имя работника
	  ,[LAST_NAME]    nvarchar(50)           not null             -- фамилия работника
	  ,[MIDDLE_NAME]  nvarchar(50)           null default N'None' -- отчество работника
	  ,[SALARY]       decimal(15, 2)         null default 0.00    -- оклад
	  ,[BONUS]        numeric(15, 2)         null default 0.00    -- бонус
	  ,[FINE]         money                  null default $0.00   -- штрафы
	  ,[VACATION_PAY] smallmoney             null default $0.00   -- отпускные 
	  -- cntrl + shift + u - верхний регистр
	  -- cntrl + shift + l - нижний регистр
	  ,[HIRE_DATE]    date                   not null             -- дата найма
	  ,[MODIFY_DATE]  datetime2              not null             -- дата последнего изменения строки
);

/*
insert into /*[AdventureWorks2012].*/[omelchenko].[employee]([EMP_ID], [NAME], [LAST_NAME], [MIDDLE_NAME])
values(1, 'Jon', 'Snow', null);

insert into /*[AdventureWorks2012].*/[omelchenko].[employee]([EMP_ID], [NAME], [LAST_NAME], [MIDDLE_NAME])
values(92, 'Daenerys', 'Targaryen', null),
      (93, 'Khal', 'Drogo', null);

insert into /*[AdventureWorks2012].*/[omelchenko].[employee]([EMP_ID], [NAME], [LAST_NAME], [MIDDLE_NAME])
values(100, 'Tyrion', 'Lannister', null);

insert into /*[AdventureWorks2012].*/[omelchenko].[employee]([EMP_ID], [NAME], [LAST_NAME], [MIDDLE_NAME])
values(101, 'Jaime', 'Lannister', null);
*/

insert into [omelchenko].[employee] ([EMP_ID], [NAME], [LAST_NAME], [MIDDLE_NAME]
	,[SALARY], [BONUS], [FINE], [VACATION_PAY],[HIRE_DATE],[MODIFY_DATE])
values(1, N'Jon', N'Snow', null, 5000.00, 1000.00, 400.00, 0, '20211016', getdate());

insert into [omelchenko].[employee] ([EMP_ID], [NAME], [LAST_NAME], [MIDDLE_NAME]
	,[SALARY], [BONUS], [FINE], [VACATION_PAY],[HIRE_DATE],[MODIFY_DATE])
values(2, N'Daenerys', N'Targaryen', null, 15000.00, 1000.00, 0.00, 0, '20211016', getdate()),
      (3, N'Khal', N'Drogo', null, 35000.00, 1000.00, 0.00, 0, '20211016', getdate());

insert into [omelchenko].[employee] ([EMP_ID], [NAME], [LAST_NAME], [MIDDLE_NAME]
	,[SALARY], [BONUS], [FINE], [VACATION_PAY],[HIRE_DATE],[MODIFY_DATE])
values(4, N'Jaime', N'Lannister', null, 5000.00, 1000.00, 400.1234, 0, '20211016', getdate());      
      
      

-- Выборка данных с таблицы
select * -- * все столбцы таблицы
  from [omelchenko].[employee]
;

 -- PRODUCT
 -- автоинкремент 
 -- идент. производителя товара (не более 6 букв и цифр. Обычно 6 символов)
 -- идент. товара (не более 6 букв и цифр. Обычно 6 символов)
 -- Краткое наименование товара
 -- Полное наименование товара
 -- тип (standart, gold, platinum)
 -- цвет
 -- 0 - собственное производство, 1 - закупка
 -- кол-во единиц. товара на складе
 -- цена за единицу 
 -- дата поставки 
 -- дата производства
 -- дат и время поледнего изменения сроки


 --ORDER
 -- автоинкермент
 -- идент. заказ (число)
 -- идент. производителя товара (не более 6 букв и цифр. Обычно 6 символов)
 -- идент. товара (не более 6 букв и цифр. Обычно 6 символов)
 -- идент. сотрудника (число)
 -- идент. клиент (число)
 -- кол-во заказнных единиц товара (число)
 -- сумма заказа (денежная величина)
 -- дата и время проведения заказа
 -- дата и время последнего изменения строки

