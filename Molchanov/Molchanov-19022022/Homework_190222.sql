/*
Реализовать пользовательскую скалярную функцию, которая возвращает состояние кредитного рейтинга поставщика в текстовом представлении. 
Функция должна принимать цифровое представление состояния кредитного рейтинга.
1 = Superior, 2 = Excellent, 3 = Above average, 4 = Average, 5 = Below average
(таб. [Purchasing].[Vendor])
*/

use [AdventureWorks3];	                                                                              --переключение базы данных

--Мой вариант----------------------------------------------------------
if object_id ('[CreditRatingName]') is not null drop function [CreditRatingName];
GO
create function [CreditRatingName] (@cred_rating tinyint)                                             --объявление функции, которая принимает переменную (целое число)
returns nvarchar (13)                                                                                 --возвращает строку
as
begin
   return 
     case                                                                                             --варианты ответов
	    when @cred_rating=1 then N'Superior'
	    when @cred_rating=2 then N'Excellent'
	    when @cred_rating=3 then N'Above average'
	    when @cred_rating=4 then N'Average'
	    when @cred_rating=5 then N'Below average'
     end
end
GO

select *, dbo.[CreditRatingName] (t1.[CreditRating]) as [CreditRatingName]                            --выбираем все из таблицы и добавляем колонку с функцией
    from [Purchasing].[Vendor] as t1
;

--Из решения---------------------------------------------------------
GO
create function dbo.getStrCreditRatingStatus(@CreditRating int)                                       --объявление функции, которая принимает переменную (целое число)
	returns nvarchar(13)                                                                              --возвращает строку
	as begin
			declare @StrCreditRatingStatus as nvarchar(13);                                           --объявление переменной
				set @StrCreditRatingStatus = case @CreditRating when 1 then N'Superior'               --присваивание переменной значения одного из вариантов
				                                                when 2 then N'Excellent'
																when 3 then N'Above average'
																when 4 then N'Average'
																when 5 then N'Below average' end;

			return @StrCreditRatingStatus;                                                            --возвращение переменной
												               
       end;


select *, dbo.getStrCreditRatingStatus (t1.[CreditRating]) as [CreditRatingName]                      --аналогичная проверка результата
    from [Purchasing].[Vendor] as t1

/*
Мои вопросы--------------------------------------------------------
1) Насколько обязательно применение dbo. в имени функции? В моем примере работает без dbo. все, кроме использования функции (стр.28). 
2) Я не использовал declare и set, но мой вариант работает. Почему? Как правильно использовать функции? 
*/



