create database [SQL-21-2-Thomas];

/*
Задача № 1. Создание таблицы PRODUCTS
PRODUCTS
( 
MFR_ID                   -- Идентификатор производителя (строка постоянной длинны(3),не может быть пустым) 
PRODUCT_ID               -- Идентификатор товара        (строка постоянной длинны(5),не может быть пустым) 
[DESCRIPTION]            -- Описание товара             (строка переменной длинны(50),не может быть пустым) 
PRICE                    -- Цена товара                 (точное десятичное число точность  9 масштаб  2, не может быть пустым)
QTY_ON_HAND              -- Количество на складе        (точное целое число, не может быть пустым)
( MFR_ID , PRODUCT_ID )  -- Составной первичный ключ    (Идентификатор производителя,Идентификатор товара)
);
*/

create table [PRODUCTS]                              -- Почему пожчеркивает????
(
	[MFR_ID]            nchar(3) not null,                   -- Идентификатор производителя
	[PRODUCT_ID]        nchar(5) not null,                   -- Идентификатор товара   
	[DESCRIPTION]       nvarchar(50) not null,               -- Описание товара 
	[PRICE]             numeric(9,2) not null,               -- Цена товара
	[QTY_ON_HAND]       int not null                         -- Количество на складе
);

INSERT INTO [PRODUCTS] ([MFR_ID], [PRODUCT_ID], [DESCRIPTION], [PRICE], [QTY_ON_HAND])
values  (N'REI', N'2А45С', N'Ratchet Link', 2750.00, 210),
		(N'ACI', N'4100У', N'Widget Remover', 79.00, 25),
		(N'QSA', N'Xk47', N'Reducer', 355.00, 38),
		(N'BIC', N'41672', N'Plate', 180.00, 0),
		(N'IММ', N'779С', N'900-lb Brace', 1875.00, 9),
		(N'ACI', N'41003', N'Size 3 Widget', 107.00, 207),
		(N'ACI', N'41004', N'Size 4 Widget', 117.00, 139),
		(N'ВIС', N'41003', N'Handle', 652.00, 3),
		(N'IММ', N'887Р', N'Brace Pin', 250.00, 24),
		(N'QSA', N'Xk48', N'Reducer', 134.00, 203),
		(N'REI', N'2A44L', N'Left Hinge', 4500.00, 12),
		(N'FEA', N'112', N'Housing', 148.00, 115),
		(N'IММ', N'887Н', N'Brace Holder', 54.00, 223),
		(N'BIC', N'41089', N'Retainer', 225.00, 78),
		(N'ACI', N'41001', N'Size 1 Widget', 55.00, 277),
		(N'IММ', N'775С', N'500 - lb Brace', 1425.00, 5),
		(N'ACI', N'4100Z', N'Widget Installer', 2500.00, 28),
		(N'QSA', N'ХК48А', N'Reducer', 177.00, 37),
		(N'ACI', N'41002', N'Size 2 Widget', 76.00, 167),
		(N'REI', N'2A44R', N'Right Hinge', 4500.00, 12),
		(N'IММ', N'773С', N'300 - lb Brace', 975.00, 28),
		(N'ACI', N'4100Х', N'Widget Adjuster', 25.00, 37),
		(N'FEA', N'114', N'Motor Mount', 243.00, 15),
		(N'IММ', N'887Х', N'Brace Retainer', 475.00, 32),
		(N'REI', N'2A44G', N'Hinge Pin', 350.00, 14);

alter table [dbo].[PRODUCTS] add constraint PRODUCTS_PK primary key ([MFR_ID] , [PRODUCT_ID]);

