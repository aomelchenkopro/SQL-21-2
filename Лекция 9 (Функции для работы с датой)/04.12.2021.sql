/*
Задача 1
Напишите запрос, который вернет наименование должности с наибольшим количеством символов.
Учитывайте вероятность того, что сразу несколько должностей могут иметь одно и то же кол-во символов.
Вывести список уникальных наименований должностей (без дублирующих строк)
- Используется таблица [HumanResources].[Employee]
- Задействуйте строковые функции: lower, len
- Результирующий набор данных содержит: Наименование должности, кол-во символов
- Описание таблицы можно видеть по ссылке
  https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/modules/Human_Resources_9/tables/HumanResources_Employee_130.html
*/
select distinct 
       top 1
       with ties
       lower(t1.JobTitle) as [jobTitleL],
	   len(t1.JobTitle) as [Joblen]
  from [HumanResources].[Employee] as t1 
 order by len(t1.JobTitle) desc;

--========================================================================================================================================================
/*
Задача 2
Напишите запрос, который вернет код продукта (первые лат. Буквы до дефиса атрибута t1.ProductNumber 
Кол-во букв до дефиса может меняться от строки к строке. Необходимо определить позицию дефиса с помощью функции charindex) с наибольшим количеством продуктов.
Учитывайте вероятность того, что сразу несколько кодов продуктов могу иметь одно и тоже кол-во продуктов. Не учитывайте продукты цвета Multi.
- Используется таблица [Production].[Product]
- Задействуйте строковые функции: charindex, substring
- Задействуйте агрегатную функцию count
- Результирующий набор данных содержит: код продукта, кол-во продуктов
- Описание таблицы можно видеть по ссылке
  https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/modules/Products_10/tables/Production_Product_153.html
*/

select top 1 
       with ties
       substring(t1.ProductNumber,1,charindex('-', t1.ProductNumber)-1) as [productQty],
       count(distinct t1.ProductID)  as [qty]
  from [Production].[Product] as t1
 where t1.Color != N'Multi'
 group by substring(t1.ProductNumber,1,charindex('-', t1.ProductNumber)-1)
 order by [qty] desc;
--========================================================================================================================================================
/*
Задача 3
Напишите запрос возвращающий список карт, номера которых начинаются с комбинаций чисел: 1111,
3333, 4444, 5555, 7777. Результирующий набор данных содержит: идент. кредит карты, наименование типа карты (в верхнем регистре),
номер карты (6 цифр начиная с 5 цифры заменено на * ), срок действия карты в формате YYYYMM (задействуйте функцию format https://docs.microsoft.com/ru-ru/dotnet/standard/base-types/custom-numeric-format-strings)
 - Используется таблица [Sales].[CreditCard]
 - Задействуйте строковые функции: left, upper, stuff, concat, format
 - Задействуйте предикат принадлежности множеству - in 
 - Отсортировать рез. набор данных по сроку действия карты (по убыванию)
 - Ссылки на описание таблицы и документацию функций
	https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/modules/Sales_12/tables/Sales_CreditCard_179.html
    https://docs.microsoft.com/ru-ru/sql/t-sql/functions/string-functions-transact-sql?view=sql-server-ver15
	https://docs.microsoft.com/ru-ru/dotnet/standard/base-types/custom-numeric-format-strings
*/

select t1.CreditCardID,
       upper(t1.CardType) as [CardType],
       stuff(t1.CardNumber, 5,6, '******') as [CardNumber],
	   concat(t1.ExpYear, format(ExpMonth, '00')) as [CardExp]
  from [Sales].[CreditCard] as t1
 where left(t1.CardNumber, 4) in (N'1111', N'3333', N'4444', N'5555', N'7777')
 order by t1.ExpYear desc,
          t1.ExpMonth desc;
--========================================================================================================================================================
-- Функции для работы с датой
/*
DATEADD  ( datepart , number , date )       добавляет к дате указанное значение дней, месяцев, часов и т.д.
DATEDIFF ( datepart , startdate , enddate ) возвращает разницу между указанными частями двух дат.
DATENAME ( datepart , date )                выделяет из даты указанную часть и возвращает ее в символьном формате.
DATEPART ( datepart , date )                выделяет из даты указанную часть и возвращает ее в числовом формате.
DAY      ( date )                           возвращает число из указанной даты.
GETDATE  ()                                 возвращает текущее системное время.
ISDATE   ( expression )                     проверяет правильность выражения на соответствие одному из возможных форматов ввода даты.
MONTH    ( date )                           возвращает значение месяца из указанной даты.
YEAR     ( date )                           возвращает значение года из указанной даты.
*/

--YYYYMMDD - ANSI формат - стандартизированный 
select cast('20211204' as date);

set language english; -- Устанавливает языковое окружение сеанса. Язык сеанса определяет форматы datetime и системные сообщения.
-- set language russian;
set dateformat dmy;   -- Задает порядок элементов даты (месяц, день, год) 
select * from sys.syslanguages;

select month(cast('20211204' as date)),
       month(cast('04.12.2021' as date));
