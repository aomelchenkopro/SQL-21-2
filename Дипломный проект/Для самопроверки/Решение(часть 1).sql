CREATE TABLE PRODUCTS
(
MFR_ID        CHAR(3)      NOT NULL, -- Идентификатор производителя
PRODUCT_ID    CHAR(5)      NOT NULL, -- Идентификатор товара
[DESCRIPTION] VARCHAR(20)  NOT NULL, -- Описание товара
PRICE         DECIMAL(9,2) NOT NULL, -- Цена товара
QTY_ON_HAND   INT          NOT NULL, -- Количество на складе
/*
Составной первичный ключ
(Идентификатор производителя,Идентификатор товара)*/
PRIMARY KEY ( MFR_ID , PRODUCT_ID )
) ;

CREATE TABLE OFFICES
(
OFFICE   INT           NOT NULL,                   -- Идентификатор офиса
CITY     VARCHAR (15)  NOT NULL,                   -- Город в котором находится офис
REGION   VARCHAR (10)  NOT NULL DEFAULT 'Eastern', -- Регион в котором находится офис
MGR      INT           DEFAULT 106,                -- Идентификатор управляющего офисом
[TARGET] DEC(9,2)      CHECK ([TARGET] >= 0.00) ,  -- Плановые продажи
SALES    DEC(9,2)      NOT NULL DEFAULT 0.00,      -- Продажи офиса
PRIMARY KEY(OFFICE), -- Первичный ключ (идентификатор офиса)
UNIQUE (CITY)        -- Ограничение город должен быть уникальным
) ;

CREATE TABLE SALESREPS
(
EMPL_NUМ  INT           NOT NULL CHECK (EMPL_NUМ BETWEEN 101 AND 199), -- идент. служащего
NАМЕ      VARCHAR (15)  NOT NULL,                                      -- Имя служащего
AGE       INT           CHECK (AGE >= 21) ,                            -- Возраст служащего
REPOFFICE INT,                                                         -- Офис в котором работает служащий
TITLE     VARCHAR(10),                                                 -- Должность служащего
HIREDATE  DATE          NOT NULL,                                      -- Дата приема на работу
МANAGER   INT,                                                         -- Идентификатор менеджера данного служащего
QUOTA     DEC(9,2)      CHECK (QUOTA >= 0.0), -- Личный план
SALES     DEC(9,2)      NOT NULL, -- Фактические продажи служащего
PRIMARY KEY (EMPL_NUМ) ,          -- Первичный ключ (Идентификатор служащего)
/*
Внешний ключ (Офис в котором работает служащий)
ссылается на таблицу офисы (Идентификатор офиса)*/
CONSTRAINT WORKSIN FOREIGN KEY (REPOFFICE)
REFERENCES OFFICES(OFFICE)
) ;

ALTER TABLE SALESREPS
ADD CONSTRAINT SALESREPS_МANAGER_FK
FOREIGN KEY (МANAGER )REFERENCES SALESREPS;

ALTER TABLE OFFICES
ADD CONSTRAINT OFFICES_НASMGR_FK
FOREIGN KEY (MGR)REFERENCES SALESREPS;

CREATE TABLE CUSTOMERS
(
CUST_NUМ     INT          NOT NULL , -- Идентификатор клиента
COMPANY      VARCHAR (20) NOT NULL , -- Наименование клиента
CUST_REP     INT ,                   -- Закрепленный служащий
CREDIT_LIMIT DECIMAL(9,2) ,          -- Лимит кредита
PRIMARY KEY (CUST_NUМ) ,             -- Первичный ключ(Идентификатор клиента)
/*
Внешний ключ (Закрепленный служащий)
ссылается на таблицу служащие(Идентификатор служащего)*/
FOREIGN KEY (CUST_REP) REFERENCES SALESREPS
) ;

CREATE TABLE ORDERS
(
ORDER_NUМ  INT      NOT NULL, -- Идентификатор заказа
ORDER_DATE DATE     NOT NULL, -- Дата заказа
CUST       INT      NOT NULL, -- Идентификатор клиента
REP        INT,               -- Идентификатор служащего
MFR        CHAR(3)  NOT NULL, -- Идентификатор производителя товара
PRODUCT    CHAR(5)  NOT NULL, -- Идентификатор товара
QTY        INT      NOT NULL, -- Количество товара
AМOUNT     DEC(9,2) NOT NULL, -- Сумма заказа
PRIMARY KEY (ORDER_NUМ) , -- Первичный ключ идентификатор заказа
-- Внешний ключ (Идентификатор клиента) ссылается на таблицу клиенты
FOREIGN KEY (CUST)REFERENCES CUSTOMERS ,
-- Внешний ключ (Идентификатор служащего) ссылается на таблицу служащие
FOREIGN KEY (REP)REFERENCES SALESREPS ,
-- Внешний ключ (Идентификатор производителя товара, Идентификатор товара)
FOREIGN KEY (MFR , PRODUCT ) REFERENCES PRODUCTS
) ;


										