/*Задача № 2. Создание таблицы OFFICES
OFFICES
( 
OFFICE   -- Идентификатор офиса              (точное целое число, не может быть пустым)
CITY     -- Город в котором находится офис   (строка переменной длинны(15), не может быть пустым)
REGION   -- Регион в котором находится офис  (строка переменной длинны(10), не может быть пустым, значение по умолчанию 'Eastern' )
MGR      -- Идентфикатор управляющего офисом (точное целое число, значение по умолчанию 106)
[TARGET] -- Плановые продажи                 (точное десятичное число точность  9  масштаб  2, не может быть меньше нуля) 
SALES    -- Продажи офиса                    (точное десятичное число  точность  9 масштаб  2, не может быть пустым, значение по умлочанию 0.00) 
(OFFICE) -- Первичный ключ                   (идентификатор офиса)
(CITY)   -- Ограничение город должен быть уникальным
) ;*/

create table [OFFICES]
( 
	[OFFICE]   int not null,                                   -- Идентификатор офиса   
	[CITY]     nvarchar(15) not null unique,                   -- Город в котором находится офис  
	[REGION]   nvarchar(10) not null default N'Eastern',       -- Регион в котором находится офис  
	[MGR]      tinyint default 106,                            -- Идентфикатор управляющего офисом 
	[TARGET]   decimal(9,2) check ([TARGET] >=0),              -- Плановые продажи                  ??????????????
	[SALES]    decimal(9,2) not null default 0.00              -- Продажи офиса                    
) ;

insert into [OFFICES] ([OFFICE], [CITY], [REGION], [MGR], [TARGET], [SALES])
values (22, N'Denver', N'Western', 108, 300000.00, 186042.00),
       (11, N'New York', N'Eastern', 106, 575000.00, 692637.00),
	   (12, N'Chicago', N'Eastern', 104, 800000.00, 735042.00),
	   (13, N'Atlanta', N'Eastern', 105, 350000.00, 367911.00),
	   (21, N'Los Angeles', N'Western', 108, 725000.00, 835915.00);

alter table [dbo].[OFFICES] add constraint OFFICE_PK primary key ([OFFICE]);

/*
Задача № 3. Создание таблицы SALESREPS
 SALESREPS
(
EMPL_NUМ  -- Идентификатор служащего                   (точное целое число, должен быть в диапазоне 101 - 199, не может быть пустым) 
NАМЕ      -- Имя служащего                             (строка переменной длинны(15), не может быть пустым)
AGE       -- Возраст служащего                         (точное целое число, должен быть больше или равен 21)
REPOFFICE -- Офис в котором работает служащий          (точное целое число)
TITLE     -- Должность служащего                       (строка переменной длинны(10))
HIREDATE  -- Дата приема на работу                     (год, месяц, день, не может быть пустым)
МANAGER   -- Идентификатор менеджера данного служащего (точное целое число)
QUOTA     -- Личный план                               (точное десятичное число точность  9 масштаб  2, не может быть меньше нуля)
SALES     -- Фактические продажи служащего             (точное десятичное число  точность  9  масштаб 2, не может быть пустым)
(EMPL_NUМ)-- Первичный ключ 
          -- Внешний ключ (Офис в котором работает служащий) ссылается на таблицу офисы (Идентификатор офиса)
) ;
*/

create table SALESREPS
(
	[EMPL_NUМ]       tinyint not null check([EMPL_NUМ] > 100 and [EMPL_NUМ] < 200) primary key,  -- Идентификатор служащего 
	[NАМЕ]           nvarchar(15) not null,                                                      -- Имя служащего                             
	[AGE]            tinyint check ([AGE] >= 21),                                                -- Возраст служащего                         
	[REPOFFICE]      int,                                                                        -- Офис в котором работает служащий
	[TITLE]          nvarchar(10),                                                               -- Должность служащего                     
	[HIREDATE]       date not null,                                                              -- Дата приема на работу                    
	[МANAGER]        tinyint,                                                                    -- Идентификатор менеджера данного служащего 
	[QUOTA]          decimal(9,2)  check([QUOTA] >= 0),                                          -- Личный план      
	[SALES]          decimal(9,2) not null                                                       -- Фактические продажи служащего            
	
	constraint [REPOFFICE_FK] foreign key ([REPOFFICE]) references [dbo].[OFFICES]([OFFICE])  
);
create nonclustered index index1 on [SQL-21-2-Thomas].[dbo].[SALESREPS]([REPOFFICE]);

