
if OBJECT_ID ('[tempbd].dbo.#employee') is not null drop table #employee ;

create table #employee (
[business_entityID] int,
[hire_date] date,
[Birth_date] date,
[full_name] nvarchar (150),
[marital_status] nvarchar(7),
[email_address] nvarchar(50)
);

insert into #employee ([business_entityID],[hire_date],[Birth_date],[full_name],[marital_status],[email_address])
select t1.BusinessEntityID,
       t1.HireDate,
	   t1.BirthDate,
	   upper(concat_ws(N' ', ltrim(t2.Title),ltrim(t2.FirstName),ltrim(t2.LastName),ltrim(t2.MiddleName))) as [full_name],
	   case t1.MaritalStatus when N'M' then N'Married'
	                         when N'S' then N'Single' end as [MaritalStatus_str],
	   t3.EmailAddress
from [HumanResources].[Employee] as t1
inner join [Person].[Person] as t2 on t2.BusinessEntityID = t1.BusinessEntityID
and t2.EmailPromotion = 0
inner join[Person].[EmailAddress] as t3 on t3.BusinessEntityID = t1.BusinessEntityID
where t1.JobTitle in (N'Document Control Assistant', N'Document Control Manager', N'Research and Development Manager',
                      N'Research and Development Manager')
order by t1.BusinessEntityID desc
			
;

select * from #employee ;