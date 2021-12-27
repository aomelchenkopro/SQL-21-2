/*
Задача 1
Напишите запрос, который вернет список уникальных годов из даты проведения заказов (OrderDate).
- Используется таблица [Sales].[SalesOrderHeader].
- Задействуйте функцию year
- Задействуйте оператор distinct
- Результирующи набор данных содержит: год проведения заказа (без дублирующих строк)
- Отсортировать рез. набор данных по году (по возрастанию)
*/

select distinct
       year(t1.OrderDate) as [year]
  from [Sales].[SalesOrderHeader] as t1
 order by year(t1.OrderDate) asc;

/*
Задача 2
Напишите запрос, который вернет период(yyyyMM) с наибольшей общей суммой заказов (SubTotal).
Учитывайте вероятность того, что сразу несколько периодов могут иметь одну и туже сумму заказов.
Учитывайте только заказы за 2011 и 2012 года.
- Используется таблица [Sales].[SalesOrderHeader]
- Задействуйте предикат принадлежности множеству: in
- Задействуйте функции для работы с датой: year
- Задействуйте строковую функцию format
- Задействуйте агрегатную функцию sum
- Результирующий набор данных содержит: период(yyyyMM) общая сумма заказов (SubTotal)
*/

select top 1
       with ties
       format(t1.OrderDate, 'yyyyMM', 'en-US') as [period],
       sum(SubTotal)                           as [total]
  from [Sales].[SalesOrderHeader] as t1
 where year(t1.OrderDate) in (2011, 2012)
 group by format(t1.OrderDate, 'yyyyMM', 'en-US')
 order by [total] desc;
/*
Задача 3
Напишите запрос, который вернет список заказов за декабрь 2012 года.
Необходимо рассчитать кол-во прошедших дней, часов, минут, секунд с момента проведения заказа (OrderDate).
Учитывайте только заказы, у которых код подтверждения (CreditCardApprovalCode) заканчивается на 8.
- Используется таблица [Sales].[SalesOrderHeader]
- Задействуйте предикат соответствия шаблону like
- Задействуйте функцию format (для поиска заказов за декабрь 2012 года)
- Задействуйте функции для работы с датой datediff, sysdatetime
- Задействуйте строковую функцию concat_ws
- Рез. набор данных содержит: идент. заказа, кол-во дней + 'days', кол-во часов + 'hours',
кол-во минут + 'minutes', кол-во секунд + 'seconds'.
*/

-- Расчёт разницы в датах
select t1.[SalesOrderID],                                                                     -- идент. заказа
       concat_ws(' ', datediff(hour, t1.OrderDate, SYSDATETIME()), N'hours')     as [hours],   -- разница в часах
	   concat_ws(' ', datediff(minute, t1.OrderDate, SYSDATETIME()), N'minutes') as [minutes], -- разнциа в минутах
	   concat_ws(' ', datediff(second, t1.OrderDate, SYSDATETIME()), N'seconds') as [seconds]  -- разница в секундах
  from [Sales].[SalesOrderHeader] as t1 
 where format(t1.OrderDate, 'yyyyMM', 'en-US') = N'201212'
   and t1.CreditCardApprovalCode like '%8'
 order by t1.[SalesOrderID] desc;


/*
Дополнительная задача
Определите аналоги функций dateadd, datediff, datename, datepart для СУБД Postgresql и MySQL
*/
--=========================================================================================================================================================================
-- Математические функции T-SQL
/*
ABS  ( numeric_expression ) вычисляет абсолютное значение числа.
ACOS ( float_expression   ) вычисляет арккосинус.
ASIN ( float_expression   ) вычисляет арксинус.
ATAN ( float_expression   ) вычисляет арктангенс.

ATN2 ( float_expression , float_expression ) 
вычисляет арктангенс с учетом квадратов.

CEILING ( numeric_expression )   выполняет округление вверх.
COS     ( float_expression   )   вычисляет косинус угла.
COT     ( float_expression   )   возвращает котангенс угла.
DEGREES ( numeric_expression )   преобразует значение угла из радиан в градусы.
EXP     ( float_expression   )   возвращает экспоненту.
FLOOR   ( numeric_expression )   выполняет округление вниз.
LOG     ( float_expression   )   вычисляет натуральный логарифм.
LOG10   ( float_expression   )   вычисляет десятичный логарифм.
PI      ()                       возвращает значение "пи".
POWER   ( float_expression , y ) возводит число в степень.
RADIANS ( numeric_expression   ) преобразует значение угла из градуса в радианы.
RAND    ( [ seed ] )             возвращает случайное число

ROUND   ( numeric_expression , length [ ,function ] ) 
выполняет округление с заданной точностью.

SIGN   ( numeric_expression ) определяет знак числа.
SIN    ( float_expression   ) вычисляет синус угла.
SQUARE ( float_expression   ) выполняет возведение числа в квадрат.
SQRT   ( float_expression   ) извлекает квадратный корень.
TAN    ( float_expression   ) возвращает тангенс угла.
**/

