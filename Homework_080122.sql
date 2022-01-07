/*
Задача 1										
"Напишите запрос, который вернет список работников на должностях Document Control Assistant, Document Control Manager, Research and Development Manager, 
Research and Development Engineer. 
Учитывайте только работников, которые не желают получать рекламные уведомления и имеющих адрес электронной почты. 
Необходимы следующие данные работников: идент. работника, дата найма, 
ФИО в верхнем регистре без пробелов в начале строки (Title + LastName + FirstName + MiddleName), 
дата рождения, семейное положение в строковом представлении (M = Married, S = Single),  адрес электронной почты.
- Используются таблицы: [HumanResources].[Employee], [Person].[Person], [Person].[EmailAddress] 
- Задействуйте внутренние соединение ANSI-92
- Рез. набор данных содержит: идент. работника, дату найма, ФИО, дату рождения, семейное положение в строковом представлении, адрес электронной почты"										
										
Задача 2										
Внесите полученные данные из задачи 1 во временную таблицу #employee.										
*/										
																							
use [AdventureWorks3];                                                                                                                                    --переключение базы данных

if object_id('[tempdb].dbo.#employee') is not null drop table #employee;																                  --создание временной таблицы #employee
create table #employee (
       [BusinessEntityID] int, 
	   [HireDate] date,
	   [FullName] nvarchar (158),
	   [BirthDate] date,
	   [MaritalStatusStrReflection] nvarchar (10),
	   [EmailAddress] nvarchar (50)
);

insert into #employee ([BusinessEntityID], [HireDate], [FullName], [BirthDate], [MaritalStatusStrReflection], EmailAddress)                               --заполнение временной таблицы #employee ТУТ КОЛОНКИ
select t1.[BusinessEntityID],                                                                                                                             --идент. работника
       t1.[HireDate],                                                                                                                                     --дата найма
	   upper (concat_ws (N' ', ltrim(t2.[Title]), ltrim(t2.[LastName]), ltrim(t2.[FirstName]),  ltrim(t2.[MiddleName]))) as [FullName],                   --ФИО в верхнем регистре без пробелов в начале строки
	   t1.[BirthDate],
       case t1.[MaritalStatus] when N'S' then N'Single'
	                           when N'M' then N'Married' end                                                             as [MaritalStatusStrReflection], --семейное положение в строковом представлении                                                                                                                
	   t3.[EmailAddress]                                                                                                                                  --адрес электронной почты
   from [HumanResources].[Employee]   as t1
   inner join [Person].[Person]       as t2 on t2.[BusinessEntityID]=t1.[BusinessEntityID]                                                                --внутренние соединение ANSI-92
                                           and t2.[EmailPromotion]=0                                                                                      --учитываются только работники, которые не желают получать рекламные уведомления
   inner join [Person].[EmailAddress] as t3 on t3.[BusinessEntityID]=t1.[BusinessEntityID]
                                           and t3.[EmailAddress] is not null                                                                              --учитываются только работники, которые имеют адрес электронной почты
      where t1.JobTitle in (N'Document Control Assistant', N'Document Control Manager', 
	                        N'Research and Development Manager', N'Research and Development Engineer')                                                    --должности Document Control Assistant, Document Control Manager, Research and Development Manager, Research and Development Engineer
;

select *                                                                                                                                                  --выбрать все из временной таблицы #employee        
    from #employee;


/*
Мои вопросы
1. Сортировка по дате найма по возрастанию и затем по ID сотрудника по убыванию - в задаче нет такого условия
2. Условие, что у выбранных сотрудников должна быть почта (t3.[EmailAddress] is not null   ) в решении не проверяется
3. Три таблицы объединяются через поле [BusinessEntityID], одинаковое во всех их: 
   on t2.[BusinessEntityID]=t1.[BusinessEntityID] это понятно. Первую объединяем со второй
   on t3.[BusinessEntityID]=t1.[BusinessEntityID] почему третью надо объединять с первой. а не второй. 
   Ведь on t3.[BusinessEntityID]=t2.[BusinessEntityID] результат будет идентичным. Какие есть правила при объединении более двух таблиц?
*/