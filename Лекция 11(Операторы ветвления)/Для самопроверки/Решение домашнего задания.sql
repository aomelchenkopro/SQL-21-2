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
select top 1
       with ties
       case t1.PersonType when N'SC' then N'Store Contact'
                          when N'IN' then N'Individual (retail) customer'
						  when N'SP' then N'Sales person'
						  when N'EM' then N'Employee (non-sales)'
						  when N'VC' then N'Vendor contact'
						  when N'GC' then N'General contact' end as [PersonTypeStr],
	   count(distinct t1.BusinessEntityID)                       as [PersonQty]
  from [Person].[Person] as t1
 group by case t1.PersonType when N'SC' then N'Store Contact'
                             when N'IN' then N'Individual (retail) customer'
						     when N'SP' then N'Sales person'
						     when N'EM' then N'Employee (non-sales)'
						     when N'VC' then N'Vendor contact'
						     when N'GC' then N'General contact' end
 order by [PersonQty] desc
;

--===================================================================================================================================================================================
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
       case t1.[EmailPromotion] when 0 then N'Contact does not wish to receive e-mail promotions'
                                when 1 then N'Contact does wish to receive e-mail promotions from AdventureWork'
								when 2 then N'Contact does wish to receive e-mail promotions from AdventureWorks and selected partners' end as [EmailPromotionStr],
	   count(distinct t1.BusinessEntityID)                                                                                                  as [PersonQty]
  from [Person].[Person] as t1 
 where t1.PersonType = N'IN'
 group by case t1.[EmailPromotion] when 0 then N'Contact does not wish to receive e-mail promotions'
                                   when 1 then N'Contact does wish to receive e-mail promotions from AdventureWork'
								   when 2 then N'Contact does wish to receive e-mail promotions from AdventureWorks and selected partners' end
order by [PersonQty] desc 
;

--===================================================================================================================================================================================
/*
Задача 3. 1
Напишите запрос, который вернет список личностей, из категорий найденных в задачах 1 (тип личности - PersonType) и 2 (рек. информирование - [EmailPromotion]).
Необходимы следующие данные личностей: идент. личности, наименование стиля имени ([NameStyle]) в строковом представлении (0 = The data in FirstName and LastName are stored 
in western style (first name, last name) order.  1 = Eastern style (last name, first name) order.), полное имя личности (Title + t1.LastName + t1.FirstName + t1.MiddleName) в верх. регистре.
	- Используется таблица [Person].[Person]
	- Задействуйте оператор case
	- Задействуйте строковые функции: concat_ws, upper
	- Рез. набор данных содержит: Идент. личности, наименование стиля имени ([NameStyle]) в строковом представлении (0 = The data in FirstName and LastName are stored 
      in western style (first name, last name) order.  1 = Eastern style (last name, first name) order.),  полное имя личности в верхнем регистре

Задача 3. 2
Создайте временную локальную таблицу - #person, удалите таблицу #person в случае если она существует.  Внесите полученные данные за задачи 3.1 в таблицу #person. 
*/

if object_id('[tempdb].dbo.#person') is not null 
	begin 
		print('The table exists. It will be deleted')
		drop table #person;
	end
else begin
		print('The table does not exists. It will be created')
	 end

-- if object_id('[tempdb].dbo.#person') is not null drop table #person;
create table #person (
       [BusinessEntityID] int,           -- Идент. личности
	   [NameStyleStr]     nvarchar(100), -- Описание стиля имени личности
	   [FullName]         nvarchar(100)  -- Полное имя личности

);
go
insert into #person([BusinessEntityID], [NameStyleStr], [FullName])
select t1.BusinessEntityID,
       case t1.NameStyle when 0 then N'The data in FirstName and LastName are stored in western style (first name, last name) order'
	                     when 1 then N'Eastern style (last name, first name) order' end as [NameStyleStr],
       upper(concat_ws(N' ', t1.Title, t1.LastName, t1.FirstName, t1.MiddleName))       as [FullName]
  from [Person].[Person] as t1
 where t1.PersonType = N'IN'
   and t1.[EmailPromotion] = 0
;
--===================================================================================================================================================================================
select t1.*
  from #person as t1
 order by t1.BusinessEntityID
;