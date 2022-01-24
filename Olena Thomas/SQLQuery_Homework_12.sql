/*"Напишите запрос, который вернет список работников на должностях Document Control Assistant, Document Control Manager, 
Research and Development Manager, Research and Development Engineer. 
Учитывайте только работников, которые не желают получать рекламные уведомления и  имеющих адрес электронной почты. 
Необходимы следующие данные работников: идент. работника, дата найма, 
ФИО в верхнем регистре без пробелов в начале строки (Title + LastName + FirstName + MiddleName), дата рождения, 
семейное положение в строковом представлении (M = Married, S = Single),  адрес электронной почты.
- Используются таблицы: [HumanResources].[Employee], [Person].[Person], [Person].[EmailAddress] 
- Задействуйте внутренние соединение ANSI-92
- Рез. набор данных содержит: идент. работника, дату найма, ФИО, дату рождения, семейное положение в строковом представлении, адрес электронной почты"								
*/

select t1.BusinessEntityID                                                                                    as [BusinessEntityID],
       t1.HireDate                                                                                            as [HireDate],
	   upper(concat_ws(N' ', ltrim(t2.Title), ltrim(t2.LastName), ltrim(t2.FirstName), ltrim(t2.MiddleName))) as [FullName],
	   t1.BirthDate                                                                                           as [BirthDate],
	   case t1.MaritalStatus
	        when N'M' then N'Married'
			when N'S' then N'Single' end                                                                      as [MaritalStatusStrReflection],
	   t3.EmailAddress                                                                                        as [EmailAddress]
 from  [HumanResources].[Employee]        as t1
	   inner join [Person].[Person]       as t2 on t2.BusinessEntityID = t1.BusinessEntityID
	   inner join [Person].[EmailAddress] as t3 on t3.BusinessEntityID = t1.BusinessEntityID
where  t1.JobTitle in (N'Document Control Assistant', N'Document Control Manager', N'Research and Development Manager', N'Research and Development Engineer')
       and t3.EmailAddress is not null
       and t2.EmailPromotion = 0
;
-- Внесите полученные данные из задачи 1 во временную таблицу #employee.					

if object_id('[tempdb].dbo.#employee') is not null drop table #employee;

create table #employee(
       [BusinessEntityID]           int,               -- идент. работника
       [HireDate]                   date,              -- дата найма
       [FullName]                   nvarchar(50),      -- ФИО
       [BirthDate]                  date,              -- дата рождения
       [MaritalStatusStrReflection] nvarchar(7),       -- семейное положение в строковом представлении
       [EmailAddress]               nvarchar(50),      -- адрес электронной почты
);

insert into #employee
select t1.BusinessEntityID                                                                                    as [BusinessEntityID],
       t1.HireDate                                                                                            as [HireDate],
	   upper(concat_ws(N' ', ltrim(t2.Title), ltrim(t2.LastName), ltrim(t2.FirstName), ltrim(t2.MiddleName))) as [FullName],
	   t1.BirthDate                                                                                           as [BirthDate],
	   case t1.MaritalStatus
	        when N'M' then N'Married'
			when N'S' then N'Single' end                                                                      as [MaritalStatusStrReflection],
	   t3.EmailAddress                                                                                        as [EmailAddress]
 from  [HumanResources].[Employee]        as t1
	   inner join [Person].[Person]       as t2 on t2.BusinessEntityID = t1.BusinessEntityID
	   inner join [Person].[EmailAddress] as t3 on t3.BusinessEntityID = t1.BusinessEntityID
where  t1.JobTitle in (N'Document Control Assistant', N'Document Control Manager', N'Research and Development Manager', N'Research and Development Engineer')
       and t3.EmailAddress is not null
       and t2.EmailPromotion = 0
;

select *
	from #employee;



