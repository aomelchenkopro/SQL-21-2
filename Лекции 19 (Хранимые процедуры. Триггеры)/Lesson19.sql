--========================================================1===============================================
-- Хранимые процедуры
ALTER PROCEDURE [HumanResources].[uspUpdateEmployeeHireInfo]
    @BusinessEntityID [int], 
    @HireDate [datetime], 
    @RateChangeDate [datetime], 
    @Rate [money], 
    @PayFrequency [tinyint], 
    @CurrentFlag [dbo].[Flag],
	@JobTitle [nvarchar](50) = N'None'
AS
BEGIN
---------------------------------------------------------------------------------
		begin transaction
        -- Обновление информации в таблице сотрудников
        UPDATE [HumanResources].[Employee] 
        SET [JobTitle] = @JobTitle 
            ,[HireDate] = @HireDate 
            ,[CurrentFlag] = @CurrentFlag 
        WHERE [BusinessEntityID] = @BusinessEntityID;

		-- Добавление новых строк. Информация о выплатах сотрудника
        INSERT INTO [HumanResources].[EmployeePayHistory] 
            ([BusinessEntityID]
            ,[RateChangeDate]
            ,[Rate]
            ,[PayFrequency]) 
        VALUES (@BusinessEntityID, @RateChangeDate, @Rate, @PayFrequency);
		commit transaction;

---------------------------------------------------------------------------------
END;

-- Предоставление привелегии на выполнение хранимой процедуры
grant execute on [HumanResources].[uspUpdateEmployeeHireInfo] to sa;

-- Выполнение хранимой процедуры
execute [HumanResources].[uspUpdateEmployeeHireInfo] 4, '20080205', '20220220', 100.20, 2, 1;


--========================================================2===============================================
GO
CREATE PROCEDURE [HumanResources].[uspUpdateEmployeeLogin]
    @BusinessEntityID [int], 
    @OrganizationNode [hierarchyid],
    @LoginID [nvarchar](256),
    @JobTitle [nvarchar](50),
    @HireDate [datetime],
    @CurrentFlag [dbo].[Flag]
AS
BEGIN
        UPDATE [HumanResources].[Employee] 
        SET [OrganizationNode] = @OrganizationNode 
            ,[LoginID] = @LoginID 
            ,[JobTitle] = @JobTitle 
            ,[HireDate] = @HireDate 
            ,[CurrentFlag] = @CurrentFlag 
        WHERE [BusinessEntityID] = @BusinessEntityID;;
END;

-- Предоставление привелегии на выполнение хранимой процедуры
grant execute on [HumanResources].[uspUpdateEmployeeHireInfo] to sa;

-- Выполнение хранимой процедуры
execute [HumanResources].[uspUpdateEmployeeLogin] 4, 0x5AD6, 'adventure-works\LOGIN', 'Design Engineer', '20220220', '1'

--========================================================3===============================================
-- Триггеры
select * 
  from sys.objects 
 where type_desc = 'SQL_TRIGGER'
order by type_desc


-- 1893581784
select * 
  from sys.objects 
where object_id = 1893581784

select * 
  from sys.schemas
GO
alter TRIGGER [HumanResources].[dEmployee] ON [HumanResources].[Employee] 
INSTEAD OF DELETE AS 
BEGIN
----------------------------------------------------------------------------
    DECLARE @Count int;
	--print @@ROWCOUNT
    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT OFF;

    BEGIN

	select * from deleted


        RAISERROR
            (N'Employees cannot be deleted. They can only be marked as not current.', -- Message
            10, -- Severity.
            1); -- State.

        -- Rollback any active or uncommittable transactions
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END;
----------------------------------------------------------------------------
END;
GO

delete from [HumanResources].[Employee] where BusinessEntityID = 4
select * from [HumanResources].[Employee]


select * from [Production].[TransactionHistory]