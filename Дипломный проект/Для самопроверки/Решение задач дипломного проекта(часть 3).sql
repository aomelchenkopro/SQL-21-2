/*������ �1.
�������� ������, ������������ ������ ��� �������� (��� ����������), ������� ��������� ������ � ������ � 01.01.2008 �� 31.03.2008 
�� �������� �������� QSA.
- ������������ ������� SALESREPS, [dbo].[ORDERS].
- ������������ ���������� ����������� ������� (��������� ANSI SQL-92).
- ������������ �������� between.
- �������������� ����� �������� ��� ���������.*/
select distinct
     t1.N���
from [dbo].[SALESREPS] as t1
join [dbo].[ORDERS]    as t2 on t2.REP = t1.EMPL_NU�
                            and t2.MFR = 'QSA'
                            and t2.ORDER_DATE between '20080101' and '20081231'

/*������ �2.
�������� ������, ������������ ��� �������� � ��������� ������� ���� 35000 ����� ����� ������� �� �������� �������� 'ACI'.
- ������������ ������� [dbo].[CUSTOMERS], [dbo].[ORDERS].
- ������������ ���������� ����������� ������� (��������� ANSI SQL-92).
- ������������ ���������� ������� sum.
- �������������� ����� ������ �������� ������������� �������, ������������ �������, ����� �������.*/

select  t1.CUST_NU�,
        t1.COMPANY,
    sum(t2.A�OUNT)        as SUMM 
  from  [dbo].[CUSTOMERS] as t1
  join  [dbo].[ORDERS]    as t2 on t2.CUST = t1.CUST_NU�
                              and t2.MFR  = 'ACI'
  where t1.CREDITLIMIT > 35000
  group by t1.CUST_NU�,
           t1.COMPANY

/*������ �3.1
�������� ������, ������������ ������ ������ �������� ��������� �� ���������� �������.
���������� ����������� ���� ���, ���� � ��� �� ������� (AGE) ����� ���� ����� � ���������� ��������.
- ������������ ������� [dbo].[SALESREPS], [dbo].[OFFICES].
- ������������ ���������� ����������� ������� (��������� ANSI SQL-89).
- ������������ ���������, ����������, ��������� ������.
- ������������ ���������� ������� MAX.
- �������������� ����� ������ �������� ������������� ���������, ���������, ��� ���������, ���� ������, ������� �������.*/
select * from [dbo].[SALESREPS]
select * from [dbo].[OFFICES]


select t1.EMPL_NU�,
       t1.TITLE,
       t1.N���,
       t1.quota,
       t1.SALES
from [dbo].[SALESREPS]  as t1
where t1.Age in 
               ( 
                  select Max(AGE) as MAX_AGE
                  from  [dbo].[SALESREPS]  as t_1
				   join [dbo].[OFFICES]    as t_2  on t_2.OFFICE  =  t_1.REPOFFICE
						                          and t_2.region  = 'EASTERN'
				);
 

/*������ �3.2
�������� ������, ������������ ������ ������� �� 2008 �, ������� ��������� (�������� �������) ����� ������� ��������
 �� ���������� �������.
���������� ����������� ���� ���, ���� � ��� �� ������� (AGE) ����� ���� ����� � ���������� ��������.
- ������������ ������� [dbo].[ORDERS], [dbo].[SALESREPS], [dbo].[OFFICES].
- ������������ ���������� ����������� ������� (��������� ANSI SQL-92).
- ������������ ��������� � ��������� ����������, ��������� �������.
- �������������� ����� ������ �������� ������������� ������, ���� ������, ������������� ���������, 
������������� ������������� ������, ������������� ������, ����� ������.*/
select * from [dbo].[SALESREPS]
select * from [dbo].[OFFICES]
select * from [dbo].[ORDERS]

select *
from [dbo].[ORDERS] as t3
where t3.REP in (
                  select top 1 
                         with ties
	                     t1.EMPL_NU�
                    from [dbo].[SALESREPS] as t1
                    join [dbo].[OFFICES]   as t2 on t2.OFFICE = t1.REPOFFICE
                                                and t2.REGION = 'Eastern'
                order by t1.AGE desc
				)
and year(t3.ORDER_DATE) = 2008;

