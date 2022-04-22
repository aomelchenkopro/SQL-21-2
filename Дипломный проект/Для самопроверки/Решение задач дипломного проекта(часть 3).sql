/*Задача №1.
Напишите запрос, возвращающий список имён служащих (без дубликатов), которые совершали заказы в период с 01.01.2008 по 31.03.2008 
на продукты компании QSA.
- Используются таблицы SALESREPS, [dbo].[ORDERS].
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-92).
- Задействуйте предикат between.
- Результирующий набор содержит имя служащего.*/
select distinct
     t1.NАМЕ
from [dbo].[SALESREPS] as t1
join [dbo].[ORDERS]    as t2 on t2.REP = t1.EMPL_NUМ
                            and t2.MFR = 'QSA'
                            and t2.ORDER_DATE between '20080101' and '20081231'

/*Задача №2.
Напишите запрос, возвращающий для клиентов с кредитным лимитом выше 35000 общую сумму заказов на продукты компании 'ACI'.
- Используются таблицы [dbo].[CUSTOMERS], [dbo].[ORDERS].
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-92).
- Задействуйте агрегатную функцию sum.
- Результирующий набор данных содержит идентификатор клиента, наименование клиента, сумму заказов.*/

select  t1.CUST_NUМ,
        t1.COMPANY,
    sum(t2.AМOUNT)        as SUMM 
  from  [dbo].[CUSTOMERS] as t1
  join  [dbo].[ORDERS]    as t2 on t2.CUST = t1.CUST_NUМ
                              and t2.MFR  = 'ACI'
  where t1.CREDITLIMIT > 35000
  group by t1.CUST_NUМ,
           t1.COMPANY

/*Задача №3.1
Напишите запрос, возвращающий данные самого старшего служащего из восточного региона.
Учитывайте вероятность того что, один и тот же возраст (AGE) может быть сразу у нескольких служащих.
- Используются таблицы [dbo].[SALESREPS], [dbo].[OFFICES].
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-89).
- Задействуйте скалярный, автономный, вложенный запрос.
- Задействуйте агрегатную функцию MAX.
- Результирующий набор данных содержит идентификатор служащего, должность, имя служащего, цель продаж, текущие продажи.*/
select * from [dbo].[SALESREPS]
select * from [dbo].[OFFICES]


select t1.EMPL_NUМ,
       t1.TITLE,
       t1.NАМЕ,
       t1.quota,
       t1.SALES
from [dbo].[SALESREPS]  as t1
where t1.Age in 
               ( 
                  select Max(AGE) as MAX_AGE
                  from  [dbo].[SALESREPS]  as t_1
				   join [dbo].[OFFICES]    as t_2  on t_2.OFFICE  =  t_1.REPOFFICE
						                          and t_2.region  = 'EASTERN'
				);
 

/*Задача №3.2
Напишите запрос, возвращающий список заказов за 2008 г, которые обработал (совершил продажу) самый старший служащий
 из восточного региона.
Учитывайте вероятность того что, один и тот же возраст (AGE) может быть сразу у нескольких служащих.
- Используются таблицы [dbo].[ORDERS], [dbo].[SALESREPS], [dbo].[OFFICES].
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-92).
- Задействуйте скалярный и табличный автономные, вложенные запросы.
- Результирующий набор данных содержит идентификатор заказа, дату заказа, идентификатор служащего, 
идентификатор производителя товара, идентификатор товара, сумма заказа.*/
select * from [dbo].[SALESREPS]
select * from [dbo].[OFFICES]
select * from [dbo].[ORDERS]

select *
from [dbo].[ORDERS] as t3
where t3.REP in (
                  select top 1 
                         with ties
	                     t1.EMPL_NUМ
                    from [dbo].[SALESREPS] as t1
                    join [dbo].[OFFICES]   as t2 on t2.OFFICE = t1.REPOFFICE
                                                and t2.REGION = 'Eastern'
                order by t1.AGE desc
				)
and year(t3.ORDER_DATE) = 2008;

/*Задача №3.3
Напишите запрос, возвращающий общую сумму заказов по каждому проданному товару за 2008 год, которые обработал (совершил продажу) 
самый старший служащий из восточного региона.
Учитывайте вероятность того что, один и тот же возраст (AGE) может быть сразу у нескольких служащих.
- Используются таблицы [dbo].[PRODUCTS], [dbo].[ORDERS], [dbo].[SALESREPS], [dbo].[OFFICES].
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-92).
- Задействуйте скалярный и табличный автономные, вложенные запросы.
- Задействуйте агрегатную функцию SUM.
- Результирующий набор данных содержит идентификатор служащего, идентификатор производителя товара, 
идентификатор товара, описание товара, общая сумму продаж за 2008 г.*/

