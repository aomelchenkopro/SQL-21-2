/*
"Напишите запрос, который в разрезе периода (yyyymm) вернет:
сумму налогов и доставки (TaxAmt + Freight) с округлением (по арифм. правилам) до 2 знаков после запятой, 
сумму налогов и доставки (TaxAmt + Freight) с усечением до 2 знаков после запятой,
разницу между суммами с округлением (по арифм. правилам) и усечением,
сумму налогов и доставки (TaxAmt + Freight) с округлением в верх,
разницу сумм между суммами с округлением (по арифм. правилам) и округлением в верх,
сумму налогов и доставки (TaxAmt + Freight) с округлением в низ,
разницу сумм между суммами с округлением (по арифм. правилам) и округлением в низ.
Учитывайте только закупки, которые были проведены начиная с 2012 г.
Не учитывайте закупки со статусами ([Status]) 2 и 3. 
Не учитывайте закупки, которые были доставлены по методу (ShipMethodID) 1.
- Используется таблица [Purchasing].[PurchaseOrderHeader]
- Задействуйте функцию для работы с датой: format
- Задействуйте математические функции: round, ceiling, floor
- Отсортируйте рез. набор данных по периоду (по возрастанию)"						
*/
--====================================================================================================
select format(t1.OrderDate, 'yyyyMM', 'en-US')                                           as [period], -- период,
       sum(t1.TaxAmt + t1.Freight),
       convert( numeric(15, 2), sum(t1.TaxAmt + t1.Freight))                             as [convert],
       round(sum(t1.TaxAmt + t1.Freight),2, 0)                                           as [round0],
	   round(sum(t1.TaxAmt + t1.Freight),2, 1)                                           as [round1],
	   round(sum(t1.TaxAmt + t1.Freight),2, 0) - round(sum(t1.TaxAmt + t1.Freight),2, 1) as [dif1],
	   ceiling(sum(t1.TaxAmt + t1.Freight))                                              as [ceiling],
	   round(sum(t1.TaxAmt + t1.Freight),2, 0) - ceiling(sum(t1.TaxAmt + t1.Freight))    as [dif2],
	   floor(sum(t1.TaxAmt + t1.Freight))                                                as [floor],
	   round(sum(t1.TaxAmt + t1.Freight),2, 0) - floor(sum(t1.TaxAmt + t1.Freight))      as [dif3]
  from [Purchasing].[PurchaseOrderHeader] as t1 
 where 1 = 1
   and t1.[Status] not in (2, 3)
   and year(t1.OrderDate) >= 2012
   and t1.ShipMethodID != 1
 group by format(t1.OrderDate, 'yyyyMM', 'en-US')
 order by [period] asc;
--====================================================================================================
-- CASE
-- 1 = Superior, 2 = Excellent, 3 = Above average, 4 = Average, 5 = Below average
select t1.BusinessEntityID,
       trim(upper(t1.[Name])) as [name],
	   t1.CreditRating,
	   -- позиционная форма оператора case
	   case concat(t1.CreditRating, '') -- !
		when 1 then N'Superior' 
	    when 2 then N'Excellent'
		when 3 then N'Above average'
		when 4 then N'Average' 
		when 5 then N'Below average'
			end as [case],

		-- поисковая форма оператора case
		case 
			when t1.CreditRating = 1 then N'Superior'
			when t1.CreditRating = 2 and t1.ActiveFlag != 0 then N'Excellent'
			when t1.CreditRating = 3 then N'Above average'
			when t1.CreditRating = 4 then N'Average' 
			when t1.CreditRating = 5 then N'Below average' end as [case2]
  from [Purchasing].[Vendor] as t1;

-- 	M = Married, S = Single
-- [BusinessEntityID]
-- [JobTitle]
-- [MaritalStatus]

select t1.BusinessEntityID, 
       trim(upper(t1.[JobTitle])) as [JobTitle],
	   t1.MaritalStatus,
	   case t1.MaritalStatus
		when N'M' then N'Married'
		when N'S' then N'Single' end as [MaritalStatus1],
       case when t1.MaritalStatus = N'M' then N'Married' 
	        when t1.MaritalStatus = N'S' then N'Single' end as [MaritalStatus2]

  from [HumanResources].[Employee] as t1;

select case nullif('i', 'i') when null then 'None' end;

select case when nullif('i', 'i') is null then 'None' end;
--=========================================================================
select case when t1.Color is null then 1 else 0 end as [group],
       isnull(t1.Color, N'None')    as [col],
       count(distinct t1.ProductID) as [unitQty]
  from [Production].[Product] as t1
 group by t1.Color
 order by case when t1.Color is null then 1 else 0 end asc,
          [unitQty] desc;

--=========================================================================
select t1.BusinessEntityID,
       t1.NationalIDNumber,
       t1.JobTitle,
	   t1.Gender
  from [HumanResources].[Employee] as t1
 order by t1.JobTitle,
          t1.Gender desc,
		  t1.BusinessEntityID desc;
