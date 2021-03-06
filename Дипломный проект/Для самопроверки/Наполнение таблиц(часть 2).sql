
ALTER TABLE SALESREPS
DROP CONSTRAINT SALESREPS_МANAGER_FK;

ALTER TABLE SALESREPS
DROP CONSTRAINT WORKSIN;


-- Наполнение таблицы SALESREPS
insert into SALESREPS
(EMPL_NUМ, NАМЕ, AGE, REPOFFICE,TITLE,HIREDATE, МANAGER,  QUOTA, SALES)
values
(105,'Bill Adams',37,13,'Sales Rep','20060212',104,350000.00,367911.00);

insert into SALESREPS
(EMPL_NUМ, NАМЕ, AGE, REPOFFICE,TITLE,HIREDATE, МANAGER,  QUOTA, SALES)
values
(109,'Mary Jones',31,11,'Sales Rep','20071012',106,300000.00,392725.00);

insert into SALESREPS
(EMPL_NUМ, NАМЕ, AGE, REPOFFICE,TITLE,HIREDATE, МANAGER,  QUOTA, SALES)
values
(102,'Sue Smith',48,21,'Sales Rep','20041210',108,350000.00,474050.00);

insert into SALESREPS
(EMPL_NUМ, NАМЕ, AGE, REPOFFICE,TITLE,HIREDATE, МANAGER,  QUOTA, SALES)
values
(106,'Sam Clark',52,11,'VP Sales','20060614',NULL,275000.00,299912.00);

insert into SALESREPS
(EMPL_NUМ, NАМЕ, AGE, REPOFFICE,TITLE,HIREDATE, МANAGER,  QUOTA, SALES)
values
(104,'ВоЬ Smith',33,12,'Sales Mgr','20050519',106,200000.00,142594.00);

insert into SALESREPS
(EMPL_NUМ, NАМЕ, AGE, REPOFFICE,TITLE,HIREDATE, МANAGER,  QUOTA, SALES)
values
(101,'Dan Roberts',45,12,'Sales Rep','20041020',104,300000.00,305673.00);

insert into SALESREPS
(EMPL_NUМ, NАМЕ, AGE, REPOFFICE,TITLE,HIREDATE, МANAGER,  QUOTA, SALES)
values
(110,'Tom Snyder',41,NULL,'Sales Rep','20081013',101,NULL,75985.00);																

insert into SALESREPS
(EMPL_NUМ, NАМЕ, AGE, REPOFFICE,TITLE,HIREDATE, МANAGER,  QUOTA, SALES)
values
(108,'Larry Fitch',62,21,'Sales Mgr','20071012',106,350000.00,361865.00);																

insert into SALESREPS
(EMPL_NUМ, NАМЕ, AGE, REPOFFICE,TITLE,HIREDATE, МANAGER,  QUOTA, SALES)
values
(103,'Paul Cruz',29,12,'Sales Rep','20050301',104,275000.00,286775.00);																

insert into SALESREPS
(EMPL_NUМ, NАМЕ, AGE, REPOFFICE,TITLE,HIREDATE, МANAGER,  QUOTA, SALES)
values
(107,'Nancy Angelli',49,22,'Sales Rep','20061114',108,300000.00,186042.00);	


ALTER TABLE SALESREPS
ADD CONSTRAINT SALESREPS_МANAGER_FK
FOREIGN KEY (МANAGER )REFERENCES SALESREPS;

															
																
-- Наполнение таблицы OFFICES
insert into OFFICES(OFFICE,CITY,REGION,MGR,[TARGET],SALES)
values
(22,'Denver','Western',108,300000.00,186042.00);

insert into OFFICES(OFFICE,CITY,REGION,MGR,[TARGET],SALES)
values
(11,'New York','Eastern',106,575000.00,692637.00);

insert into OFFICES(OFFICE,CITY,REGION,MGR,[TARGET],SALES)
values
(12,'Chicago','Eastern',104,800000.00,735042.00);

insert into OFFICES(OFFICE,CITY,REGION,MGR,[TARGET],SALES)
values
(13,'Atlanta','Eastern',105,350000.00,367911.00);

insert into OFFICES(OFFICE,CITY,REGION,MGR,[TARGET],SALES)
values
(21,'Los Angeles','Western',108,725000.00,835915.00);

ALTER TABLE salesreps
ADD CONSTRAINT WORKSIN FOREIGN KEY (REPOFFICE)
REFERENCES OFFICES(OFFICE);					
			
-- Наполнение таблицы CUSTOMERS
insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2111,'JCPInc.',103,50000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2102,'FirstCorp.',101,65000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2103,'AcmeMfg.',105,50000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2123,'Carter&Sons',102,40000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2107,'АсеInternational',110,35000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2115,'SmithsonCorp.',101,20000.00);					

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2101,'JonesMfg.',106,65000.00);	

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2112,'Zetacorp',108,50000.00);				

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2121,'QМАAssoc.',103,45000.00);	

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2114,'OrionCorp.',102,20000.00);	

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2124,'PeterBrothers',107,40000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2108,'Holm&Landis',109,55000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2117,'J.P.Sinclair',106,35000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2122,'Three - WayLines',105,30000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2120,'RicoEnterprises',102,50000.00);
											
insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2106,'FredLewisCorp.',102,65000.00);			

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2119,'SolomonInc.',109,25000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2118,'MidwestSystems',108,60000.00);						

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2113,'Ian&Schmidt',104,20000.00);

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2109,'Chen Associates',103,25000.00);	

insert into CUSTOMERS(CUST_NUМ,COMPANY,CUST_REP,CREDIT_LIMIT)
values(2105,'ААА Investments',101,45000.00);				
										
-- Наполнение таблицы PRODUCTS
insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('REI','2А45С','Ratchet Link',2750.00,210);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('ACI','4100У','Widget Remover',79.00,25);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('QSA','Xk47','Reducer',355.00,38);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('BIC','41672','Plate',180.00,0);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('IММ','779С','900- lb Brace',1875.00,9);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('ACI','41003','Size 3 Widget',107.00,207);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('ACI','41004','Size 4 Widget',117.00,139);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('ВIС','41003','Handle',652.00,3);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('IММ','887Р','Brace Pin',250.00,24);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('QSA','Xk48','Reducer',134.00,203);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('REI','2A44L','Left Hinge',4500.00,12);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('FEA','112','Housing',148.00,115);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('IММ','887Н','Brace Holder',54.00,223);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('BIC','41089','Retainer',225.00,78);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('ACI','41001','Size 1 Widget',55.00,277);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('IММ','775С','500 - lb Brace',1425.00,5);
				
insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('ACI','4100Z','Widget Installer',2500.00,28);
								
insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('QSA','ХК48А','Reducer',177.00,37);				

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('ACI','41002','Size 2 Widget',76.00,167);

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('REI','2A44R','Right Hinge',4500.00,12);					

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('IММ','773С','300 - lb Brace',975.00,28);					
				
insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('ACI','4100Х','Widget Adjuster',25.00,37);				

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('FEA','114','Motor Mount',243.00,15);					

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('IММ','887Х','Brace Retainer',475.00,32);				

insert into PRODUCTS(MFR_ID,PRODUCT_ID,[DESCRIPTION],PRICE,QTY_ON_HAND)
values('REI','2A44G','Hinge Pin',350.00,14);					
				
-- Наполнение таблицы ORDERS
insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112961,'20071217',2117,106,'REI','2A44L',7,31500.00);

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113012,'20080111',2111,105,'ACI','41003',35,3745.00);
			
insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112989,'20080103',2101,106,'FEA','114',6,1458.00);

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113051,'20080210',2118,108,'QSA','Xk47',2,1420.00);
							
insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112968,'20071012',2102,101,'ACI','41004',34,3978.00);							

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113036,'20080130',2107,110,'ACI','4100Z',9,22500.00);								

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113045,'20080202',2112,108,'REI','2A44R',10,45000.00);								

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112963,'20071217',2103,105,'ACI','41004',28,3276.00);														

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113013,'20080114',2118,108,'ВIС','41003',1,652.00);							

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113058,'20080223',2108,108,'FEA','112',10,1480.00);															

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112997,'20080108',2124,107,'ВIС','41003',1,652.00);		

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112983,'20071227',2103,105,'ACI','41004',6,702.00);			

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113024,'20080120',2114,108,'QSA','Xk47',20,7100.00);			

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113062,'20080224',2124,107,'FEA','114',10,2430.00);								

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112979,'20071012',2114,102,'ACI','4100Z',6,15000.00);														

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113027,'20080122',2103,105,'ACI','41002',54,4104.00);								

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113007,'20080108',2112,108,'IММ','773С',3,2925.00);

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113069,'20080302',2109,107,'IММ','775С',22,31350.00);									

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113034,'20080129',2107,110,'REI','2А45С',8,632.00);

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112992,'20071104',2118,108,'ACI','41002',10,760.00);								
							
insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112975,'20071012',2111,103,'REI','2A44G',6,2100.00);

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113055,'20080215',2108,101,'ACI','4100Х',6,150.00);

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113048,'20080210',2120,102,'IММ','779С',2,3750.00);		

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112993,'20070104',2106,102,'REI','2А45С',24,1896.00);															

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113065,'20080227',2106,102,'QSA','Xk47',6,2130.00);			

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113003,'20080125',2108,109,'IММ','779С',3,5625.00);									

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113049,'20080210',2118,108,'QSA','Xk47',2,776.00);								

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(112987,'20071231',2103,105,'ACI','4100У',11,27500.00);						

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113057,'20080218',2111,103,'ACI','4100Х',24,600.00);								

insert into ORDERS(ORDER_NUМ,ORDER_DATE,CUST,REP,MFR,PRODUCT,QTY,AМOUNT)
values(113042,'20080202',2113,101,'REI','2A44R',5,22500.00);									

		
										