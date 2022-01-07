/*
Напишите запрос, который вернет кол-во продуктов в разрезе цвета продукта.
Учитывайте только продукты с указанным цветом ([Color] is not null). 
В результате выведите только цвета с количеством продуктов больше 1.
- Используется таблица [Production].[Product]
	Атрибут - [Color] - цвет продукта
	Атрибут - ProductID - идент. продукта
	Детальное описание таблицы - https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/Production_Product_153.html
- Отсортировать рез. набор данных пол количеству продуктов (по убыванию)		
*/

--===============================================================================================================================================================
-- Расчет кол-ва продуктов в разрезе цвета
select t1.Color,                                  -- цвет продукта
       count(distinct t1.ProductID) as [prod_qty] -- идент. продукта/ кол-во продуктов
  from [Production].[Product] as t1
       -- Учитывайте только продукты с указанным цветом
 where t1.Color is not null 
 group by t1.Color
       -- Только цвета с количеством продуктов больше 1.
having count(t1.ProductID) > 1
      -- Отсортировать рез. набор данных пол количеству продуктов (по убыванию)
order by [prod_qty] desc
;

select count(*),           -- кол-во строк
       count(t1.ProductID) -- кол-во значений атрибута, без учета null
  from [Production].[Product] as t1;
--===============================================================================================================================================================
/*
Напишите запрос, который вернет список сотрудников на должности Marketing Specialist
- Используется таблица HumanResources.Employee
- Рез. набор данных содержит BusinessEntityID, BirthDate, Gender, JobTitle
- Отсортировать рез. набор данных по полю BirthDate (по убыванию)

https://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/tables/HumanResources_Employee_130.html
*/

-- Елена
select t1.BusinessEntityID, 
       t1.BirthDate, 
       t1.Gender, 
       t1.JobTitle 
 from [HumanResources].[Employee] as t1 
where t1.JobTitle = N'Marketing Specialist' 
order by t1.BirthDate desc;

-- Дарья
select BusinessEntityID,  
       BirthDate,  
       Gender,  
       JobTitle 
from [HumanResources].[Employee]  
where JobTitle = N'Marketing Specialist'  
 order by BirthDate desc;

-- Александр
select t1.BusinessEntityID,
     t1.BirthDate,
     t1.Gender,
     t1.JobTitle
from [HumanResources].[Employee] as t1
where JobTitle=N'Marketing Specialist'
order by BirthDate desc;

-- Янина 
select t1.BusinessEntityID,
       t1.BirthDate,
       t1.Gender,
       t1.JobTitle
from [HumanResources].[Employee] as t1
where t1.JobTitle = N'Marketing Specialist'
order by t1.BirthDate desc;

-- Анастасия 
select t1.BusinessEntityID,
       t1.BirthDate,
       t1.Gender,
       t1.JobTitle      
  from [HumanResources].[Employee] as t1                
 where t1.JobTitle = N'Marketing Specialist'                                                                        
 order by t1.BirthDate desc;
--==================================================================================================================================
/*
Напишите запрос, который вернет кол-во сотрудников из таблицы [HumanResources].[Employee]
*/
-- Александр
select count(t1.BusinessEntityID) as employee_number
  from [HumanResources].[Employee] as t1;

-- Янина
select count(t1.BusinessEntityID) as [Qty]
  from [HumanResources].[Employee] as t1;

-- Елена
select count(t1.BusinessEntityID) as [EMP_QTY] 
 from [HumanResources].[Employee] as t1;

-- Анастасия 
select count(t1.BusinessEntityID) as [Qty_Total]
  from [HumanResources].[Employee] as t1;

-- Дарья
select count(BusinessEntityID) as [EMP_QTY] -- кол-во сотрудников 
  from [HumanResources].[Employee]
--==================================================================================================================================
-- select * from [Production].[Product];

-- count(*) - кол-во строк
-- count([атрибут]) - кол-во значений в атрибутах строк, без учета null 
-- count(distinct [атрибут]) - кол-во уникальных значений в атрибутах строк, без учета null 

select count(*)              as [ROW_QTY],          -- кол-во строк - INT
       count([ProductID])    as [ProductID],        -- кол-во значений [ProductID], без учета null - INT
       count(color)          as [color],            -- кол-во значений [color], без учета null - INT
	   count(distinct color) as [unique_color_qty ] -- кол-во уникальных значений color, без учета null - INT
  from [Production].[Product];


-- [HumanResources].[Employee]

-- Анастасия
select count (*),
       count (BusinessEntityID),
	   count (distinct JobTitle)
 from [HumanResources].[Employee]
;

select count (BusinessEntityID)
      from [HumanResources].[Employee] 