insert into [dbo].[SALESREPS]([EMPL_NUМ], [NАМЕ], [AGE], [REPOFFICE], [TITLE], [HIREDATE], [МANAGER], [QUOTA], [SALES])
values (105, N'Bill Adams', 37,	13, N'Sales Rep', N'20060212', 104,	350000.00, 367911.00),
       (109, N'Mary Jones', 31, 11, N'Sales Rep', N'20071012', 106, 300000.00, 392725.00),
	   (102, N'Sue Smith', 48, 21, N'Sales Rep', N'20041210', 108, 350000.00, 474050.00),
	   (106, N'Sam Clark', 52, 11, N'VP Sales', N'20060614', NULL, 275000.00, 299912.00),
	   (104, N'ВоЬ Smith', 33, 12, N'Sales Mgr', N'20050519', 106, 200000.00, 142594.00),
	   (101, N'Dan Roberts', 45, 12, N'Sales Rep', N'20041020', 104, 300000.00, 305673.00),
	   (110, N'Tom Snyder', 41, NULL, N'Sales Rep', N'20080113', 101, NULL, 75985.00),
	   (108, N'Larry Fitch', 62, 21, N'Sales Mgr', N'20071012', 106, 350000.00, 361865.00),
	   (103, N'Paul Cruz', 29, 12, N'Sales Rep', N'20050301', 104, 275000.00, 286775.00),
	   (107, N'Nancy Angelli', 49, 22, N'Sales Rep', N'20061114', 108, 300000.00, 186042.00);

/*
Задача № 4. Модификация таблицы SALESREPS
Модификация таблицы служащие
Добавляется внешний ключ (Идентификатор менеджера данного служащего) 
ссылается на таблицу служащие (Идентификатор служащего).
*/

alter table [dbo].[SALESREPS] add constraint [МANAGER_FK] foreign key ([МANAGER]) references [dbo].[SALESREPS]([EMPL_NUМ]);
create nonclustered index index2 on [SQL-21-2-Thomas].[dbo].[SALESREPS]([МANAGER]);

/*
Задача № 5. Модификация таблицы OFFICES
Модификация таблицы офисы
Добавляется внешний ключ (Идентфикатор управляющего офисом) 
ссылается на таблицу служащие (Идентификатор служащего)
*/

alter table [dbo].[OFFICES] add constraint [MGR_FK] foreign key ([MGR]) references [dbo].[SALESREPS]([EMPL_NUМ]);
create nonclustered index index3 on [SQL-21-2-Thomas].[dbo].[OFFICES]([MGR]);

/*
Задача № 6. Создание таблицы CUSTOMERS
 CUSTOMERS
(
CUST_NUМ    -- Идентфикатор клиента  (точное целое число, не может быть пустым)
COMPANY     -- Наименование клиента  (строка переменной длинны(20), не может быть пустым)
CUST_REP    -- Закрепленный служащий (точное целое число)
CREDITLIMIT -- Лимит кредитиа        (точное десятичное число точность  9  масштаб 2)
(CUST_NUМ)  -- Первичный ключ        (Идентфикатор клиента)
(CUST_REP)  -- Внешний ключ          (Закрепленный служащий) ссылается на таблицу служащие(Идентификатор служащего)
) ;
*/

create table CUSTOMERS
(
	[CUST_NUМ]        int not null primary key,             -- Идентфикатор клиента  
	[COMPANY]         nvarchar(20) not null,                -- Наименование клиента  
	[CUST_REP]        tinyint,                              -- Закрепленный служащий 
	[CREDITLIMIT]     decimal(9,2)                          -- Лимит кредитиа        

	constraint [CUST_REP_FK] foreign key ([CUST_REP]) references [dbo].[SALESREPS]([EMPL_NUМ])
);

