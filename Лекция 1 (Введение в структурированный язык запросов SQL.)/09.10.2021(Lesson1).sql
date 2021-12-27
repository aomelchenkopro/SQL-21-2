  -- cntrl + shift l
  -- CNTRL + SHIFT U
--================================================================
/*
Заказчик
Автор скрита 
Дата 
*/
--use [AdventureWorks2012];

-- create schema STAGE;
-- Создание таблицы для хранения данных сотрудников

drop table [STAGE].[MOCK_DATA_EMPLOYEES];

create table /*[AdventureWorks2012].*/[STAGE].[MOCK_DATA_EMPLOYEES](
       [ID]               int           -- идент. сотрудника
	--,[NAME]             char(50)      -- ASCI
	--,[NAME]             nchar(50)     -- UNICODE
	--,[NAME]             varchar(50)   -- ASCI
	  ,[NAME]             nvarchar(50)  -- UNICODE
	  ,[LAST_NAME]        nvarchar(50)  -- фамилия сотрудника
	  ,[EMAIL]            nvarchar(50)  -- адрес электронной почты
	  ,[GENDER]           nvarchar(20)  -- пол 
	  ,[IP_ADDRESS]       nvarchar(50)  -- ip адрес
	  ,[CREDIT_CARD_TYPE] nvarchar(50) 
	  ,[Currency_code]    nchar(50)     -- код валюты
	  ,[SALARY]           decimal(15,2) -- money    
	  ,[HIRE_DATE]        date          -- дата найма сотрудника
);  

/*
select * from sys.schemas;
select * from sys.tables;
select * from sys.columns;
*/

insert into [STAGE].[MOCK_DATA_EMPLOYEES]
select t1.*
  from [dbo].[MOCK_DATA_EMPLOYEE] as t1;


select * from [STAGE].[MOCK_DATA_EMPLOYEES];