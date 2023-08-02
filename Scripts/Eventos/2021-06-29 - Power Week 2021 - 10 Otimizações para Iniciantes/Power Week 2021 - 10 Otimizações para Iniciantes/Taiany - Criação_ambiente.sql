
--criando banco de dados
CREATE DATABASE POWER_WEEK
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = NPOWER_WEEK, FILENAME = N'C:\SQL2017_STANDARD\SQLData\POWER_WEEK.mdf' , SIZE = 8192KB , FILEGROWTH = 1000KB )
 LOG ON 
( NAME = NPOWER_WEEK_log, FILENAME = N'C:\SQL2017_STANDARD\SQLLog\POWER_WEEK_log.ldf' , SIZE = 8192KB , FILEGROWTH = 1000KB )
GO


use [POWER_WEEK];
GO
use [master];
GO
USE [master]
GO
ALTER DATABASE POWER_WEEK SET RECOVERY SIMPLE WITH NO_WAIT
GO

use [POWER_WEEK];
--CRIANDO ESTRUTURA DE ALGUM DOS CASOS QUE VAMOS MOSTRAR
CREATE TABLE funcionario (
	funcid INT NOT NULL IDENTITY primary key,
	nome VARCHAR(80) 
	,idade INTEGER ,
	data_entrada_empresa datetime
	)
	go
CREATE TABLE funcionario_apontamento (
	ID INT  NOT NULL IDENTITY primary key,
	funcid INT NOT NULL constraint FK_funcionario_apontamento_funcionario FOREIGN KEY REFERENCES funcionario (funcid),
	dia_semana varchar(10) not null,
	data_apontada date not null,
	horas_apontadas float not null,
	descricao_atividade varchar(80) not null
	)

	set NOCOUNT ON
	go

	/*inserindo dados*/


	set NOCOUNT ON
	INSERT funcionario 
	VALUES ('Gabrielly', 22, '01-04-2021')

	INSERT funcionario 
	VALUES ('Raiane', 22, '01-04-2021')

	INSERT funcionario 
	VALUES ('Taiany', 30, '01-02-2021')

	INSERT funcionario 
	VALUES ('Gustavo', 30, '01-06-2020')

	INSERT funcionario 
	VALUES ('Luiz Lima', 34, '01-06-2016')

	INSERT funcionario 
	VALUES ('Fabiano Amorim', 34, '01-06-2016')
	go 1000
	 
	INSERT funcionario 
	VALUES ('Fabricio Lima', 33, '01-06-2016')
	GO 1000

	INSERT funcionario 
	VALUES ('Wesley', 33, '10-05-2021')

	INSERT funcionario 
	VALUES ('Eduardo', 32, '12-01-2021')

	INSERT funcionario 
	VALUES ('Rodrigo', 34, '10-05-2018')
	GO 1000
	
	INSERT funcionario 
	VALUES ('Bianca', 28, '01-05-2021')

	INSERT funcionario 
	VALUES ('Nayara', 25, '01-03-2020')

	INSERT funcionario 
	VALUES ('Leonardo', 30,  '01-08-2019')

	INSERT funcionario 
	VALUES ('Wilson', 30, '01-05-2019')


	--funcionario_apontamento
set NOCOUNT ON
	DECLARE @counter SMALLINT;  
SET @counter = 1;  
WHILE @counter < 2000  
   BEGIN  
    INSERT funcionario_apontamento
	VALUES (@counter, 'Segunda', '2021-06-02', 8, 'Tuning')

	set @counter = @counter + 1
   END;  
GO  
set NOCOUNT ON
	DECLARE @counter SMALLINT;  
SET @counter = 1;  
WHILE @counter < 100  
   BEGIN  
    INSERT funcionario_apontamento
	VALUES (@counter, 'Segunda', '2021-05-01', 6, 'Conferencia cliente')

	set @counter = @counter + 1
   END;  