--=========================================================================
select t1.Color,
       -- isnull(t1.Color, N'None')  as [isnull],
	   -- nullif(t1.Color, N'Black') as [nullif],
	   IIF(t1.Color = N'Black', N'Product color is black', N'Product color isn''t black' ) as [IIF],
	   case when t1.Color = N'Black' then N'Product color is black' else N'Product color isn''t black' end as [case]
  from [Production].[Product] as t1;
--=========================================================================
SELECT choose ( 1, 'Manager', 'Director', 'Developer', 'Tester' ) AS Result;
select t1.CreditRating,
       choose(t1.CreditRating, N'Superior', N'Excellent', N'Above average', N'Average', N'Below average')
  from [Purchasing].[Vendor] as t1;
--=========================================================================
-- create table #loc_1(a int)
if object_id('[tempdb].[dbo].#loc_1') is not null 
	begin
	    print('The table exists. It will be deleted')
		drop table #loc_1;
	end 
	else begin
	     print 'Object_id is empty'
		 print 'You may should create the table'
		 end
--=========================================================================
-- Виды соединений таблиц 

-- Внутренее соединение

select -- distinct 
       t2.BusinessEntityID,
       trim(upper(concat_ws(N' ',t2.LastName, t2.FirstName, t2.MiddleName))) as [full_name],
	   t1.Gender,
	   t1.MaritalStatus
  from [HumanResources].[Employee] as t1
  -- ANSI-92
  inner join [Person].[Person]     as t2 on t2.BusinessEntityID = t1.BusinessEntityID
                                        and t2.EmailPromotion = 0
 where t1.JobTitle = N'Design Engineer'
order by t1.MaritalStatus, t1.Gender
;
/*
select -- distinct 
       t2.BusinessEntityID,
       trim(upper(concat_ws(N' ',t2.LastName, t2.FirstName, t2.MiddleName))) as [full_name],
	   t1.Gender,
	   t1.MaritalStatus
  from [HumanResources].[Employee] as t1,
  -- ANSI-89
  [Person].[Person]     as t2 
 where t1.JobTitle = N'Design Engineer'
  -- and t2.BusinessEntityID = t1.BusinessEntityID
   --and t2.EmailPromotion = 0
order by t1.MaritalStatus, t1.Gender
;
*/
--=========================================================================
-- [HumanResources].[Employee]
select distinct [EmailPromotion] from [Person].[Person]
/*
0 = Contact does not wish to receive e-mail promotions, 
1 = Contact does wish to receive e-mail promotions from AdventureWorks, 
2 = Contact does wish to receive e-mail promotions from AdventureWorks and selected partners. 
*/

-- The most spredet job title
select top 1 
       with ties
       t1.JobTitle
  from [HumanResources].[Employee] as t1 
 group by t1.JobTitle
 order by count(distinct t1.BusinessEntityID) desc;

-- Persons who want to receive promotional emails
select -- distinct
       t2.BusinessEntityID,
	   trim(upper(concat_ws(N' ',t2.LastName, t2.FirstName, t2.MiddleName))) as [full_name],
	   t1.JobTitle,
	   t1.Gender,
	   case t1.Gender when N'M' then N'Male' 
	                  when N'F' then N'Female' end                           as [gender_full],
	   t1.MaritalStatus,
	   case t1.MaritalStatus when N'S' then N'Single' 
	                         when N'M' then N'Married' end                   as [MaritalStatus_full]
  from [HumanResources].[Employee] as t1
 inner join [Person].[Person]     as t2 on t2.BusinessEntityID = t1.BusinessEntityID
                                        and t2.EmailPromotion != 0
 where t1.JobTitle in (N'Production Technician - WC50', N'Production Technician - WC40', N'Production Technician - WC60');

/*
-- Persons who want to receive promotional emails
select 
       t2.BusinessEntityID,
	   trim(upper(concat_ws(N' ',t2.LastName, t2.FirstName, t2.MiddleName))) as [full_name],
	   t1.JobTitle,
	   t1.Gender,
	   case t1.Gender when N'M' then N'Male' 
	                  when N'F' then N'Female' end                           as [gender_full],
	   t1.MaritalStatus,
	   case t1.MaritalStatus when N'S' then N'Single' 
	                         when N'M' then N'Married' end                   as [MaritalStatus_full]
  from [HumanResources].[Employee] as t1
  inner join [Person].[Person]     as t2 on t2.BusinessEntityID = t1.BusinessEntityID
                                        and t2.EmailPromotion != 0
 where t1.JobTitle in (-- The most spredet job title
						select top 1 
							   with ties
							   t1.JobTitle
						  from [HumanResources].[Employee] as t1 
						 group by t1.JobTitle
						 order by count(distinct t1.BusinessEntityID) desc);
*/