select abs(-1), -- вычисляет абсолютное значение числа
       -1*-1,
	   1*-1;

select t1.TaxAmt,
       abs(t1.TaxAmt * -1)
  from [Sales].[SalesOrderHeader] as t1;

-- CEILING - выполняет округление вверх
-- FLOOR - выполняет округление вниз.
select format(t1.OrderDate, 'yyyyMM', 'en-US')                                                         as [period],
       sum(t1.SubTotal)                                                                                as [total],
	   count(distinct t1.SalesOrderID)                                                                 as [orderQty],
	   sum(t1.SubTotal) /  count(distinct t1.SalesOrderID)                                             as [avg],
	   ceiling(sum(t1.SubTotal) /  count(distinct t1.SalesOrderID))                                    as [ceiling],
	   floor(sum(t1.SubTotal) /  count(distinct t1.SalesOrderID))                                      as [floor],
	   SQL_VARIANT_PROPERTY( ceiling(sum(t1.SubTotal) /  count(distinct t1.SalesOrderID)), 'BaseType') as [type]
  from [Sales].[SalesOrderHeader] as t1
 group by format(t1.OrderDate, 'yyyyMM', 'en-US')
 order by format(t1.OrderDate, 'yyyyMM', 'en-US') desc;

select SQL_VARIANT_PROPERTY(2, 'BaseType'),
       SQL_VARIANT_PROPERTY(2.00, 'BaseType')



 select t1.[SalesOrderID],
        SQL_VARIANT_PROPERTY(floor(t1.[SalesOrderID] / 2.00) * 2 , 'BaseType')
   from [Sales].[SalesOrderHeader] as t1
 where -- t1.SalesOrderID = floor(t1.[SalesOrderID] / 2.00) * 2;
       t1.[SalesOrderID] % 2 = 0
 
-- ROUND   ( numeric_expression , length [ ,function ] ) выполняет округление с заданной точностью. 
select format(t1.OrderDate, 'yyyyMM', 'en-US')                                                            as [period],
       sum(t1.SubTotal)                                                                                   as [total],
	   count(distinct t1.SalesOrderID)                                                                    as [orderQty],
	   sum(t1.SubTotal) /  count(distinct t1.SalesOrderID)                                                as [avg],
	   round(sum(t1.SubTotal) /  count(distinct t1.SalesOrderID), 2, 1)                                   as [round]
	   -- cast(sum(t1.SubTotal) /  count(distinct t1.SalesOrderID) as numeric(15, 2))                     as [cast]
  from [Sales].[SalesOrderHeader] as t1
 group by format(t1.OrderDate, 'yyyyMM', 'en-US')
 order by format(t1.OrderDate, 'yyyyMM', 'en-US') desc;

 -- SIGN   ( numeric_expression ) определяет знак числа.
 select SIGN(-1243),
        SIGN(34),
		SIGN(0)

-- Арифметические операторы
-- +
select 1 + 4,  
       '1' + '4' + isnull(null, ''),
	   1 + '4' + 0.00 + isnull(null, '0');
-- - 
select abs(1 - 4.00),
       convert(DATETIME, '20211211') - 1;

-- *       
select 5 * 5.00
  
-- /
-- select 2/ 0
select 10.00/ 3.00,
       10 / 3

