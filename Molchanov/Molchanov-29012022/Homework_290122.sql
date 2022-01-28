
use [AdventureWorks3];
/*
Задача 1
"Напишите запрос возвращающий детали заказа, у которого наибольшее кол-во деталей (позиций).
Учитывайте вероятность того, что сразу несколько заказов могут иметь одно и тоже кол-во деталей.
Рассчитайте долю каждой отдельной детали к общей сумме заказа, в процентном соотношении.
- Используются таблицы: [Sales].[SalesOrderDetail]
- Задействуйте оконно агрегатную функцию sum
- Рез. набор данных содержит: Идент. заказа, идент детали заказа, сумму детали заказа, долю"											
*/

											


--Мой вариант c with ties-------------------------------------------------------------------------------------------------------------- 

with [MaxDetailCountOrder] as                                                                         --1.Выбраны все идент. заказов с максимальным количеством деталей: 
(
select 
       top 1 with ties                                                                                --выбрано максимальное значение идент. заказов с повторениями
	   t1.[SalesOrderID]
   from [Sales].[SalesOrderDetail] as t1
  order by count (t1.[LineTotal]) over (partition by t1.[SalesOrderID]) desc                          --идент. заказов сгрупированны по количеству деталей по убыванию
)
											
select t1.[SalesOrderID],                                                                             --идент. заказов
       t1.[SalesOrderDetailID],                                                                       --идент. деталей заказов
	   t1.[LineTotal],                                                                                --сумма деталей заказа
	   t1.[LineTotal]/sum (t1.[LineTotal]) over (partition by t1.[SalesOrderID])*100 as [DolaOverSum] --доля суммы деталей заказа
   from [Sales].[SalesOrderDetail] as t1
     where t1.[SalesOrderID] in                                                                       --где идент. заказов соответствуют идент. из Запроса 1
	       (select t1.[SalesorderID]
		      from [MaxDetailCountOrder] as t1)
   order by t1.[SalesOrderID] desc, [DolaOverSum] desc                                                --упорядочить по убыванию по сумме заказа, доле суммы деталей заказа
;					


--Мой вариант без with ties --------------------------------------------------------------------------------------------------------------
with [MaxDetailCountOrder] as                                                                         --1.Выбраны все ID заказов с максимальным количеством деталей :
(
select t1.[SalesOrderID]                                                                              --выбрать идент. заказов
	from [Sales].[SalesOrderDetail] as t1
    group by t1.[SalesOrderID]                                                                      
      having count (t1.[SalesOrderDetailID]) in (                                                     --сумма деталей которых соответствует
                                  select top 1 count (t1.[SalesOrderDetailID])                        --наибольшему значению суммы деталей заказов
                                      from [Sales].[SalesOrderDetail] as t1
                                    group by t1.[SalesOrderID]
                                    order by count (t1.[SalesOrderDetailID]) desc                     --упорядоченных по убыванию суммы деталей заказов
                                  )
)
											
select t1.[SalesOrderID],                                                                             --идент. заказов
       t1.[SalesOrderDetailID],                                                                       --идент. деталей заказов
	   t1.[LineTotal],                                                                                --сумма деталей заказа
	   t1.[LineTotal]/sum (t1.[LineTotal]) over (partition by t1.[SalesOrderID])*100 as [DolaOverSum] --доля суммы деталей заказа
   from [Sales].[SalesOrderDetail] as t1
     where t1.[SalesOrderID] in                                                                       --где идент. заказов соответствуют идент. из Запроса 1
	       (select t1.[SalesorderID]
		      from [MaxDetailCountOrder] as t1)
   order by t1.[SalesOrderID] desc, [DolaOverSum] desc                                                --упорядочить по убыванию по сумме заказа, доле суммы деталей заказа
;




--Из решения--------------------------------------------------------------------------------------------------------------------
with [Orders] as (                                                                                         --1. Выбираются:
select t1.[SalesOrderID],                                                                                  --идент. заказов
       t1.[SalesOrderDetailID],                                                                            --идент. деталей заказов
	   t1.[LineTotal]                                                                                      --сумма деталей заказа
  from [Sales].[SalesOrderDetail] as t1 
)

select t3.[SalesOrderID],                                                                                  --идент. заказов
       t3.[SalesOrderDetailID],                                                                            --идент. деталей заказов
	   t3.[LineTotal],                                                                                     --сумма деталей заказа
	   t3.[LineTotal] / sum(t3.[LineTotal])over(partition by t3.[SalesOrderID]) * 100 as [DolaOverSum]     --доля суммы деталей заказа
  from [Orders] as t3                                                                                      --из Выборки 1, идент. заказов которых равны
 where t3.[SalesOrderID] in (
							select t2.[SalesOrderID]                                                       --идент. заказов
							  from [Orders] as t2                                                          --из Выборки 1
							 group by t2.[SalesOrderID]
							having count(distinct t2.SalesOrderDetailID) =(                                --сумма деталей которых соответствует
							                                               select top 1                    --наибольшему значению суммы деталей заказов
																				   count(distinct t1.[SalesOrderDetailID]) as [qty]
																			  from [Orders] as t1          --из Выборки 1
																			 group by t1.[SalesOrderID]
                                                                             order by [qty] desc)          --упорядочить по убыванию по сумме заказа
																			 )
