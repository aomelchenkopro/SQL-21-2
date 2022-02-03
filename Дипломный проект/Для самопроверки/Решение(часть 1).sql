CREATE TABLE PRODUCTS
(
MFR_ID        CHAR(3)      NOT NULL, -- ������������� �������������
PRODUCT_ID    CHAR(5)      NOT NULL, -- ������������� ������
[DESCRIPTION] VARCHAR(20)  NOT NULL, -- �������� ������
PRICE         DECIMAL(9,2) NOT NULL, -- ���� ������
QTY_ON_HAND   INT          NOT NULL, -- ���������� �� ������
/*
��������� ��������� ����
(������������� �������������,������������� ������)*/
PRIMARY KEY ( MFR_ID , PRODUCT_ID )
) ;

CREATE TABLE OFFICES
(
OFFICE   INT           NOT NULL,                   -- ������������� �����
CITY     VARCHAR (15)  NOT NULL,                   -- ����� � ������� ��������� ����
REGION   VARCHAR (10)  NOT NULL DEFAULT 'Eastern', -- ������ � ������� ��������� ����
MGR      INT           DEFAULT 106,                -- ������������� ������������ ������
[TARGET] DEC(9,2)      CHECK ([TARGET] >= 0.00) ,  -- �������� �������
SALES    DEC(9,2)      NOT NULL DEFAULT 0.00,      -- ������� �����
PRIMARY KEY(OFFICE), -- ��������� ���� (������������� �����)
UNIQUE (CITY)        -- ����������� ����� ������ ���� ����������
) ;

CREATE TABLE SALESREPS
(
EMPL_NU�  INT           NOT NULL CHECK (EMPL_NU� BETWEEN 101 AND 199), -- �����. ���������
N���      VARCHAR (15)  NOT NULL,                                      -- ��� ���������
AGE       INT           CHECK (AGE >= 21) ,                            -- ������� ���������
REPOFFICE INT,                                                         -- ���� � ������� �������� ��������
TITLE     VARCHAR(10),                                                 -- ��������� ���������
HIREDATE  DATE          NOT NULL,                                      -- ���� ������ �� ������
�ANAGER   INT,                                                         -- ������������� ��������� ������� ���������
QUOTA     DEC(9,2)      CHECK (QUOTA >= 0.0), -- ������ ����
SALES     DEC(9,2)      NOT NULL, -- ����������� ������� ���������
PRIMARY KEY (EMPL_NU�) ,          -- ��������� ���� (������������� ���������)
/*
������� ���� (���� � ������� �������� ��������)
��������� �� ������� ����� (������������� �����)*/
CONSTRAINT WORKSIN FOREIGN KEY (REPOFFICE)
REFERENCES OFFICES(OFFICE)
) ;

ALTER TABLE SALESREPS
ADD CONSTRAINT SALESREPS_�ANAGER_FK
FOREIGN KEY (�ANAGER )REFERENCES SALESREPS;

ALTER TABLE OFFICES
ADD CONSTRAINT OFFICES_�ASMGR_FK
FOREIGN KEY (MGR)REFERENCES SALESREPS;

CREATE TABLE CUSTOMERS
(
CUST_NU�     INT          NOT NULL , -- ������������� �������
COMPANY      VARCHAR (20) NOT NULL , -- ������������ �������
CUST_REP     INT ,                   -- ������������ ��������
CREDIT_LIMIT DECIMAL(9,2) ,          -- ����� �������
PRIMARY KEY (CUST_NU�) ,             -- ��������� ����(������������� �������)
/*
������� ���� (������������ ��������)
��������� �� ������� ��������(������������� ���������)*/
FOREIGN KEY (CUST_REP) REFERENCES SALESREPS
) ;

CREATE TABLE ORDERS
(
ORDER_NU�  INT      NOT NULL, -- ������������� ������
ORDER_DATE DATE     NOT NULL, -- ���� ������
CUST       INT      NOT NULL, -- ������������� �������
REP        INT,               -- ������������� ���������
MFR        CHAR(3)  NOT NULL, -- ������������� ������������� ������
PRODUCT    CHAR(5)  NOT NULL, -- ������������� ������
QTY        INT      NOT NULL, -- ���������� ������
A�OUNT     DEC(9,2) NOT NULL, -- ����� ������
PRIMARY KEY (ORDER_NU�) , -- ��������� ���� ������������� ������
-- ������� ���� (������������� �������) ��������� �� ������� �������
FOREIGN KEY (CUST)REFERENCES CUSTOMERS ,
-- ������� ���� (������������� ���������) ��������� �� ������� ��������
FOREIGN KEY (REP)REFERENCES SALESREPS ,
-- ������� ���� (������������� ������������� ������, ������������� ������)
FOREIGN KEY (MFR , PRODUCT ) REFERENCES PRODUCTS
) ;


										