;

select count (distinct JobTitle)
      from [HumanResources].[Employee] 
;

select count (OrganizationNode)
      from [HumanResources].[Employee]
;

-- Дарья
select count (*) 
  from [HumanResources].[Employee]; 
 
   
  select count ([LoginID]) 
  from [HumanResources].[Employee];
 
  select count (distinct Gender) 
      from [HumanResources].[Employee];

-- Александр
select count (*) as [count (*)],
       count (OrganizationLevel) as [count (OrganisationLevel)],
       count (distinct Gender) as [count (distinct Gender)]
  from [HumanResources].[Employee];

-- Елена
select count(*), 
       count(t1.OrganizationNode), 
       count(distinct t1.JobTitle) as [JobTitle] 
 from [HumanResources].[Employee] as t1;

 select count (*)
from [HumanResources].[Employee];

select count ([BusinessEntityId])
from [HumanResources].[Employee];

select count (distinct [JobTitle])
from [HumanResources].[Employee];

--SUM -  Возвращает сумму всех, либо только уникальных, значений в выражении. Функция SUM может быть использована только для числовых столбцов. Значения NULL пропускаются.
/*
Возвращает сумму всех значений выражения, представленную в наиболее точном типе данных выражения.

ТИПЫ ВОЗВРАЩАЕМЫХ ДАННЫХ
Результат выражения	Возвращаемый тип
tinyint -->>	int
smallint -->>	int
int -->>	    int
bigint -->>	    bigint
Категория decimal (p, s) -->> decimal(38, s)
Категории money и smallmoney -->>	money
Категории float и real -->>	float
*/
select sum(t1.[SubTotal]),
       sum(distinct t1.[SubTotal])
  from [Sales].[SalesOrderHeader] as t1;

-- Сумма покупок в разрезе клиента
select t1.CustomerID,
       sum(t1.SubTotal) as [total]
  from [Sales].[SalesOrderHeader] as t1
  group by t1.CustomerID
  order by [total] desc;
  
 
  [Purchasing].[PurchaseOrderHeader]
   [VendorID] -- идент. производителя товара
   [SubTotal] -- общая сумма закупки 


select t1.VendorID, 
       sum(t1.SubTotal) as [SubTotal] 
 from [Purchasing].[PurchaseOrderHeader] as t1 
 group by t1.VendorID 
 order by sum(t1.SubTotal) desc;


 select t1.VendorID,
        sum (t1.Subtotal) as [SubTotal]
from [Purchasing].[PurchaseOrderHeader] as t1
group by t1.VendorID
order by SubTotal desc;

--=======================================================================================================================================================================
-- AVG - эта функция возвращает среднее арифметическое группы значений. Значения NULL она не учитывает.
/*
tinyint	int
smallint	int
int	int
bigint	bigint
Категория decimal (p, s)	decimal(38, max(s,6))
Категории money и smallmoney	money
Категории float и real	float
*/
select avg(t1.[SubTotal]),
       avg(distinct t1.[SubTotal])
  from [Sales].[SalesOrderHeader] as t1;

--=======================================================================================================================================================================
-- MAX - возвращает максимальное значение выражения.
-- Возвращает то же значение, что и expression.
-- При выполнении функции MAX все значения NULL пропускаются.
-- MAX возвращает NULL, если нет строк для выбора.
-- При использовании со столбцами, содержащими символьные значения, функция MAX находит 
-- наибольшее значение в упорядоченной последовательности.

select max(t1.[SubTotal]),
       max(distinct t1.[SubTotal])
  from [Sales].[SalesOrderHeader] as t1;
--=======================================================================================================================================================================
-- MIN - возвращает минимальное значение выражени
-- Возвращает то же значение, что и expression.
-- Значения NULL функцией MIN не учитываются.
-- Для столбцов символьных данных функция MIN находит значение, находящееся внизу последовательности сортировки.
select min(t1.[SubTotal]),
       min(distinct t1.[SubTotal])
  from [Sales].[SalesOrderHeader] as t1;
--=======================================================================================================================================================================
-- COUNT_BIG
select --count(*),

       count(distinct [JobTitle]) as [unique_job_title_qty], 
	   sql_variant_property(count(distinct [JobTitle]), 'BaseType') [unique_job_title_qty_type],
       
	   count_big(distinct [JobTitle]) as [unique_job_title_qty_cb],
	   sql_variant_property(count_big(distinct [JobTitle]), 'BaseType') as [unique_job_title_qty_cb_type]

  from [HumanResources].[Employee];
