-- Представление - View - Сохраненный запрос на стороне сервера
alter view EmployeeOrders 
with schemabinding 
as
with Employee as
(
select t1.JobTitle,
       t1.BusinessEntityID,
	   t1.Gender,
	   t1.MaritalStatus,
	   t1.BirthDate
  from [HumanResources].[Employee] as t1
)

select t2.BusinessEntityID,
	   concat_ws(N' ', t3.LastName, t3.FirstName, t3.MiddleName ) as [full_name],
	   t2.JobTitle,
	   t2.Gender,
	   t2.MaritalStatus,
	   t2.BirthDate,
	   sum(case when format(t4.OrderDate , 'yyyyMM', 'en-US') = '201405' then t4.SubTotal end)                        as [last_month],
	   sum(case when format(t4.OrderDate , 'yyyyMM', 'en-US') in ('201405', '201404') then t4.SubTotal end)           as [last_two_months],
	   sum(case when format(t4.OrderDate , 'yyyyMM', 'en-US') in ('201405', '201404', '201403') then t4.SubTotal end) as [last_three_months]
  from Employee as t2
 inner join [Person].[Person] as t3 on t3.BusinessEntityID = t2.BusinessEntityID
 left outer join [Sales].[SalesOrderHeader] as t4 on t4.SalesPersonID = t2.BusinessEntityID
 where t2.JobTitle in (
						select top 1
							   with ties
							   t1.JobTitle
						  from Employee as t1
						 group by t1.JobTitle
						 order by count(distinct t1.BusinessEntityID) asc
						)
 group by t2.BusinessEntityID,
	      concat_ws(N' ', t3.LastName, t3.FirstName, t3.MiddleName ),
	      t2.JobTitle,
	      t2.Gender,
	      t2.MaritalStatus,
		  t2.BirthDate
--WITH CHECK OPTION
;

grant select on EmployeeOrders to sa with grant option;
grant select, insert, update, delete on EmployeeOrders to sa; --with grant option;

revoke select on EmployeeOrders to sa;


select *
  from EmployeeOrders as t1
 where t1.last_three_months between 100000 and 250000;
--===========================================================================================================================================================================
-- Пользовательские функции
-- Scalar 
-- Inline 
-- Multi-Statement


if object_id ('dbo.GetAge') is not null drop function dbo.GetAge;
GO
-- Пользовательская скалярная функция для расчета количества полных лет
create function dbo.GetAge (@birthdate date, @eventdate date)
returns int
as
begin
	return datediff(year, @birthdate, @eventdate)
	-- Выражение позволяет учитывать только полные года
	- case when 100 * month(@eventdate) + day(@eventdate) < 100 * month(@birthdate) + day(@birthdate) then 1 else 0 end
end
GO

grant select on  dbo.GetAge to sa with grant option;
revoke select on  dbo.GetAge  to sa;

select *, dbo.GetAge(t1.BirthDate, SYSDATETIME()) as [full_age]
  from EmployeeOrders as t1
;


 select 100 * month(SYSDATETIME()),
        day(SYSDATETIME()),
		
		100 * month(SYSDATETIME())+
        day(SYSDATETIME()),
		----------------------------------------------
		'|',
       100 * month('19570920'),
	   day('19570920'),

	   100 * month('19570920')+
	   day('19570920')


--====================================================================================================================
-- Multi-Statement



select *, dbo.GetAge(t1.BirthDate, SYSDATETIME()) as [full_age],
       ca.*
  from EmployeeOrders as t1
  cross apply (
               select f.*
			     from [dbo].[ufnGetContactInformation](t1.BusinessEntityID) f
              ) ca
;


select * 
 from [dbo].[ufnGetContactInformation](121)

-- CROSS APPLY
-- OUTER APPLY
select e.BusinessEntityID,
       c.*
  from [HumanResources].[Employee] e
  OUTER apply (
               select top 3
			          h.SalesOrderID,
			          h.OrderDate,
			          h.SubTotal
			     from [Sales].[SalesOrderHeader] h
				where h.SalesPersonID = e.BusinessEntityID
			    order by h.OrderDate desc
              ) as c
 where e.JobTitle = N'Design Engineer'


select t1.BusinessEntityID,
       ca.*
  from [Person].[Person] as t1
    cross apply (
               select f.*
			     from [dbo].[ufnGetContactInformation](t1.BusinessEntityID) f
              ) ca
;
--====================================================================================================================
-- Inline 
Go
create function dbo.InlineGetLastThreeOrders(@BusinessEntityID int)
returns table
return (
         select top 3
			    h.SalesOrderID,
			    h.OrderDate,
			    h.SubTotal
		   from [Sales].[SalesOrderHeader] h
	      where h.SalesPersonID = @BusinessEntityID
	      order by h.OrderDate desc
       ) 



select p.BusinessEntityID,
       c.*
  from [Person].[Person] p
 outer apply (
             select i.*
               from InlineGetLastThreeOrders(p.BusinessEntityID) i
             ) as c