/*������ �3.3
�������� ������, ������������ ����� ����� ������� �� ������� ���������� ������ �� 2008 ���, ������� ��������� (�������� �������) 
����� ������� �������� �� ���������� �������.
���������� ����������� ���� ���, ���� � ��� �� ������� (AGE) ����� ���� ����� � ���������� ��������.
- ������������ ������� [dbo].[PRODUCTS], [dbo].[ORDERS], [dbo].[SALESREPS], [dbo].[OFFICES].
- ������������ ���������� ����������� ������� (��������� ANSI SQL-92).
- ������������ ��������� � ��������� ����������, ��������� �������.
- ������������ ���������� ������� SUM.
- �������������� ����� ������ �������� ������������� ���������, ������������� ������������� ������, 
������������� ������, �������� ������, ����� ����� ������ �� 2008 �.*/

select * from [dbo].[SALESREPS]
select * from [dbo].[OFFICES]
select * from [dbo].[ORDERS]
select * from [dbo].[PRODUCTS]


select t_1.REP,
       t_1.MFR,
       t_1.PRODUCT,
       t_2.[DESCRIPTION],
       sum(t_1.A�OUNT) as SUMM
from (select *
  from [dbo].[ORDERS] as t3
 where t3.REP in (
                  select top 1 
                         with ties
	                     t1.EMPL_NU�
                    from [dbo].[SALESREPS] as t1
                    join [dbo].[OFFICES]   as t2 on t2.OFFICE = t1.REPOFFICE
                                                and t2.REGION = 'Eastern'
                order by t1.AGE desc
				)
and year(t3.ORDER_DATE) = 2008)  as t_1
join [dbo].[PRODUCTS]            as t_2 on t_2.MFR_ID = t_1.MFR
                                and t_2.PRODUCT_ID = t_1.PRODUCT
group by t_1.REP,
         t_1.MFR,
         t_1.PRODUCT,
         t_2.[DESCRIPTION];

/*������ �4.
�������� ������, ������������ ��� ������� ������ �������� ����������� (�� ���������� �������) �����.
���������� ����������� ���� ���, ���� � �� �� ���������� ������� ����� ����� ����� ��������� �������.
- ������������ ������� PRODUCTS, [dbo].[ORDERS], [dbo].[SALESREPS], [dbo].[OFFICES],
- ������������ ���������� ����������� ������� (��������� ANSI SQL-92).
- ������������ ����������� ������� DENSE_RANK.
- ������������ ���������� ������� COUNT � ������ ������������ null.
- �������������� ����� ������ �������� ������, ������������� ������������� ������, ������������� ������, �������� ������, 
���������� �������, ���� ������.*/

select * from [dbo].[SALESREPS]
select * from [dbo].[OFFICES]
select * from [dbo].[ORDERS]
select * from [dbo].[PRODUCTS]

select t1.OFFICE,
       t1.CITY,
       t2.EMPL_NU�,
       t2.REPOFFICE,
       t3. *,
       count(t3.ORDER_NU�) over (partition by t1.CITY, t3.mfr, t3.product ) as CNT
into #loc_03	   
from [dbo].[OFFICES]   as t1
join [dbo].[SALESREPS] as t2 on t2.REPOFFICE = t1.OFFICE
join [dbo].[ORDERS]    as t3 on t3.REP = t2.EMPL_NU�;

select *,
      dense_rank()over(partition by(city) order by (cnt) desc) as DR 
into #loc_04
from #loc_03

select distinct 
       l1.OFFICE,
       l1.MFR,
       l1.PRODUCT,
       l2.DESCRIPTION,
       l1.CNT,
       l1.DR
from #loc_04          as l1
join [dbo].[PRODUCTS] as l2 on l2.MFR_ID     = l1.MFR
                           and l2.product_id = l1.PRODUCT
where DR = 1;

/*������ � 5.
�������� ������, ������������ ������ �������, ������� �� ����������� � Chicago.
- ������������ ������� [dbo].[OFFICES], [dbo].[SALESREPS], [dbo].[ORDERS], [dbo].[PRODUCTS].
- ������������ ���������� � ������� ��������� ������� (��������� ANSI SQL-92).
- �������������� ����� ������ �������� ������������� �������������, ������������� ������,
 �������� ������, ���� �� �������, ���������� �� ������.*/

      select t3. * 
        into #loc_1
		from [dbo].[OFFICES]   as t1
        join [dbo].[SALESREPS] as t2 on t2.REPOFFICE  = t1.OFFICE
        join [dbo].[ORDERS]    as t3 on t3.REP        = t2.[EMPL_NU�]
       where t1.OFFICE = 12;
