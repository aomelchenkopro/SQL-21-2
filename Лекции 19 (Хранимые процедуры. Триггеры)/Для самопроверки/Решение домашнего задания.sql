-- Расчёт суммы заказа
create procedure addNewOrder 
@mfrId       char(3),      -- переменная для хранения ид. прозводителя товара
@prodId      char(5),      -- переменная для хранения ид. товара
@qty         int,          -- переменная для хранения кол-ва заказанных единиц товара
@cust        int,          -- переменная для хранения ид. клиента
@emp         int,
@orderAmount numeric(15,2) -- сумма заказ
as begin
	set @mfrId  = 'REI';
	set @prodId = '2A44G';
	set @qty    = 4;
	set @cust   = 2124;
	set @emp    = 104;

	declare @storeQty int;
	declare @creditLimit int;

    -- Расчёт суммы заказа
	set @orderAmount = (select t1.PRICE * @qty
	                      from [Training].[dbo].[PRODUCTS] as t1
						 where t1.MFR_ID = @mfrId
						   and t1.PRODUCT_ID = @prodId);

    -- получение кол-ва ед. товара со склада
	select @storeQty = t1.QTY
	  from Training.dbo.ORDERS as t1 
	 where t1.MFR = @mfrId
	   and t1.PRODUCT = @prodId;

	-- получение кред. лимита
	select @creditLimit = t1.QTY
	  from Training.dbo.ORDERS as t1 
	 where t1.MFR = @mfrId
	   and t1.PRODUCT = @prodId;
   
if @storeQty >= @qty and @creditLimit>= @orderAmount
begin

-- Вычитание суммы заказа из кредитного лимита клиента
update [Training].[dbo].[CUSTOMERS]
   set CREDIT_LIMIT = t1.CREDIT_LIMIT - @orderAmount
       output deleted.CREDIT_LIMIT,
              inserted.CREDIT_LIMIT
  from [Training].[dbo].[CUSTOMERS] as t1
 where t1.CUST_NUM = @cust;

-- Вычитание заказаного кол-ва товара со склада 
update [Training].[dbo].[PRODUCTS]
   set QTY_ON_HAND = QTY_ON_HAND - @qty
       output deleted.QTY_ON_HAND,
              inserted.QTY_ON_HAND
  from [Training].[dbo].[PRODUCTS] as t1
 where t1.MFR_ID = @mfrId
   and t1.PRODUCT_ID = @prodId;

-- Увеличение текущих продаж служащего на сумму заказа
update [Training].[dbo].[SALESREPS]
   set SALES = SALES + @orderAmount
       output deleted.SALES,
              inserted.SALES
  from [Training].[dbo].[SALESREPS] as t1 
 where t1.EMPL_NUM =  @emp;

-- Увеличение текущих продаж офиса на сумму заказа
update [Training].[dbo].[OFFICES]
   set SALES = t1.SALES + @orderAmount
       output deleted.SALES,
              inserted.SALES
  from [Training].[dbo].[OFFICES]   as t1
  join [Training].[dbo].[SALESREPS] as t2 on t2.REP_OFFICE = t1.OFFICE
                                         and t2.EMPL_NUM =  @emp;

-- Добавление нового заказа 
insert into [Training].[dbo].[ORDERS] (ORDER_NUM, ORDER_DATE, CUST, REP, MFR, PRODUCT, QTY, AMOUNT)
values (114003, getdate(), @cust, @emp, @mfrId, @prodId, @qty, @orderAmount);

print 'Заказ успешен'
end
else

print 'Заказ не успешен'
end