select * from [dbo].[SALESREPS]
select * from [dbo].[OFFICES]
select * from [dbo].[ORDERS]
select * from [dbo].[PRODUCTS]


select t_1.REP,
       t_1.MFR,
       t_1.PRODUCT,
       t_2.[DESCRIPTION],
       sum(t_1.AМOUNT) as SUMM
from (select *
  from [dbo].[ORDERS] as t3
 where t3.REP in (
                  select top 1 
                         with ties
	                     t1.EMPL_NUМ
                    from [dbo].[SALESREPS] as t1
                    join [dbo].[OFFICES]   as t2 on t2.OFFICE = t1.REPOFFICE
                                                and t2.REGION = 'Eastern'
                order by t1.AGE desc
				)
and year(t3.ORDER_DATE) = 2008)  as t_1
join [dbo].[PRODUCTS]            as t_2 on t_2.MFR_ID = t_1.MFR
                                and t_2.PRODUCT_ID = t_1.PRODUCT
group by t_1.REP,
         t_1.MFR,
         t_1.PRODUCT,
         t_2.[DESCRIPTION];

/*Задача №4.
Напишите запрос, возвращающий для каждого города наиболее продаваемый (по количеству заказов) товар.
Учитывайте вероятность того что, одно и то же количество заказов могут иметь сразу несколько товаров.
- Используются таблицы PRODUCTS, [dbo].[ORDERS], [dbo].[SALESREPS], [dbo].[OFFICES],
- Задействуйте внутреннее объединение таблицы (синтаксис ANSI SQL-92).
- Задействуйте ранжирующую функцию DENSE_RANK.
- Задействуйте агрегатную функцию COUNT в режиме игнорирующем null.
- Результирующий набор данных содержит регион, идентификатор производителя товара, идентификатор товара, описание товара, 
количество заказов, ранг строки.*/

select * from [dbo].[SALESREPS]
select * from [dbo].[OFFICES]
select * from [dbo].[ORDERS]
select * from [dbo].[PRODUCTS]

select t1.OFFICE,
       t1.CITY,
       t2.EMPL_NUМ,
       t2.REPOFFICE,
       t3. *,
       count(t3.ORDER_NUМ) over (partition by t1.CITY, t3.mfr, t3.product ) as CNT
into #loc_03	   
from [dbo].[OFFICES]   as t1
join [dbo].[SALESREPS] as t2 on t2.REPOFFICE = t1.OFFICE
join [dbo].[ORDERS]    as t3 on t3.REP = t2.EMPL_NUМ;

select *,
      dense_rank()over(partition by(city) order by (cnt) desc) as DR 
into #loc_04
from #loc_03

select distinct 
       l1.OFFICE,
       l1.MFR,
       l1.PRODUCT,
       l2.DESCRIPTION,
       l1.CNT,
       l1.DR
from #loc_04          as l1
join [dbo].[PRODUCTS] as l2 on l2.MFR_ID     = l1.MFR
                           and l2.product_id = l1.PRODUCT
where DR = 1;

/*Задача № 5.
Напишите запрос, возвращающий список товаров, которые не продавались в Chicago.
- Используются таблицы [dbo].[OFFICES], [dbo].[SALESREPS], [dbo].[ORDERS], [dbo].[PRODUCTS].
- Задействуйте внутреннее и внешние обеднения таблицы (синтаксис ANSI SQL-92).
- Результирующий набор данных содержит идентификатор производителя, идентификатор товара,
 описание товара, цену за единицу, количество на складе.*/

      select t3. * 
        into #loc_1
		from [dbo].[OFFICES]   as t1
        join [dbo].[SALESREPS] as t2 on t2.REPOFFICE  = t1.OFFICE
        join [dbo].[ORDERS]    as t3 on t3.REP        = t2.[EMPL_NUМ]
       where t1.OFFICE = 12;
GO
      select t2.MFR_ID,
             t2.PRODUCT_ID,
             t2.DESCRIPTION,
             t2.PRICE,
             t2.QTY_ON_HAND
        from #loc_1           as t1
  right join [dbo].[PRODUCTS] as t2 on t2.MFR_ID     = t1.MFR
                                   and t2.PRODUCT_ID = t1.PRODUCT
       where t1.ORDER_NUМ is null;

