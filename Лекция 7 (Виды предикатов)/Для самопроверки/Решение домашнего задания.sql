/*
Задача 1
Напишите запрос, который вернет первые 100 наиболее молодых сотрудников мужского пола.
- Используется таблица [HumanResources].[Employee]
- Результирующий набор данных содержит: Идент. сотр, Уникальный государственный идентификационный номер, дату рождения
  Описание таблицы можно видеть по ссылке
https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/HumanResources_Employee_130.html
*/
select top 100
       t1.BusinessEntityID,
       t1.NationalIDNumber,
       t1.BirthDate
  from [HumanResources].[Employee] as t1 
 where t1.Gender = N'M'
 order by t1.BirthDate desc;

/*
Задача 2
Напишите запрос, который вернет список уникальных наименований должностей.
Исключите сотрудников, которые состоят в браке.
- Используется таблица [HumanResources].[Employee]
- Результирующий набор данных содержит: Наименование должности
- Задействуйте оператор DISTINCT
- Отсортируйте результат по наименованию должности (по возрастанию)
  Описание таблицы можно видеть по ссылке
  https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/HumanResources_Employee_130.html
*/
select distinct 
       t1.JobTitle
  from [HumanResources].[Employee] as t1 
 where t1.MaritalStatus != N'M'
 order by t1.JobTitle asc;

/*
Задача 3
Напишите запрос, который в разрезе должности и пола вернет кол-во часов отпуска и кол-во часов отпуска по болезни
и разницу между ними. Исключите сотрудников с окладом, без участия в коллективном договоре (SalariedFlag != 0). 
Исключите группы строк, у которых кол-во часов отпуска больше или равна кол-ву часов отпуска по болезни (общая сумма в разрезе должности и пола).
- Используется таблица [HumanResources].[Employee]
- Результирующий набор данных содержит: Наименование должности, пол, кол-во часов отпуска, кол-во часов отпуска по болезни, разницу.
- Задействуйте агрегатную функцию SUM
- Отсортируйте результат по разнице (по убыванию)
  Описание таблицы можно видеть по ссылке
  https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/HumanResources_Employee_130.html
*/
select t1.JobTitle,
       t1.Gender,
	   sum(t1.VacationHours)                          as [VHours],
	   sum(t1.SickLeaveHours)                         as [SHors],
	   sum(t1.VacationHours) - sum(t1.SickLeaveHours) as [VSDiffQtyHours]
  from [HumanResources].[Employee] as t1
 where t1.SalariedFlag != 0
 group by t1.JobTitle,
          t1.Gender
having sum(t1.VacationHours) < sum(t1.SickLeaveHours)
order by [VSDiffQtyHours] desc;


/*
Задача 4
Напишите запрос, который в разрезе идент. территории ([TerritoryID]) вернет кол-во уникальных заказов. Учитывайте только заказы за октябрь 2011 (year(t1.OrderDate) = 2011  and month(t1.OrderDate) = 10) . 
Исключите заказы размещенные клиентом через сеть (OnlineOrderFlag != 1). Уникальный идентификационный номер заказа на продажу(SalesOrderNumber) должен начинаться на %SO44.
- Используется таблица [Sales].[SalesOrderHeader].
  https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/Sales_SalesOrderHeader_185.html
- Результирующий набора данных содержит: идент. территории, кол-во уникальных заказов 
- Отсортируйте результат по кол-ву заказов (по убыванию)
*/
select t1.[TerritoryID],
       count(distinct t1.[SalesOrderID]) as [orderQty]
  from [Sales].[SalesOrderHeader] as t1
 where year(t1.OrderDate) = 2011 
   and month(t1.OrderDate) = 10
   and t1.OnlineOrderFlag != 1
   and t1.SalesOrderNumber like 'SO44%'
 group by t1.[TerritoryID]
 order by [orderQty] desc;
