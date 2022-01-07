/*
Задача 1
Напишите запрос, который вернет список работников на должностях Document Control Assistant, Document Control Manager,
Research and Development Manager, Research and Development Engineer. Учитывайте только работников, которые не желают получать рекламные уведомления и 
имеющих адрес электронной почты. Необходимы следующие данные работников: идент. работника, дата найма, ФИО в верхнем регистре без пробелов в начале строки
(Title + LastName + FirstName + MiddleName), дата рождения, семейное положение в строковом представлении (M = Married, S = Single),  адрес электронной почты.
- Используются таблицы: [HumanResources].[Employee], [Person].[Person], [Person].[EmailAddress] 
- Задействуйте внутренние соединение ANSI-92
- Рез. набор данных содержит: идент. работника, дату найма, ФИО, дату рождения, семейное положение в строковом представлении, адрес электронной почты
*/
--===========================================================================================================================================
if object_id('tempdb.dbo.#employee') is not null drop table #employee;
create table #employee (
       [BusinessEntityID]           int,
       [HireDate]                   date,
	   [FullName]                   nvarchar(150),
       [BirthDate]                  date,
	   [MaritalStatusStrReflection] nvarchar(7),
	   EmailAddress                 nvarchar(50)
);
--===========================================================================================================================================
insert into #employee ([BusinessEntityID], [HireDate], [FullName], [BirthDate], [MaritalStatusStrReflection], EmailAddress)
select t1.BusinessEntityID,
       t1.HireDate,
	   upper(concat_ws(N' ', ltrim(t2.Title), ltrim(t2.LastName), ltrim(t2.FirstName), ltrim(t2.MiddleName))) as [FullName],
	   t1.BirthDate,
	   case t1.MaritalStatus when N'M' then N'Married'
	                         when N'S' then N'Single' end                                                     as [MaritalStatusStrReflection],
	   t3.EmailAddress
  from [HumanResources].[Employee]  as t1
 inner join [Person].[Person]       as t2 on t2.BusinessEntityID = t1.BusinessEntityID
                                         and t2.EmailPromotion = 0
 inner join [Person].[EmailAddress] as t3 on t3.BusinessEntityID = t1.BusinessEntityID
 where t1.JobTitle in (N'Document Control Assistant', N'Document Control Manager',
                       N'Research and Development Manager', N'Research and Development Engineer')
order by t1.HireDate asc, 
         t1.BusinessEntityID desc
;
--===========================================================================================================================================
select * 
  from #employee;