/*
Задача № 6.
Создайте хранимую процедуру.
Процедура принимает параметры:
- идентификатор клиента.
- идентификатор служащего.
- идентификатор производителя.
- идентификатор товара.
- количество единиц.

На первом этапе, процедура проверяет наличие указанного количества единиц товара на складе
далее на втором этапе, проводится расчёт суммы заказа. На третьем этапе, если сумма кредитного лимита компании 
больше или равна сумме заказа - уменьшается количество единиц товара на складе, сумма заказа вычитается из кредитного лимита компании и заказ вносится в таблицу заказов.
На четвёртом этапе сумма текущих продаж служащего увеличивается на сумму заказа. На пятом этапе сумма текущих продаж офиса 
данного служащего, увеличивается на сумму заказа. На заключительном этапе процедура выводит сообщение о статусе операции.
*/

-- Расчёт суммы заказа
create procedure addNewOrder 
@mfrId       char(3),      -- переменная для хранения ид. прозводителя товара
@prodId      char(5),      -- переменная для хранения ид. товара
@qty         int,          -- переменная для хранения кол-ва заказанных единиц товара
@cust        int,          -- переменная для хранения ид. клиента
@emp         int,
@orderAmount numeric(15,2) -- сумма заказ
as begin
	set @mfrId  = 'REI';
	set @prodId = '2A44G';
	set @qty    = 4;
	set @cust   = 2124;
	set @emp    = 104;

	declare @storeQty int;
	declare @creditLimit int;

    -- Расчёт суммы заказа
	set @orderAmount = (select t1.PRICE * @qty
	                      from [Training].[dbo].[PRODUCTS] as t1
						 where t1.MFR_ID = @mfrId
						   and t1.PRODUCT_ID = @prodId);

    -- получение кол-ва ед. товара со склада
	select @storeQty = t1.QTY
	  from Training.dbo.ORDERS as t1 
	 where t1.MFR = @mfrId
	   and t1.PRODUCT = @prodId;

	-- получение кред. лимита
	select @creditLimit = t1.QTY
	  from Training.dbo.ORDERS as t1 
	 where t1.MFR = @mfrId
	   and t1.PRODUCT = @prodId;
   
if @storeQty >= @qty and @creditLimit>= @orderAmount
begin

-- Вычитание суммы заказа из кредитного лимита клиента
update [Training].[dbo].[CUSTOMERS]
   set CREDIT_LIMIT = t1.CREDIT_LIMIT - @orderAmount
       output deleted.CREDIT_LIMIT,
              inserted.CREDIT_LIMIT
  from [Training].[dbo].[CUSTOMERS] as t1
 where t1.CUST_NUM = @cust;

-- Вычитание заказаного кол-ва товара со склада 
update [Training].[dbo].[PRODUCTS]
   set QTY_ON_HAND = QTY_ON_HAND - @qty
       output deleted.QTY_ON_HAND,
              inserted.QTY_ON_HAND
  from [Training].[dbo].[PRODUCTS] as t1
 where t1.MFR_ID = @mfrId
   and t1.PRODUCT_ID = @prodId;

-- Увеличение текущих продаж служащего на сумму заказа
update [Training].[dbo].[SALESREPS]
   set SALES = SALES + @orderAmount
       output deleted.SALES,
              inserted.SALES
  from [Training].[dbo].[SALESREPS] as t1 
 where t1.EMPL_NUM =  @emp;

-- Увеличение текущих продаж офиса на сумму заказа
update [Training].[dbo].[OFFICES]
   set SALES = t1.SALES + @orderAmount
       output deleted.SALES,
              inserted.SALES
  from [Training].[dbo].[OFFICES]   as t1
  join [Training].[dbo].[SALESREPS] as t2 on t2.REP_OFFICE = t1.OFFICE
                                         and t2.EMPL_NUM =  @emp;

-- Добавление нового заказа 
insert into [Training].[dbo].[ORDERS] (ORDER_NUM, ORDER_DATE, CUST, REP, MFR, PRODUCT, QTY, AMOUNT)
values (114003, getdate(), @cust, @emp, @mfrId, @prodId, @qty, @orderAmount);

print 'Заказ успешен'
end
else

print 'Заказ не успешен'
end

