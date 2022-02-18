/*Реализовать пользовательскую скалярную функцию, которая возвращает состояние кредитного рейтинга поставщика в текстовом представлении. 
Функция должна принимать цифровое представление состояния кредитного рейтинга.
1 = Superior, 2 = Excellent, 3 = Above average, 4 = Average, 5 = Below average
(таб. [Purchasing].[Vendor])*/

if object_id('dbo.GetCreditRating') is not null drop function dbo.GetCreditRating;
go
create function dbo.GetCreditRating(@creditrating tinyint)
returns nvarchar(20)
as 
begin                                  -- Нужна ли здесь проверка входного параметра?
 return case @creditrating 
        when 1 then N'Superior'
		when 2 then N'Excellent'
		when 3 then N'Above average'
		when 4 then N'Average'
		when 5 then N'Below average'
		end
end
go

grant select on GetCreditRating to sa;

select *, dbo.GetCreditRating(t1.CreditRating) as [creditrating]
from [Purchasing].[Vendor] as t1

-------------------------------------------------------------------------------------------------------------------------------------
--Написала еще одну ф-цию, чтобы посмотреть как это работает. Только не пойму почему это не получилось реализовать как Inline ф-цию.
-- Получилось как Multi-Statement ф-ция
go
if object_id('dbo.GetpTheMostSoldProductByEmployee') is not null drop function dbo.GetpTheMostSoldProductByEmployee;
go
-- функция принимает на вход идентификатор сотрудника и возращает продукт, который этот сотрудник продавал больше всего.
-- проедусмотрено, что продуктов с одинаковым количеством продаж может быть больше одного
create function dbo.GetpTheMostSoldProductByEmployee(@BusinessEntityID int)
returns @InfoMostSoldByEmployee table
(
	BusinessEntityID          int,              -- идентификатор сотрудника
	[Employee_Full_Name]      nvarchar(50),     -- полное имя сотрудника
	ProductID                 int,              -- идентификатор продукта
	[Product_Name]            nvarchar(50)      -- низвание продукта
)
as
begin
	if @BusinessEntityID is not null
		begin
			declare @ProductsThatWasSoldByEmployee table(  -- переменная в котрую будем записывать идентификаторы продуктов 
			ProductID int,                                 -- и количество продаж этого продукта
			CountOfProduct int
			);

			insert into @ProductsThatWasSoldByEmployee     -- вносим данные в переменную
			select t2.ProductID,
				   count(t2.ProductID) over (partition by t2.ProductID) as [CountOfProduct]	   
			 from [Sales].[SalesOrderHeader] as t1 
			inner join [Sales].[SalesOrderDetail] as t2 on t2.[SalesOrderID] = t1.[SalesOrderID]
			where t1.SalesPersonID = @BusinessEntityID

			declare @maxAmountOfSoldProducts as int = (select max(t1.CountOfProduct)    -- записываем в переменную максимальное число продаж продукта
														 from @ProductsThatWasSoldByEmployee as t1
													   )
			;

			insert into @InfoMostSoldByEmployee           -- вносим данные в результирующую таблицу, по продуктам, к-е были проданы максимальное кол-во раз
			select distinct
				   t2.BusinessEntityID,
				   CONCAT_WS(N' ', t2.FirstName, t2.MiddleName, t2.LastName ) as [Employee_Full_Name],
				   t1.ProductID,
				   t3.[Name] as [Product_Name]
			from @ProductsThatWasSoldByEmployee as t1
			left outer join [Person].[Person] as t2 on t2.BusinessEntityID = @BusinessEntityID
			left outer join [Production].[Product] as t3 on t3.ProductID = t1.ProductID
			where t1.CountOfProduct   = @maxAmountOfSoldProducts;
		end
	return;
end;
go

select *
from GetpTheMostSoldProductByEmployee(274)

------------------------------------------------------------------------------------------------
/*
select t1.BusinessEntityID,
		t3.ProductID,
		count(t3.ProductID) over (partition by t1.BusinessEntityID, t3.ProductID) as [CountOfProduct]
 from [HumanResources].[Employee] as t1
inner join [Sales].[SalesOrderHeader] as t2 on t1.BusinessEntityID = t2.SalesPersonID
inner join [Sales].[SalesOrderDetail] as t3 on t3.[SalesOrderID] = t2.[SalesOrderID]
where t1.BusinessEntityID = 274
order by [CountOfProduct] desc
*/

		