USE AdventureWorks2016
GO
SET STATISTICS TIME,IO ON
GO

-- SCRIPTS - POWER WEEK 
-- APRESENTAÇÃO : GUSTAVO LAROCCA

--DEMO 1 - NON-SARGABLE vs SARGABLE (Search Argument Able)
IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'SK01_SOD_MODFIEDDATE')
BEGIN
DROP INDEX [SK01_SOD_MODFIEDDATE] ON [SALES].[SALESORDERDETAIL]
END
ELSE	
BEGIN	
CREATE NONCLUSTERED INDEX [SK01_SOD_MODFIEDDATE]
ON [SALES].[SALESORDERDETAIL] ([MODIFIEDDATE])
INCLUDE ([SALESORDERID])
END
GO
--habilitando SET STATISTICS IO,TIME

SELECT soh.SalesOrderID,
OrderDate ,
DueDate ,
ShipDate,
Status ,
SubTotal ,
TaxAmt , 
Freight ,
TotalDue 
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail as sod
ON soh.SalesOrderID = sod.SalesOrderID
WHERE CONVERT(VARCHAR(10), sod.ModifiedDate, 101) = '01/01/2010'


--SELECT TOP 1 CONVERT(VARCHAR(10), sod.ModifiedDate, 101) FROM Sales.SalesOrderDetail sod

--Consultando a tipagem dos campos
--sp_help 'Sales.SalesOrderDetail'

GO

--RESOLUÇÃO

SELECT soh.SalesOrderID,
OrderDate ,
DueDate ,
ShipDate,
Status ,
SubTotal ,
TaxAmt , 
Freight ,
TotalDue 
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail as sod
ON soh.SalesOrderID = sod.SalesOrderID
WHERE sod.ModifiedDate >= '2010/01/01' AND sod.ModifiedDate < '2010/01/02'

GO

-- ou Between 

SELECT soh.SalesOrderID,
OrderDate ,
DueDate ,
ShipDate,
Status ,
SubTotal ,
TaxAmt , 
Freight ,
TotalDue 
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail as sod
ON soh.SalesOrderID = sod.SalesOrderID
WHERE sod.ModifiedDate BETWEEN '2010/01/01 00:00:00' AND '2010/01/01 23:59:59'

-- se eu usar no campo que é datetime um valor date, vai gerar conversão implicita?
-- sim ou não?

DECLARE @vardate DATE
SET @vardate = '20100101'
SELECT soh.SalesOrderID,
OrderDate ,
DueDate ,
ShipDate,
Status ,
SubTotal ,
TaxAmt , 
Freight ,
TotalDue 
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail as sod
ON soh.SalesOrderID = sod.SalesOrderID
WHERE soh.ModifiedDate >= @vardate

--https://docs.microsoft.com/pt-br/sql/t-sql/data-types/data-type-conversion-database-engine?view=sql-server-ver15

--Tudo começa na modelagem!!!
--Porque da utilização do tipo de dados certo???

-- ID, qual expectativa? TinyInt, Int, BigINT 
-- Coluna : ATIVO, Inativo ? BIT ou VARCHAR?
-- USAR VARCHAR() OU CHAR()?

--Uso de Foreign Keys, não usar enumerador(lista de valores)!!
--status (Emitido, Cancelado, Em Faturamento)

-- Ao invés de criar uma tabela com um status para diferenciar, coloca isso fixo no código..

--NFE|
--Codigo | Cliente | STATUS         
--1        'José'    'Emitido'
--2        'João'    'Cancelado'
--3        'Maria'   'Em Faturamento'

--Ao invés de ter uma tabela para

-- DEMO 2 -
-- CONVERSAO IMPLICITA

SELECT p.FirstName,
       p.LastName,
       c.AccountNumber
FROM Sales.Customer AS c
    INNER JOIN Person.Person AS p
        ON c.PersonID = p.BusinessEntityID
WHERE AccountNumber = N'AW00029594';
--GO 40

--Consultando a tipagem dos campos
--sp_help 'Sales.Customer'

GO
--SEM CONVERSÃO IMPLICITA
GO

SELECT p.FirstName,
       p.LastName,
       c.AccountNumber
FROM Sales.Customer AS c
    INNER JOIN Person.Person AS p
        ON c.PersonID = p.BusinessEntityID
WHERE AccountNumber = 'AW00029594';

