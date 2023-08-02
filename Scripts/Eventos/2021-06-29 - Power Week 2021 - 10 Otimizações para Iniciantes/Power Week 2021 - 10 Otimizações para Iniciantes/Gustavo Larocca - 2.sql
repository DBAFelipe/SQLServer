use AdventureWorks2016
GO
SET STATISTICS IO,TIME ON
-- Query com performance ruim
exec sp_executesql N'SELECT soh.SalesOrderID,
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
WHERE CONVERT(VARCHAR(10), sod.ModifiedDate, 101) = ''01/01/2015'''
GO

-- Usa a sp_get_query_template pra gerar a versao parameterizada da query...
DECLARE @vstmt nvarchar(max);
DECLARE @vparams nvarchar(max);
EXEC sp_get_query_template 
N'SELECT soh.SalesOrderID,
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
WHERE CONVERT(VARCHAR(10), sod.ModifiedDate, 101) = ''01/01/2010''',
	@vstmt OUTPUT, @vparams OUTPUT;
	--SELECT @vstmt
/*
select soh . SalesOrderID , OrderDate , DueDate , ShipDate , Status , SubTotal , TaxAmt , Freight , TotalDue from Sales . SalesOrderHeader as soh inner join Sales . SalesOrderDetail as sod on soh . SalesOrderID = sod . 
SalesOrderID where convert ( VARCHAR ( 10 ) , sod . ModifiedDate , 101 ) = @1
*/	
-- Com a versao parameterizada, forca o PARAMETERIZATION FORCED
EXEC sp_create_plan_guide 
	N'TemplateGuide1', 
	@vstmt, 
	N'TEMPLATE', 
	NULL, 
	@vparams, 
	N'OPTION(PARAMETERIZATION FORCED)';

-- criando a nova versao com (HASH JOIN)
EXEC sp_create_plan_guide   
    @name = N'PlanGuide1',  
    @stmt = @vstmt,  
    @type = N'SQL',  
    @module_or_batch = NULL,  
    @params = @vparams, 
    @hints = N'OPTION (HASH JOIN)';  


GO

-- Nice...
exec sp_executesql N'SELECT soh.SalesOrderID,
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
WHERE CONVERT(VARCHAR(10), sod.ModifiedDate, 101) = ''01/01/2010'''
GO


-- E se eu trocar o valor dos parametros?
-- Nao tem problema, o plano vai ser parameterizado, e vai reutilizar o plano...
exec sp_executesql N'SELECT soh.SalesOrderID,
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
WHERE CONVERT(VARCHAR(10), sod.ModifiedDate, 101) = ''01/01/2014'''
GO

-- cleanup
/*
EXEC sp_control_plan_guide N'DROP', N'TemplateGuide1';  
EXEC sp_control_plan_guide N'DROP', N'PlanGuide1';  
*/