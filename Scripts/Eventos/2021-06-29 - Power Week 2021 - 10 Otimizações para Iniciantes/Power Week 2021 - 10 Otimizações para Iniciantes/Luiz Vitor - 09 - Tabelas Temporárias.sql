USE Traces

--	EXEMPLO TEMPDB x PERFORMANCE
--	Pode ajudar na performance (Tuning) quando precisamos acessar o mesmo dado várias vezes.

--	CRIA A TABELA CLIENTE
DROP TABLE IF EXISTS Cliente

CREATE TABLE Cliente (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL,
	CONSTRAINT PK_Cliente PRIMARY KEY(Id_Cliente)
)

INSERT INTO Cliente
VALUES('Tay Linda','20000115',1)

INSERT INTO Cliente
VALUES('Nane fiu fiu','20000115',1)

INSERT INTO Cliente
VALUES('Gugu gostoso','19800824',1)

INSERT INTO Cliente
VALUES('Luiz lindão','19890810',1)

SELECT Nm_Cliente, Dt_Nascimento
FROM Cliente

--	CRIA UM INDICE PARA AJUDAR NA PERFORMANCE
CREATE NONCLUSTERED INDEX SK01_Dt_Nascimento
ON Cliente(Dt_Nascimento)
WITH(DATA_COMPRESSION = PAGE, ONLINE = ON)

--	ACESSANDO A TABELA PRINCIPAL VÁRIAS VEZES
SELECT *
FROM [Cliente]
WHERE Dt_Nascimento >= '19850101'

...

SELECT *
FROM [Cliente]
WHERE Dt_Nascimento >= '19850101'

...

SELECT *
FROM [Cliente]
WHERE Dt_Nascimento >= '19850101'

--	FAZER O SELECT SOMENTE UMA VEZ E GUARDAR EM UMA TABELA TEMPORÁRIA
DROP TABLE IF EXISTS #TEMP_Cliente

SELECT Id_Cliente
INTO #TEMP_Cliente
FROM [Cliente]
WHERE Dt_Nascimento >= '19850101'

-- SELECT * FROM #TEMP_Cliente
	
DROP TABLE IF EXISTS #TEMP_Resultado

SELECT C.* 
INTO #TEMP_Resultado
FROM [Cliente] C
JOIN #TEMP_Cliente T ON C.Id_Cliente = T.Id_Cliente

--	SE PRECISAR FAZER O SELECT VARIAS VEZES, UTILIZAR A TABELA ABAIX0
SELECT * FROM #TEMP_Resultado


---------------------------------------------------------------------------------------------------------------
--	DESAFIO 1 - VARIÁVEIS:
---------------------------------------------------------------------------------------------------------------
DECLARE @MySalary INT = 100000;

BEGIN TRAN
	SET @MySalary = @MySalary * 2;
ROLLBACK;

-- RESULTADO
SELECT @MySalary

---------------------------------------------------------------------------------------------------------------
--	DESAFIO 2 - TABELAS VARIÁVEIS:
---------------------------------------------------------------------------------------------------------------
DECLARE @People TABLE (Name VARCHAR(50));

BEGIN TRAN
	INSERT INTO @People VALUES ('Bill Gates');
	INSERT INTO @People VALUES ('Melinda Gates');
	INSERT INTO @People VALUES ('Satya Nadella');

ROLLBACK

-- RESULTADO
SELECT * FROM @People;

---------------------------------------------------------------------------------------------------------------
--	DESAFIO 3 - TABELAS TEMPORÁRIAS LOCAIS:
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #People

CREATE TABLE #People (
	Name VARCHAR(50)
);

BEGIN TRAN
	INSERT INTO #People VALUES ('Bill Gates');
	INSERT INTO #People VALUES ('Melinda Gates');
	INSERT INTO #People VALUES ('Satya Nadella');

ROLLBACK

-- RESULTADO
SELECT * FROM #People;

DROP TABLE IF EXISTS #People