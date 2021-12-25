--Молчанов 25.12.21
select t1.BusinessEntityID,
       concat_ws (N' ', t2.FirstName,  t2.MiddleName, t2.LastName)
   from [HumanResources].[Employee] as t1
 inner join [Person].[Person] as t2 on t2.BusinessEntityID=t1.BusinessEntityID
   where t1.JobTitle=N'Production Technician - WC10';