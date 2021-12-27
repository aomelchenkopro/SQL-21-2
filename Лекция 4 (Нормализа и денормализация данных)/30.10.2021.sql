-- Создание таблицы для хранения данных о клиентах
if object_id('[LEVELUP].[CUSTOMER]', 'U') is not null drop table [LEVELUP].[CUSTOMER];
create table [LEVELUP].[CUSTOMER] (
       [CLIENT_ID]     int                    identity(1, 1) primary key, -- идент. клиента
	   [NAME]          nvarchar(50) not null,                             -- имя 
	   [SURNAME]       nvarchar(50) not null,                             -- фамилия
	   [PATRONYMIC]    nvarchar(50) null,                                 -- отчество
	   [DATE_OF_BIRTH] date         not null                              -- дата рождения
);

-- Внесение данных в таблицу клиентов
insert into [LEVELUP].[CUSTOMER] ([NAME], [SURNAME], [PATRONYMIC], [DATE_OF_BIRTH])
values (N'Donald', N'Morgan', null, '19840210'),
       (N'Jonathan', N'Martin', null, '19820210'),
	   (N'Jimmie', N'Lewis', null, '19860309'),
	   (N'Jason', N'Green', null, '19880410');
--=================================
/*
-- Добавление нового столбца в таблицу
alter table [LEVELUP].[CUSTOMER]
	add [rowversion] rowversion;

-- Выборка данных из таблицы
select * -- 0x00000000000065A1
  from [LEVELUP].[CUSTOMER];

-- Обновление данных в таблице
update [LEVELUP].[CUSTOMER]
   set PATRONYMIC = N'PATRONYMIC2'
  from [LEVELUP].[CUSTOMER] as t1 
 where t1.CLIENT_ID = 1;
 */
--=================================

-- Создание таблицы для хранения данных о телефонах
if object_id('[LEVELUP].[PHONES]', 'U') is not null drop table [LEVELUP].[PHONES];
create table [LEVELUP].[PHONES] (
       [PHONE_ID]     int identity(1, 1) primary key,           -- идент. телефона
	   [CLIENT_ID]    int          null,                        -- идент. клиента
	   [PHONE_NUMBER] nvarchar(50) not null,                    -- номер телефона        
	   [STATUS]       nchar(1)     not null,                    -- статус
	   [CREATE_DATE]  datetime2    not null default getdate(),  -- дата создания строки 
	   [MODIFY_DATE]  datetime2    not null                     -- дата последнего изменения строки

);

-- Создание таблицы для хранения емейлов
if object_id('[LEVELUP].[EMAILS]', 'U') is not null drop table [LEVELUP].[EMAILS];
create table [LEVELUP].[EMAILS](
       [EMAIL_ID]     int identity(1, 1) primary key,          -- идент. почты
	   [CLIENT_ID]    int          null,                       -- идент. клиента
	   [EMAIL]        nvarchar(50) not null,                   -- адрес электронной почты      
	   [STATUS]       nchar(1)     not null,                   -- статус
	   [CREATE_DATE]  datetime2    not null default getdate(), -- дата создания строки 
	   [MODIFY_DATE]  datetime2    not null                    -- дата последнего изменения строки     
);

-- Создание таблицы для хранения данных о статусах
if object_id('[LEVELUP].[STATUS]', 'U') is not null drop table [LEVELUP].[STATUS];
create table [LEVELUP].[STATUS](
       [STATUS_ID]   nchar(1) primary key, -- идент. статуса
	   [DESCRIPTION] nvarchar(50) not null -- описание
)

-- Определение внешних ключей
-- Внешний ключ - телефоны --> статусы
alter table [LEVELUP].[PHONES]
	add constraint fk_phone_status foreign key([STATUS]) references [LEVELUP].[STATUS]([STATUS_ID]) -- on delete cascade on update cascade;

-- Внешний ключ - телефоны --> клиенты
alter table [LEVELUP].[PHONES]
	add constraint fk_cust_id foreign key([CLIENT_ID]) references [LEVELUP].[CUSTOMER]([CLIENT_ID]);

-- Внешний ключ - емейлы --> статусы 
alter table [LEVELUP].[EMAILS]
	add constraint fk_emails_status foreign key([STATUS]) references [LEVELUP].[STATUS]([STATUS_ID]);

-- Внешний ключ - емейлы --> клиенты
alter table [LEVELUP].[EMAILS]
	add constraint fk_emails_cust foreign key([CLIENT_ID]) references [LEVELUP].[CUSTOMER]([CLIENT_ID]);

-- Удаление ограничения 
	-- alter table [LEVELUP].[EMAILS] drop constraint fk_emails_status;
--============================================================================================================================
   -- Нормализаци и денормализация базы данных 