GO  


	DECLARE @counter SMALLINT;  
SET @counter = 1;  
WHILE @counter < 1999  
   BEGIN  
    INSERT funcionario_apontamento
	VALUES (@counter, 'Terca', '2021-05-22', 5, 'Analise erro')

	set @counter = @counter + 1
   END;  
GO  
	
	set NOCOUNT ON
	INSERT funcionario_apontamento
	VALUES (4, 'Terca', '2021-06-02', 8, 'Tuning')

	INSERT funcionario_apontamento
	VALUES (6, 'Quarta', '2021-05-02', 8, 'Analise erro')

	INSERT funcionario_apontamento
	VALUES (8, 'Quarta', '2021-05-02', 8, 'Analise erro')

	INSERT funcionario_apontamento
	VALUES (5, 'Quarta', '2021-05-02', 8, 'Analise erro')

	INSERT funcionario_apontamento
	VALUES (2, 'Quarta', '2021-05-02', 8, 'Analise erro')

	
	INSERT funcionario_apontamento
	VALUES (4, 'Quarta', '2021-05-02', 8, 'Analise erro')

	INSERT funcionario_apontamento
	VALUES (1, 'Segunda', '2021-05-02', 8, 'Tuning')

	INSERT funcionario_apontamento
	VALUES (6, 'Segunda', '2021-06-02', 8, 'Tuning')

	INSERT funcionario_apontamento
	VALUES (9, 'Segunda', '2021-06-02', 8, 'Tuning')

	INSERT funcionario_apontamento
	VALUES (8, 'Segunda', '2021-06-02', 8, 'Conferencia cliente')

	INSERT funcionario_apontamento
	VALUES (10, 'Sexta', '2021-06-07', 8, 'Analise problema')

	INSERT funcionario_apontamento
	VALUES (7, 'Segunda', '2021-06-02', 8, 'AG')

	INSERT funcionario_apontamento
	VALUES (2, 'Quarta', '2021-05-02', 8, 'Analise erro')

	INSERT funcionario_apontamento
	VALUES (5, 'Terca', '2017-05-02', 8, 'Analise erro')

	
	INSERT funcionario_apontamento
	VALUES (5, 'Quarta', '2017-05-02', 6, 'Analise erro')

	INSERT funcionario_apontamento
	VALUES (55, 'Quarta', '2021-05-02', 5, 'Analise erro')


	INSERT funcionario_apontamento
	VALUES (3, 'Quarta', '2021-03-02', 8, 'Analise erro')
	
	INSERT funcionario_apontamento
	VALUES (2, 'Quarta', '2021-04-09', 8, 'Analise erro')

	
	INSERT funcionario_apontamento
	VALUES (2, 'Quarta', '2021-05-02', 8, 'Analise erro')

	
	INSERT funcionario_apontamento
	VALUES (2, 'Quarta', '2021-06-02', 8, 'Analise erro')
	
	INSERT funcionario_apontamento
	VALUES (3, 'Quarta', '2021-06-02', 8, 'Tuning')


		INSERT funcionario_apontamento
	VALUES (4, 'Quinta', '2020-12-12', 8, 'Conferencia cliente')


	
		INSERT funcionario_apontamento
	VALUES (9, 'Quinta', '2020-12-21', 8, 'Conferencia cliente')


	
	--	select * from funcionario_apontamento fa inner join funcionario f on f.funcid = fa.funcid
	--where fa.data_apontada < f.data_entrada_empresa


	
USE [POWER_WEEK]

go
	--OBS: Para fazer um Indice FULLTEXT a tabela tem que ter pelo menos uma pk.
CREATE TABLE cliente_pwt
	(
	id_cliente int NOT NULL IDENTITY CONSTRAINT PK_cliente_pwt primary key ,
	nome VARCHAR(100) not null,
	tipo_contrato VARCHAR(30) not null
	
	)


	go
	--DROP TABLE cliente_pwt
