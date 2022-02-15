/*
Реализовать пользовательскую скалярную функцию, которая возвращает состояние кредитного рейтинга поставщика в текстовом представлении.
Функция должна принимать цифровое представление состояния кредитного рейтинга.
1 = Superior, 2 = Excellent, 3 = Above average, 4 = Average, 5 = Below average
(таб. [Purchasing].[Vendor])
*/
create function dbo.getStrCreditRatingStatus(@CreditRating int)
	returns nvarchar(13)
	as begin
			declare @StrCreditRatingStatus as nvarchar(13);
				set @StrCreditRatingStatus = case @CreditRating when 1 then N'Superior'
				                                                when 2 then N'Excellent'
																when 3 then N'Above average'
																when 4 then N'Average'
																when 5 then N'Below average' end;

			return @StrCreditRatingStatus;
												               
       end;