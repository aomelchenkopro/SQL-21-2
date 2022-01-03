select t1.BusinessEntityID,
	concat_ws(N' ', t1.LastName, t1.FirstName, t1.LastName)
	from [Person].[Person] as t1
	inner join[HumanResources].[Employee] as t2 on t2.BusinessEntityID = t1.BusinessEntityID
where t2.JobTitle = N'Production Technician - WC10';