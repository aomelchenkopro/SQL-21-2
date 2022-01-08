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
  from #employee
										
										
										
										
										
										