GO
      select t2.MFR_ID,
             t2.PRODUCT_ID,
             t2.DESCRIPTION,
             t2.PRICE,
             t2.QTY_ON_HAND
        from #loc_1           as t1
  right join [dbo].[PRODUCTS] as t2 on t2.MFR_ID     = t1.MFR
                                   and t2.PRODUCT_ID = t1.PRODUCT
       where t1.ORDER_NU� is null;

/*
������ � 6.
�������� �������� ���������.
��������� ��������� ���������:
- ������������� �������.
- ������������� ���������.
- ������������� �������������.
- ������������� ������.
- ���������� ������.

�� ������ �����, ��������� ��������� ������� ���������� ���������� ������ ������ �� ������
����� �� ������ �����, ���������� ������ ����� ������. �� ������� �����, ���� ����� ���������� ������ �������� 
������ ��� ����� ����� ������ - ����������� ���������� ������ ������ �� ������, ����� ������ ���������� �� ���������� ������ �������� � ����� �������� � ������� �������.
�� �������� ����� ����� ������� ������ ��������� ������������� �� ����� ������. �� ����� ����� ����� ������� ������ ����� 
������� ���������, ������������� �� ����� ������. �� �������������� ����� ��������� ������� ��������� � ������� ��������.
*/

-- ������ ����� ������
create procedure addNewOrder 
@mfrId       char(3),      -- ���������� ��� �������� ��. ������������ ������
@prodId      char(5),      -- ���������� ��� �������� ��. ������
@qty         int,          -- ���������� ��� �������� ���-�� ���������� ������ ������
@cust        int,          -- ���������� ��� �������� ��. �������
@emp         int,
@orderAmount numeric(15,2) -- ����� �����
as begin
	set @mfrId  = 'REI';
	set @prodId = '2A44G';
	set @qty    = 4;
	set @cust   = 2124;
	set @emp    = 104;

	declare @storeQty int;
	declare @creditLimit int;

    -- ������ ����� ������
	set @orderAmount = (select t1.PRICE * @qty
	                      from [Training].[dbo].[PRODUCTS] as t1
						 where t1.MFR_ID = @mfrId
						   and t1.PRODUCT_ID = @prodId);

    -- ��������� ���-�� ��. ������ �� ������
	select @storeQty = t1.QTY
	  from Training.dbo.ORDERS as t1 
	 where t1.MFR = @mfrId
	   and t1.PRODUCT = @prodId;

	-- ��������� ����. ������
	select @creditLimit = t1.QTY
	  from Training.dbo.ORDERS as t1 
	 where t1.MFR = @mfrId
	   and t1.PRODUCT = @prodId;
   
if @storeQty >= @qty and @creditLimit>= @orderAmount
begin

-- ��������� ����� ������ �� ���������� ������ �������
update [Training].[dbo].[CUSTOMERS]
   set CREDIT_LIMIT = t1.CREDIT_LIMIT - @orderAmount
       output deleted.CREDIT_LIMIT,
              inserted.CREDIT_LIMIT
  from [Training].[dbo].[CUSTOMERS] as t1
 where t1.CUST_NUM = @cust;

-- ��������� ���������� ���-�� ������ �� ������ 
update [Training].[dbo].[PRODUCTS]
   set QTY_ON_HAND = QTY_ON_HAND - @qty
       output deleted.QTY_ON_HAND,
              inserted.QTY_ON_HAND
  from [Training].[dbo].[PRODUCTS] as t1
 where t1.MFR_ID = @mfrId
   and t1.PRODUCT_ID = @prodId;

-- ���������� ������� ������ ��������� �� ����� ������
update [Training].[dbo].[SALESREPS]
   set SALES = SALES + @orderAmount
       output deleted.SALES,
              inserted.SALES
  from [Training].[dbo].[SALESREPS] as t1 
 where t1.EMPL_NUM =  @emp;

-- ���������� ������� ������ ����� �� ����� ������
update [Training].[dbo].[OFFICES]
   set SALES = t1.SALES + @orderAmount
       output deleted.SALES,
              inserted.SALES
  from [Training].[dbo].[OFFICES]   as t1
  join [Training].[dbo].[SALESREPS] as t2 on t2.REP_OFFICE = t1.OFFICE
                                         and t2.EMPL_NUM =  @emp;

-- ���������� ������ ������ 
insert into [Training].[dbo].[ORDERS] (ORDER_NUM, ORDER_DATE, CUST, REP, MFR, PRODUCT, QTY, AMOUNT)
values (114003, getdate(), @cust, @emp, @mfrId, @prodId, @qty, @orderAmount);

print '����� �������'
end
else

print '����� �� �������'
end