--=========================================================================================================================================================
select t1.HireDate,
       day(t1.HireDate) as [HireDate],                -- Эта функция возвращает целое число, представляющее дату (день месяца) указанного значения типа date.
	   month(t1.HireDate) as [HireMonth],             -- Возвращает целое число, представляющее месяц указанной даты date.
	   year(t1.HireDate) as [HireYear],               -- Возвращает целое число, представляющее год указанной даты
	   datepart(year, t1.HireDate) as [DatePartYear], -- Эта функция возвращает целое число, представляющее указанную часть datepart заданного типа date.
	   datename(month, t1.HireDate) as [strMonth],
	   datename(weekday, t1.HireDate) as [dateName],
	   dateadd(day, 2, t1.HireDate),
	   dateadd(day, -2, t1.HireDate),
	   datepart(hour, dateadd(minute, -15, [ModifiedDate])) as [datePartHour],
	   dateadd(minute, 15, [ModifiedDate]),
	   dateadd(minute, -15, [ModifiedDate])
  from [HumanResources].[Employee] as t1 
  -- t1.HireDate = '20090114'
       -- t1.HireDate between '20090114' and '20091231'
	   -- t1.HireDate > '20090114'
	   -- t1.HireDate != '20090114'
	   --t1.HireDate in ('20090114', '20090115', '20090116');
 where year(t1.HireDate) in (2009, 2010, 2011)
   and month(t1.HireDate) % 2 != 0
   and datename(weekday, t1.HireDate) = N'Friday'
;

select getdate();     -- тек. системное время
select sysdatetime(); -- время на сервере

/*
DATENAME - Эта функция возвращает строку символов, представляющую указанную часть datepart заданного типа date.
datepart	Сокращения
year	yy, yyyy
quarter	qq, q
month	mm, m
dayofyear	dy, y
day	dd, d
week	wk, ww
weekday	dw, w
hour	hh
minute	mi, n
second	ss, s
millisecond	ms
microsecond	mcs
nanosecond	ns
TZoffset	tz
ISO_WEEK	ISOWK, ISOWW
*/

--ISDATE Возвращает значение 1, если аргумент expression имеет допустимое значение типа datetime; в противном случае возвращает значение 0.
select isdate('20211201');

-- DATEPART - Эта функция возвращает целое число, представляющее указанную часть datepart заданного типа date.
/*
year	yy, yyyy
quarter	qq, q
month	mm, m
dayofyear	dy, y
day	dd, d
week	wk, ww
weekday	dw
hour	hh
minute	mi, n
second	ss, s
millisecond	ms
microsecond	mcs
nanosecond	ns
tzoffset	tz
iso_week	isowk, isoww
*/
-- DATEADD
/*
Эта функция добавляет число (целое число со знаком) в часть даты ввода и возвращает измененное значение даты и времени. 
Например, эту функцию можно использовать для поиска даты, 7000 минут, начиная с сегодняшнего дня: Number = 7000, DatePart = минуты, Date = Today.
*/
select convert(date, dateadd(day, -30, sysdatetime())),
       convert(date,  sysdatetime())


-- DATEDIFF ( datepart , startdate , enddate ) возвращает разницу между указанными частями двух дат.
select t1.BirthDate,
       datediff(year, t1.BirthDate, SYSDATETIME()) as [age]
  from [HumanResources].[Employee] as t1;

-- Эта функция возвращает последний день месяца, содержащего указанную дату, с необязательным смещением.
select EOMONTH(SYSDATETIME(),4);

select convert(date,
					dateadd(day,
					                                              (day(SYSDATETIME()))*-1 
						   , dateadd(month, 1, SYSDATETIME()) )
			   );

select * 
  from [HumanResources].[Employee] as t1;

-- Александр
select top 1 
       with ties
       upper (t1.JobTitle)         as [JobTitle],
       count (t1.BusinessEntityID) as [Number]
  from [HumanResources].[Employee] as t1
 where year (t1.HireDate) in (2008, 2009)
   and day (t1.HireDate) % 2 = 0
   and datename (weekday, t1.HireDate) = N'Monday'
   and t1.JobTitle like N'%Production%'
 group by t1.JobTitle
 order by [Number] desc;

-- Елена
select top 1
       with ties
       UPPER(t1.JobTitle),
       count ( t1.BusinessEntityID)
 from [HumanResources].[Employee] as t1
where datepart (year, t1.HireDate) in (2008, 2009)
  and datepart (day, t1.HireDate) % 2 = 0
  and datename (WEEKDAY, t1.HireDate) = N'Monday'
  and t1.JobTitle like N'%Production%'
group by t1.JobTitle
order by count(t1.BusinessEntityID) desc;

-- Анастасия
select top 1
       with ties
       upper (t1.JobTitle),
       count (t1.BusinessEntityID) as [QTY] 
  from [HumanResources].[Employee] as t1
 where year (t1.HireDate) in (2008, 2009)
   and day(t1.HireDate) % 2 = 0
   and datename (weekday, t1.HireDate) =N'Monday'
   and t1.JobTitle like N'%Production%'
 group by t1.JobTitle
 order by count (t1.BusinessEntityID) desc;

-- Янина
select top 1
       with ties
upper (t1.JobTitle),
count(t1.BusinessEntityID) as [QTY]
from [HumanResources].[Employee] as t1
where year (t1.Hiredate) in (2008, 2009)
and day (t1.HireDate) % 2=0
and datename (weekday,t1.HireDate) = N'Monday'
and JobTitle like N'%Production%'
group by t1.JobTitle
order by [QTY] desc;

-- Дарья
select top 1
       with ties
       upper(t1.JobTitle)           as [jobTitle], -- Наименование должности (в верхнем регистрей)
       count ( t1.BusinessEntityID) as [quantity]  -- Кол-во сотрудников в разрезе должности
  from [HumanResources].[Employee] as t1
 where year (t1.HireDate) in (2008, 2009)
   and day (t1.HireDate) % 2 = 0
   and datename (weekday, t1.HireDate) = N'Monday'
   and t1.JobTitle like N'%Production%'
 group by t1.JobTitle
 order by count(t1.BusinessEntityID) desc;