--=======================================================================================================================================================================
-- Функция APPROX_COUNT_DISTINCT предназначена для использования в сценариях использования больших данных и оптимизирована для следующих условий:
-- доступ из наборов данных, содержащих миллионы или более строк, И
-- агрегирование данных одного или нескольких столбцов с большим количеством различных значений.
 -- APPROX_COUNT_DISTINCT 
select count(distinct t1.JobTitle),
       approx_count_distinct(t1.JobTitle)
  from [HumanResources].[Employee] as t1;
--======================================================================================================================================================================= 
/*
Предположим мы занимаемся фермерским делом и уже сняли урожай помидоров. К сожалению, за весь год мы сумели вырастить только три помидора.
Первый имеет диаметр 11 сантиметров, второй 12 и последний, наша гордость, целых 16 сантиметров.
*/
-- http://alexanderkobelev.blogspot.com/2013/03/tsql-stdev-stdevp-var-varp.html

if object_id('[tempdb].dbo.#tomatoes') is not null drop table #tomatoes;
create table #tomatoes(
       id       int identity(1, 1),
	   diameter int
);

insert into #tomatoes(diameter)
values(11),
      (12),
	  (16);

select avg(t1.diameter) -- средий диаметр помидар - 13
  from [tempdb].[dbo].#tomatoes as t1;
--------------------------------------------------------------------------------------------------------
-- Расчет популяции - рассчитывается разница между каждым помидором и средним помидором, эта последовательность разниц и есть популяция
select 11-13 -- -2
select 12-13 -- -1
select 16-13 -- 3

-- -2, -1, 3 - популяция
select power(-2.00,2),
       power(-1.00, 2),
	   power(3.00, 2)

select (power(-2.00,2)+power(-1.00, 2)+power(3.00, 2))/3, 
        sqrt((power(-2.00,2)+power(-1.00, 2)+power(3.00, 2))/3)

--То есть среднее изменение диаметра от помидора к помидору около 2.16024674516593 сантиметров
select VAR(diameter), -- Использует НЕ все значения (эффективен при больших объемах данных). Расчитывает данные с прогрешностью
       STDEV(diameter),
	   
	   VARP(diameter), -- Использует ВСЕ значения
	   STDEVP(diameter)
  from #tomatoes

-- 1) Получение среднего арифметического  - 13 
-- 2) Получение разницы между каждым отдельным значением атрибута и средним значением 
-- 3) Возведение каждой отдельной разницы значений во 2 степень 
-- 4) Суммирование значений, которые находятся во второй степени и деление на кол-во значение - получение среднего 
--======================================================================================================================================================================= 
-- CHECKSUM_AGG - Эта функция возвращает контрольную сумму значений в группе
-- Функция CHECKSUM_AGG может обнаруживать изменения в таблице.
SELECT CHECKSUM_AGG(CAST(Quantity AS INT))  
FROM Production.ProductInventory; 
--======================================================================================================================================================================= 
/*
COUNT
SUM
AVG
MIN
MAX
*/
-- General purchase order information. See PurchaseOrderDetail.
select *
  from [Purchasing].[PurchaseOrderHeader]
  
  [ShipMethodID]
                 
				 -- кол-во уникальных заказов 
                 -- общую сумму заказов ([SubTotal])
				 -- средний налог ([TaxAmt])
				 -- максимальную сумму доставки ([Freight])
				 -- минимальную сумму доставки ([Freight])


-- Елена
select t1.ShipMethodID,
       count(t1.PurchaseOrderID )         as [ShipMethod], 
       sum(t1.SubTotal)                   as [SUM], 
       avg(t1.TaxAmt)                     as [AVG], 
       max(t1.Freight)                    as [MAX], 
       min(t1.Freight)                    as [MIN] 
  from [Purchasing].[PurchaseOrderHeader] as t1
 group by t1.ShipMethodID
 order by [SUM] desc

-- Анастасия
select t1.ShipMethodID,
   count(t1.PurchaseOrderID) as [Order],
   sum (t1.SubTotal)as [Sub_total],
   avg (t1.TaxAmt) as [TAX] ,
   max (t1.Freight) as [MAX_Freight],
   min (t1.Freight) as [MIN_Freight]
   from [Purchasing].[PurchaseOrderHeader] as t1
 group by t1.ShipMethodID
 ;

-- Александр
 select t1.[ShipMethodID],
        count (t1.[PurchaseOrderID]) as OrderNumber,
        sum (t1.[SubTotal]) as SubTotalSum,
        avg (t1.[TaxAmt]) as TaxAmtAvg,
        max (t1.[Freight]) as MaxFreight,
        min (t1.[Freight]) as MinFreight    
  from [Purchasing].[PurchaseOrderHeader] as t1
 group by [ShipMethodID];