order by t3.[SalesOrderID],  [DolaOverSum] desc                                                            --упорядочить по убыванию по сумме заказа, доле суммы деталей заказа
;

/*
Задача 2
"Напишите запрос, который для работников на должностях
European Sales Manager, North American Sales Manager, Pacific Sales Manager, Sales Representative,
вернет по 3 последних заказа (за все время). Последний заказа определяется по дате заказа (OrderDate) и
по индет. заказа (SalesOrderID). Чем больше дата и идентификатор заказа, тем позднее закал был проведен.
Например, 2014-05-01 00:00:00.000 и 113164 больше чем 2014-05-01 00:00:00.000 и 112471.
Работники на указанных должностях, которые не проводили ни одного заказа остаются самом конце рез. набора данных.
Исключить из выборки сотрудников, которые проводили заказы (за все время) на товары с номерами (ProductNumber) FW-M423, FW-M762, FW-M928, FW-R762, FW-R820 .
- Используются таблицы: [HumanResources].[Employee], [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Production].[Product]
- Задействуйте ранжирующую функцию dense_rank
- Результирующий набор данных содержит: Идент. работника, наименование должности (в верхнем регистре без пробелов в начале),
идент.заказа, дата проведения заказа, идент. детали заказа, сума заказа, сумма детали заказа,
номер продукта(в верхнем регистре без пробелов в начале), ранг строки."	
- Отсортируйте рез. набор данных по идент. сотрудника, по дате заказа (по убыванию), по идент заказа (по убыванию)

*/									
									


with CommonTable as                                                                                    --1.Запрос выбирает всю требуемую информацию
(select t1.[BusinessEntityID],                                                                         --идент. сотрудника
       upper (ltrim (t1.[JobTitle])) as [JobTitle],                                                    --наименование должности (в верхнем регистре без пробелов в начале)
	   t2.[SalesOrderID],                                                                              --идент.заказа
	   t2.[OrderDate],                                                                                 --дата проведения заказа
	   t3.[SalesOrderDetailID],                                                                        --идент. детали заказа
	   t2.[SubTotal],                                                                                  --сумма заказа
	   t3.[LineTotal],                                                                                 --сумма детали заказа
	   t4.[ProductNumber],                                                                             --номер продукта(в верхнем регистре без пробелов в начале)
	   upper (ltrim (t4.[Name])) as [Name],                                                            --имя продукта(в верхнем регистре без пробелов в начале)
	   dense_rank() over (partition by t2.SalesPersonID                                                
	                     order by t2.OrderDate desc,  t2.SalesOrderID desc) as [DRNK]                  --ранг строки
    from [HumanResources].[Employee] as t1
	left outer join [Sales].[SalesOrderHeader] as t2 on t2.SalesPersonID=t1.BusinessEntityID
	left outer join [Sales].[SalesOrderDetail] as t3 on t3.SalesOrderID=t2.SalesOrderID
	left outer join [Production].[Product]     as t4 on t4.ProductID=t3.ProductID
)

select *                                                                                               --выбрать все из Запроса 1
    from CommonTable as t5
	where t5.JobTitle in (N'European Sales Manager', N'North American Sales Manager',
	                      N'Pacific Sales Manager', N'Sales Representative')                           --выбрать соответствующие должности
	and t5.BusinessEntityID not in (
	                      select t6.[BusinessEntityID]                                                 --исключаются коды продуктов
						     from CommonTable as t6
						  where t6.ProductNumber in (N'FW-M423', N'FW-M762', N'FW-M928', N'FW-R762', N'FW-R820') 
						  )
    and t5.DRNK<=3                                                                                     --выбрать ранг не более 3
 order by case when t5.SalesOrderID is null then 0 else 1 end desc,                                    --перенос работников без заказов в конец
                    t5.BusinessEntityID asc,                                                           --упорядочить по идент. сотрудника по убыванию
					t5.OrderDate desc,                                                                 --упорядочить по дате заказа по убыванию
					t5.SalesOrderID desc                                                               --упорядочить по идент.заказа по убыванию
;


 /*
 Вопрос. Почему в ответе добавлено  "and t2.BusinessEntityID is not null" во вложенном запросе?
 Объединение происходит через left outer join. BusinessEntityID находится в самой левой таблице, т.е. к ней присоединяются остальные.
 Таким образом null не могут добавиться в колонку BusinessEntityID в момент объединения. Они там есть только если они там были первоначально.
 Но null не могут быть в колонке BusinessEntityID и первоначально т.к. это первичный ключ.
 */