create nonclustered index index4 on [SQL-21-2-Thomas].[dbo].[CUSTOMERS]([CUST_REP]);

insert into [dbo].[CUSTOMERS]([CUST_NUМ], [COMPANY], [CUST_REP], [CREDITLIMIT])
values (2111, N'JCPInc.', 103, 50000.00),
       (2102, N'FirstCorp.', 101, 65000.00),
	   (2103, N'AcmeMfg.', 105, 50000.00),
	   (2123, N'Carter&Sons', 102, 40000.00),
	   (2107, N'АсеInternational', 110, 35000.00),
	   (2115, N'SmithsonCorp.', 101, 20000.00),
	   (2101, N'JonesMfg.', 106, 65000.00),
	   (2112, N'Zetacorp', 108, 50000.00),
	   (2121, N'QМАAssoc.', 103, 45000.00),
	   (2114, N'OrionCorp.', 102, 20000.00),
	   (2124, N'PeterBrothers', 107, 40000.00),
	   (2108, N'Holm&Landis', 109, 55000.00),
	   (2117, N'J.P.Sinclair', 106, 35000.00),
	   (2122, N'Three - WayLines', 105, 30000.00),
	   (2120, N'RicoEnterprises', 102, 50000.00),
	   (2106, N'FredLewisCorp.', 102, 65000.00),
	   (2119, N'SolomonInc.', 109, 25000.00),
	   (2118, N'MidwestSystems', 108, 60000.00),
	   (2113, N'Ian&Schmidt', 104, 20000.00),
	   (2109, N'Chen Associates', 103, 25000.00),
	   (2105, N'ААА Investments', 101, 45000.00);

/*
Задача № 7. Создание таблицы ORDERS
 ORDERS
(
ORDER_NUМ        -- Идентификатор заказа               (точное целое число, не может быть пустым)
ORDER_DATE       -- Дата заказа                        (год, месяц, день, не может быть пустым)
CUST             -- Идентификатор клиента              (точное целое число, не может быть пустым)
REP              -- Идентификатор служащего            (точное целое число)
MFR              -- Идентификатор производителя товара (строка постоянной длинны(3), не может быть пустым)
PRODUCT          -- Идентификтор товара                (строка постоянной длинны(5), не может быть пустым)
QTY              -- Количество товара                  (точное целое число, не может быть пустым)
AМOUNT           -- Сумма заказа                       (точное десятичное число точность  9 масштаб 2, не может быть пустым)
(ORDER_NUМ)      -- Первичный ключ идентификатор заказа 
(CUST)           -- Внешний ключ (Идентификатор клиента) ссылается на таблицу клиенты
(REP)            -- Внешний ключ (Идентификатор служащего) ссылается на таблицу служащие 
(MFR , PRODUCT ) -- Составной внешний ключ (Идентификатор производителя товара, Идентификтор товра) ссылается на таблицу продукты

) ;
*/

create table [dbo].[ORDERS]
(
	[ORDER_NUМ]                int not null primary key,          -- Идентификатор заказа               
	[ORDER_DATE]               date not null,                     -- Дата заказа                       
	[CUST]                     int not null,                      -- Идентификатор клиента              
	[REP]                      tinyint,                           -- Идентификатор служащего           
	[MFR]                      nchar(3) not null,                 -- Идентификатор производителя товара 
	[PRODUCT]                  nchar(5) not null,                 -- Идентификтор товара                
	[QTY]                      int not null,                      -- Количество товара                 
	[AМOUNT]                   decimal(9,2) not null              -- Сумма заказа       

	constraint [CUST_FK] foreign key ([CUST]) references [dbo].[CUSTOMERS]([CUST_NUМ]),
	constraint [REP_FK] foreign key ([REP]) references [dbo].[SALESREPS]([EMPL_NUМ]),
	constraint [MFR_PRODUCT_FK] foreign key ([MFR], [PRODUCT]) references [dbo].[PRODUCTS]([MFR_ID], [PRODUCT_ID])
);

