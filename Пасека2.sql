																																				
-- Пасека Дарья 																																																																					
select t2.BusinessEntityID,
       concat_ws(N' ', ltrim(t2.LastName), ltrim(t2.FirstName), ltrim(t2.MiddleName)) as [full_name]
  from [HumanResources].[Employee] as t1
 inner join [Person].[Person]      as t2	on t2.BusinessEntityID = t1.BusinessEntityID														
where t1.JobTitle = N'Production Supervisor - WC10'	