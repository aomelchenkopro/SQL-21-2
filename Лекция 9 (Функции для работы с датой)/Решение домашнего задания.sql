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
       year(t1.OrderDate) as [OrderDateYear]
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
       format( t1.OrderDate, 'yyyyMM', 'en-US') as [period],
       sum(SubTotal) as [total]
  from [Sales].[SalesOrderHeader] as t1
 where year(t1.OrderDate) in (2011, 2012)
group by format( t1.OrderDate, 'yyyyMM', 'en-US')
order by sum(SubTotal) desc;


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

select t1.SalesOrderID,
       concat_ws(N' ', datediff(day, t1.OrderDate, SYSDATETIME()), N'days') as [DayQty],
	   concat_ws(N' ', datediff(hour, t1.OrderDate, SYSDATETIME()), N'hours') as [HourQty],
	   concat_ws(N' ', datediff(minute, t1.OrderDate, SYSDATETIME()), N'minutes') as [MinuteQty],
	   concat_ws(N' ', datediff(second, t1.OrderDate, SYSDATETIME()), N'seconds') as [SecondQty]
  from [Sales].[SalesOrderHeader] as t1
 where t1.CreditCardApprovalCode like '8%'
   and format( t1.OrderDate, 'yyyyMM', 'en-US') = N'201112'
 order by t1.OrderDate desc;