create nonclustered index index5 on [SQL-21-2-Thomas].[dbo].[ORDERS]([CUST]);
create nonclustered index index6 on [SQL-21-2-Thomas].[dbo].[ORDERS]([REP]);
create nonclustered index index7 on [SQL-21-2-Thomas].[dbo].[ORDERS]([MFR], [PRODUCT]);

insert into [dbo].[ORDERS]([ORDER_NUМ], [ORDER_DATE], [CUST], [REP], [MFR], [PRODUCT], [QTY], [AМOUNT])
values (112961, N'20071217', 2117, 106, N'REI', N'2A44L', 7, 31500.00),
	   (113012, N'20080111', 2111, 105, N'ACI', N'41003', 35, 3745.00),
	   (112989, N'20080103', 2101, 106, N'FEA', N'114', 6, 1458.00),
	   (113051, N'20080210',2102, 101, N'ACI', N'41004', 34, 3978.00),
	   (113036, N'20080130', 2107, 110, N'ACI', N'4100Z', 9, 22500.00),
	   (113045, N'20080202', 2112, 108, N'REI', N'2A44R', 10, 45000.00),
	   (112963, N'20071217', 2103, 105, N'ACI', N'41004', 28, 3276.00),
	   (113013, N'20080114',  2118, 108, N'QSA', N'Xk47', 2, 1420.00),
	   (112968, N'20071012', 2118, 108, N'ВIС', N'41003', 1, 652.00),
	   (113058, N'20080223', 2108, 109, N'FEA', N'112', 10, 1480.00),
	   (112997, N'20080108', 2124, 107, N'ВIС', N'41003', 1, 652.00),
	   (112983, N'20071227', 2103, 105, N'ACI', N'41004', 6, 702.00),
	   (113024, N'20080120', 2114, 108, N'QSA', N'Xk47', 20, 7100.00),
	   (113062, N'20080224', 2124, 107, N'FEA', N'114', 10, 2430.00),
	   (112979, N'20071012', 2114, 102, N'ACI', N'4100Z', 6, 15000.00),
	   (113027, N'20080122', 2103, 105, N'ACI', N'41002', 54, 4104.00),
	   (113007, N'20080108', 2112, 108, N'IММ', N'773С', 3, 2925.00),
	   (113069, N'20080302', 2109, 107, N'IММ', N'775С', 22, 31350.00),
	   (113034, N'20080129', 2107, 110, N'REI', N'2А45С', 8, 632.00),
	   (112992, N'20071104', 2118, 108, N'ACI', N'41002', 10, 760.00),
	   (112975, N'20071012', 2111, 103, N'REI', N'2A44G', 6, 2100.00),
	   (113055, N'20080215', 2108, 101, N'ACI', N'4100Х', 6, 150.00),
	   (113048, N'20080210', 2120, 102, N'IММ', N'779С', 2, 3750.00),
	   (112993, N'20070104', 2106, 102, N'REI', N'2А45С', 24, 1896.00),
	   (113065, N'20080227', 2106, 102, N'QSA', N'Xk47', 6, 2130.00),
	   (113003, N'20080125', 2108, 109, N'IММ', N'779С', 3, 5625.00),
	   (113049, N'20080210', 2118, 108, N'QSA', N'Xk47', 2, 776.00),
	   (112987, N'20071231', 2103, 105, N'ACI', N'4100У', 11, 27500.00),
	   (113057, N'20080218', 2111, 103, N'ACI', N'4100Х', 24, 600.00),
	   (113042, N'20080202', 2113, 101, N'REI', N'2A44R', 5, 22500.00);
