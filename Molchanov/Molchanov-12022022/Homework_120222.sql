/*
"Напишите запрос для разворачивания данных. На пересечении строк и столбцов рассчитать кол-во нанятых работников.
Наименования должностей (JobTitle) отразить вертикально, а даты найма (HireDate) горизонтально.
- Используется таблицы: [HumanResources].[Employee]
- Задействуйте встроенный оператор pivot
- Отсортировать рез. набор данных по наименованию должности по убыванию"									
*/									
									
use [AdventureWorks3];                                                 --переключение базы данных

select distinct t1.[HireDate]                                          --выбор необходимого списка дат, упорядоченного, без повторов
   from [HumanResources].[Employee] as t1
  where t1.[HireDate] between '20080101' and '20081231'
  order by t1.[HireDate]
;


select *
   from (
         select t1.[JobTitle],
                t1.[HireDate],
	            t1.[BusinessEntityID]
            from [HumanResources].[Employee] as t1
           where t1.[HireDate] between '20080101' and '20081231'
         ) as [SourcePivotTable]
		 pivot
		 (
		 count ([BusinessEntityID]) for [HireDate] in ([2008-01-06], [2008-01-07], [2008-01-24], [2008-01-31],
         [2008-02-02], [2008-02-08], [2008-02-20], [2008-02-27], [2008-03-10], [2008-03-17], [2008-03-28],
         [2008-12-01], [2008-12-02], [2008-12-03], [2008-12-04], [2008-12-05], [2008-12-06], [2008-12-07],
         [2008-12-08], [2008-12-09], [2008-12-11], [2008-12-12], [2008-12-13], [2008-12-14], [2008-12-15],
         [2008-12-16], [2008-12-17], [2008-12-18], [2008-12-19], [2008-12-21], [2008-12-22], [2008-12-23],
         [2008-12-24], [2008-12-25], [2008-12-26], [2008-12-27], [2008-12-28], [2008-12-29], [2008-12-31])
		 ) as [PivotResultTable]
order by [PivotResultTable].[JobTitle] asc 
;


---------------------------------------------------------------------------------------------------------------------------


-- Курсор
-- Переменная для хранения промежуточных данных т.к. дата проведения заказ
declare @curDate as date;
declare @dynamicSQL as nvarchar(max);
    set @dynamicSQL = N'select *
						  from (
									select t1.[JobTitle],
										   t1.[HireDate],
										   t1.[BusinessEntityID]
									  from [HumanResources].[Employee] as t1
									  where t1.[HireDate] between ''20080101'' and ''20081231''
							   ) as [SourcePivotTable]
							   pivot 
							   (
								count([BusinessEntityID]) for [HireDate] in (';

-- Объявление курсора
declare [cur] cursor for	
select distinct  t1.HireDate as [HireDate]
       from [HumanResources].[Employee] as t1
 where t1.[HireDate] between '20080101' and '20081231'
 order by [HireDate] asc
;

-- Открытие курсора
open [cur];

-- Прокручивание курсора на первую строку
fetch next from [cur] into @curDate;
set @dynamicSQL = CONCAT(@dynamicSQL, N'[', @curDate, N'] ')

-- @@FETCH_STATUS возвращает состояние последней инструкции FETCH
while @@FETCH_STATUS = 0
	begin

		fetch next from [cur] into @curDate;

		if @@FETCH_STATUS = 0
		set @dynamicSQL = CONCAT(@dynamicSQL, N', [', @curDate, N'] ')

	end 
-- Закрытие курсора
close [cur];

-- Освободить курсор
deallocate [cur];

set  @dynamicSQL = concat(@dynamicSQL, ' )) as [PivotResultTable] order by [PivotResultTable].[JobTitle] asc' 
)

--set  @dynamicSQL = concat(@dynamicSQL, ' )) as [pivot]')


print(@dynamicSQL)

execute sp_executesql @dynamicSQL
-- execute (@dynamicSQL)


