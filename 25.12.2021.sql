/*
Задача 1
Напишите запрос, который вернёт наибольшую категорию (тип личности - PersonType) личностей (по кол-ву уник. личностей). Категорию личностей отразить в строковом представлении 
(SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact).
Учитывайте вероятность того, что сразу несколько категорий имеют одно и тоже кол-во уник. личностей.
	- Используется таблица [Person].[Person]
	- Задействуйте оператор case
	- Задействуйте оператор with ties
	- Результирующий набор данных содержит: тип личности в строковом представлении
	  (SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact),
	  кол-во личностей																
*/
use [AdventureWorks3];


select top 1
       with ties
       case t1.[PersonType] when N'SC' then N'Store Contact'
                            when N'IN' then N'Individual (retail) customer'
							when N'EM' then N'Employee (non-sales)'
							when N'VC' then N'Vendor contact'
							when N'GC' then N'General contact' 
							when N'SP' then N'Sales person'
							end                                    as [person_type_str_reflection], -- категория личности в строковом представлении
	   count(distinct t1.[BusinessEntityID])                       as [unique_qty]                  -- кол-во уникальных личностей

  from [Person].[Person] as t1 
group by case t1.[PersonType] when N'SC' then N'Store Contact'
                            when N'IN' then N'Individual (retail) customer'
							when N'EM' then N'Employee (non-sales)'
							when N'VC' then N'Vendor contact'
							when N'GC' then N'General contact' 
							when N'SP' then N'Sales person'
							end
order by count(distinct t1.[BusinessEntityID]) desc
;

/*
select distinct 
        t1.[PersonType]
  from [Person].[Person] as t1
;
*/

--=========================================================================================================================================================================
/*
Задача 2
Напишите запрос, который вернет наибольшую категорию (рек. информирование - [EmailPromotion]) личностей (по кол-ву уник. личностей). Категорию личностей отразить в строковом представлении
(0 = Contact does not wish to receive e-mail promotions, 1 = Contact does wish to receive e-mail promotions from AdventureWorks, 2 = Contact does wish to receive e-mail promotions from AdventureWorks and selected partners)
Учитывайте только личностей из категорий (тип личности - PersonType), которые найдены в задаче 1. Учитывайте вероятность того, что сразу несколько категорий имеют одно и тоже кол-во уник. личностей.
	- Используется таблица [Person].[Person]
	- Задействуйте оператор case
	- Задействуйте оператор with ties
	- Результирующий набор данных содержит: тип личности в строковом представлении
	  (0 = Contact does not wish to receive e-mail promotions, 1 = Contact does wish to receive e-mail promotions from AdventureWorks, 2 = Contact does wish to receive e-mail promotions from AdventureWorks and selected partners),
	  кол-во личностей																			
*/


select top 1 
       with ties
       case t1.EmailPromotion when 0 then N'Contact does not wish to receive e-mail promotions'
                              when 1 then N'Contact does wish to receive e-mail promotions from AdventureWorks'
							  when 2 then N'Contact does wish to receive e-mail promotions from AdventureWorks and selected partners)' end as [email_promotion_str_reflection],
	   count(distinct t1.BusinessEntityID)                                                                                                 as [unique_qty]
  from [Person].[Person] as t1
 where t1.PersonType = N'IN'
 group by case t1.EmailPromotion when 0 then N'Contact does not wish to receive e-mail promotions'
                                 when 1 then N'Contact does wish to receive e-mail promotions from AdventureWorks'
							     when 2 then N'Contact does wish to receive e-mail promotions from AdventureWorks and selected partners)' end
 order by [unique_qty] desc
;
--=========================================================================================================================================================================
/*
Напишите запрос, который вернет список личностей, из категорий найденных в задачах 1 (тип личности - PersonType) и 2 (рек. информирование - [EmailPromotion]).
Необходимы следующие данные личностей: идент. личности, наименование стиля имени ([NameStyle]) в строковом представлении (0 = The data in FirstName and LastName are stored 
in western style (first name, last name) order.  1 = Eastern style (last name, first name) order.), полное имя личности (Title + t1.LastName + t1.FirstName + t1.MiddleName) в верх. регистре.
	- Используется таблица [Person].[Person]
	- Задействуйте оператор case
	- Задействуйте строковые функции: concat_ws, upper
	- Рез. набор данных содержит: Идент. личности, наименование стиля имени ([NameStyle]) в строковом представлении (0 = The data in FirstName and LastName are stored 
      in western style (first name, last name) order.  1 = Eastern style (last name, first name) order.),  полное имя личности в верхнем регистре
*/


if object_id('[tempdb].dbo.#person') is not null drop table #person;
create table #person (
       [business_entityID] int, 
	   [name_style_str_reflection] nvarchar(150),
	   [full_name]                 nvarchar(150)
);


insert into #person([business_entityID], [name_style_str_reflection], [full_name])
select t1.[BusinessEntityID],
       case t1.NameStyle when 0 then N'The data in FirstName and LastName are stored in western style (first name, last name) order'
                         when 1 then N'Eastern style (last name, first name) order.)' end as [name_style_str_reflection],
	   upper(concat_ws(N' ', trim(t1.title), trim(t1.LastName), trim(t1.FirstName), trim(t1.MiddleName))) as [full_name]
  from [Person].[Person] as t1
 where t1.PersonType = N'IN'
   and t1.EmailPromotion = 0
;

select * from #person;
																		
/*
Создайте временную локальную таблицу - #person, удалите таблицу #person в случае если она существует.  Внесите полученные данные за задачи 3.1 в таблицу #person. "																		
*/																		
																		
																		
																		
																		
																		
/*
Дополнительная задача																		
1. 'Продемострировать работу функции case (в различных режимах) в субд:MySql, PostgreSQL
2. Зарегистрировать аккаунт https://github.com/"																		
*/										
--=========================================================================================================================================================================
select t2.BusinessEntityID,
       t2.LastName,
	   t2.FirstName,
	   t2.MiddleName
  from [HumanResources].[Employee] as t1
 inner join [Person].[Person]      as t2 on t2.BusinessEntityID = t1.BusinessEntityID
 where t1.JobTitle = N'Design Engineer'
;															
																		
																		
																		
																		
																														
																		
																		
																		
																		
																		
																		
																		
																		
																		
																		
																		
																		
																		
																		
																		