--==============================================================================================================================================================
select * from [Sales].[SalesOrderHeader]

/*
Напишите запрос, который в разрезе периода (YYYYMM + наименование месяца) вернет разницу сумм [TotalDue] - [Freight] (2 знака после запятой)
Учитывайте только заказы проведенные в 2013 и 2014 годах, у которых в коде подтверждения (CreditCardApprovalCode) последний символ - четная цифра или пусто (NULL)
- Используется таблица [Sales].[SalesOrderHeader]
- Рез. набор данных содержит: период (YYYYMM + наименование месяца), разницу сумм
- Отсортировать рез. набор данных по периоду (по убыванию)
*/

select concat_ws(N' ', format(t1.OrderDate, 'yyyyMM', 'en-US'), upper(datename(month, t1.OrderDate)))  as [period],
	   round(sum([TotalDue] - [Freight]), 2, 0)                                                        as [total]
  from [Sales].[SalesOrderHeader] as t1 
 where year(t1.OrderDate) in (2013, 2014)
   and right(isnull(t1.CreditCardApprovalCode, '0'), 1) % 2 = 0
 group by concat_ws(N' ', format(t1.OrderDate, 'yyyyMM', 'en-US'), upper(datename(month, t1.OrderDate)))
 order by [period] desc;

 /*
select * 
  from [Sales].[SalesOrderHeader] as t1 
 where year(t1.OrderDate) in (2013, 2014)
   and (right(t1.CreditCardApprovalCode, 1) % 2 = 0 or t1.CreditCardApprovalCode is null)
;
*/

-- Елена
select CONCAT_WS (N' ', format(t1.OrderDate, 'yyyyMM', 'en-US'), DATENAME(month, t1.OrderDate)) as [period],
       round(sum(t1.TotalDue) - sum(t1.Freight), 2)
 from [Sales].[SalesOrderHeader] as t1
where year(t1.OrderDate) in (2013, 2014)
  and (right(t1.CreditCardApprovalCode, 1) % 2 = 0 or t1.CreditCardApprovalCode is NULL)
group by CONCAT_WS (N' ', format(t1.OrderDate, 'yyyyMM', 'en-US'), DATENAME(month, t1.OrderDate))
order by CONCAT_WS (N' ', format(t1.OrderDate, 'yyyyMM', 'en-US'), DATENAME(month, t1.OrderDate))

 -- ISNULL
 select t1.CurrencyRateID,
        nullif(t1.CurrencyRateID, 54)
     -- SQL_VARIANT_PROPERTY(isnull(t1.CurrencyRateID, '-999'), 'BaseType')
   from [Sales].[SalesOrderHeader] as t1;


 -- SELECT NULLIF(4,4) AS Same, NULLIF(5,7) AS Different

-- кол-во четных цифр, которые находятся в предпоследнем символе атрибута CreditCardApprovalCode (без дубликатов). 
	-- Задействуйте функцию NULLIF для замены букв (предп. символ) на null

-- кол-во нечетных цифр, которые находятся в предпоследнем символе атрибута CreditCardApprovalCode (без дубликатов)
	-- Задействуйте функцию NULLIF для замены букв (предп. символ) на null

select distinct
       left(right(t1.CreditCardApprovalCode, 2), 1)
  from [Sales].[SalesOrderHeader] as t1
 where left(right(t1.CreditCardApprovalCode, 2), 1) % 2 = 0


 select 
      count(distinct left(right((t1.CreditCardApprovalCode), 2),1))
from [Sales].[SalesOrderHeader] as t1
where NULLIF (left(right((t1.CreditCardApprovalCode), 2),1),'i')% 2=0

 select 
      count(distinct left(right((t1.CreditCardApprovalCode), 2),1))
from [Sales].[SalesOrderHeader] as t1
where NULLIF (left(right((t1.CreditCardApprovalCode), 2),1),'i')% 2 != 0


select count(distinct nullif (left (right (t1.[CreditCardApprovalCode],2),1), 'i')) as [QtyNumber]
  from [Sales].[SalesOrderHeader] as t1
  where nullif (left (right (t1.[CreditCardApprovalCode],2),1), 'i') % 2 = 0