/* inserção de dados- DEMORA 5 MINUTOS*/
set NOCOUNT ON
INSERT cliente_pwt
VALUES ('GOOGLE', 'CLIENTE MENSAL')

INSERT cliente_pwt
VALUES ('AMAZON', 'CLIENTE MENSAL')

INSERT cliente_pwt
VALUES ('MICROSOFT', 'CLIENTE PONTUAL')

INSERT cliente_pwt
VALUES ('APPLE', 'CLIENTE PONTUAL')

INSERT cliente_pwt
VALUES ('FACEBOOK', 'CLIENTE PONTUAL')

INSERT cliente_pwt
VALUES ('GRUPO XYZ', 'CLIENTE PONTUAL')

INSERT cliente_pwt
VALUES ('GRUPO PIADAS DO RODRIGO', 'CLIENTE PONTUAL')
GO 4000

INSERT into cliente_pwt (nome, tipo_contrato)
SELECT 'GRUPO TESTE FULLTEXT', 'CLIENTE PONTUAL'
GO 500000 --500.000

insert into cliente_pwt (nome, tipo_contrato)
values ('DBAs','CLIENTE MENSAL'),
('Devs','CLIENTE PONTUAL'),
('Analistas','CLIENTE MENSAL'),
('Power Week','CLIENTE MENSAL'),
('ZapZap','Não tem')
GO 100000


TRUNCATE TABLE cliente_pwt
 

insert into cliente_pwt (nome, tipo_contrato)
values ('DBAs','CLIENTE MENSAL'),
('Devs','CLIENTE PONTUAL'),
('Analistas','CLIENTE MENSAL'),
('Power Week','CLIENTE MENSAL'),
('ZapZap','Não tem'),
('MICROSOFT','Não tem')
GO 100000
 
 
insert into cliente_pwt (nome, tipo_contrato)
values ('PESSOAS DO GRUPO PIADAS DO RODRIGO','CLIENTE MENSAL')
 GO 20

 

insert into cliente_pwt (nome, tipo_contrato)
values ('DBAs','CLIENTE MENSAL'),
('Devs','CLIENTE PONTUAL'),
('Analistas','CLIENTE MENSAL'),
('Power Week','CLIENTE MENSAL'),
('ZapZap','Não tem'),
('MICROSOFT','Não tem')
GO 100000


--rodando cliente pwt
go
create  nonclustered index SK01_cliente_pwt on cliente_pwt (NOME)
go
--DROP TABLE table_base
--DROP TABLE table_truncate
--DROP TABLE table_delete
create table table_truncate (ID INt, Texto varchar(1000), data datetime)


go

set NOCOUNT ON
DECLARE @I INT
SET @I = 1


  INSERT table_truncate(ID, Texto, data)
  SELECT @I,
        REPLICATE('CURSOS POWER TUNING', 20),
         GETDATE()
	GO 500000


	select * 
	into table_delete
	from table_truncate
	
	select * 
	into table_base
	from table_truncate
	

	
	
	--DROP TABLE cliente_pwt


	go
	
IF OBJECT_ID('dbo.TabelaVARMAX', 'U') IS NOT NULL
	 DROP TABLE dbo.TabelaVARMAX
GO

CREATE TABLE dbo.TabelaVARMAX (
	ID INT IDENTITY NOT NULL CONSTRAINT PK_TabelaVARMAX PRIMARY KEY
	, Nome VARCHAR(100) NOT NULL DEFAULT NEWID()
	, DataRegistro DATETIME2 NOT NULL DEFAULT(SYSDATETIME())
	, Texto VARCHAR(MAX) NOT NULL  -- Preencher tabela com 4000 caracteres...
)


insert dbo.TabelaVARMAX
select top 100000
			 c.type_desc, convert(date, c.create_date), a.definition
from 
			sys.all_sql_modules a
cross join	sys.all_objects c