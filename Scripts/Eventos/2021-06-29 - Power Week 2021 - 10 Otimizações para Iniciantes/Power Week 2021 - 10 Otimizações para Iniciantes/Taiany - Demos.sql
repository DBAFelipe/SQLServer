--select log_reuse_wait_desc, * from sys.databases
/*
OS CASOS AQUI APRESENTADOS S�O TODOS 
QUE OCORRERAM NO NOSSO DIA A DIA NA POWER


DEMO 1
TRUNCATE

	� RESETA O IDENTITY DA TABELA 
	� N�o sobrecarrega os logs e n�o enche o disco onde fica o arquivo Log. Perigo de estourar.
	� N�o aceita WHERE
	� A tabela n�o pode ter relacionamentos
	� As instru��es DELETE TABLE excluem linhas uma de cada vez, 
	registrando cada linha no log de transa��es, 
	bem como mantendo as informa��es do n�mero de sequ�ncia do log (LSN).
*/


USE [POWER_WEEK]
--select COUNT(*) from table_delete

checkpoint --neste caso, limpa e confirma  as altera��es realizadas em mem�ria sejam definitivamente armazenadas no arquivo de dados
select * from sys.fn_dblog(null, null)  --Log esta limpo


delete from table_delete
/* +/- 670 mil linhas geradas */
select * from sys.fn_dblog(null, null) 
-- olhar o que esta logando no arquivo de log 
	
checkpoint  -- TIPO DE RECOVERY MODEL SIMPLE
select * from sys.fn_dblog(null, null) --n�o tem mais nenhuma informa��o logada

	--select count(*)from table_truncate
truncate TABLE table_truncate
/* +/-  10.000 linhas geradas, altera as paginas de controle (IAM, PFS, GAM) */
select * from sys.fn_dblog(null, null)  
/*
Campo Operation = Tipo de registro de log
Descrevendo algumas opera�oes da sys.fn_dblog

OPERATION	                 DESCRIPTION
LOP_ABORT_XACT  	         Indicates that a transaction was aborted and rolled back.
LOP_BEGIN_CKPT 	             A checkpoint has begun.
LOP_BEGIN_XACT 	             Indicates the start of a transaction.
LOP_BUF_WRITE	             Writing to Buffer.
LOP_COMMIT_XACT	             Indicates that a transaction has committed.
LOP_CREATE_ALLOCCHAIN	     New Allocation chain
LOP_CREATE_INDEX	         Creating an index.
LOP_DELETE_ROWS	             Rows were deleted from a table.
LOP_DELETE_SPLIT 	         A page split has occurred. Rows have moved physically.
LOP_DELTA_SYSIND  	         SYSINDEXES table has been modified.
LOP_DROP_INDEX	             Dropping an index.
LOP_END_CKPT	             Checkpoint has finished.
LOP_EXPUNGE_ROWS	         Row physically expunged from a page, now free for new rows.
LOP_FILE_HDR_MODIF  	     SQL Server has grown a database file.
LOP_FORGET_XACT	             Shows that a 2-phase commit transaction was rolled back.
LOP_FORMAT_PAGE  	         Write a header of a newly allocated database page.
LOP_IDENT_NEWVAL	         Identity�s New reseed values
LOP_INSERT_ROWS  	         Insert a row into a user or system table.
LOP_MARK_DDL	             Data Definition Language change � table schema was modified.
LOP_MARK_SAVEPOINT	         Designate that an application has issued a �SAVE TRANSACTION� command.
LOP_MODIFY_COLUMNS   	     Designates that a row was modified as the result of an Update command.
LOP_MODIFY_HEADER  	         A new data page created and has initialized the header of that page.
LOP_MODIFY_ROW  	         Row modification as a result of an Update command.
LOP_PREP_XACT	             Transaction is in a 2-phase commit protocol.
LOP_SET_BITS	             Designates that the DBMS modified space allocation bits as the result of allocating a new extent.
LOP_SET_FREE_SPACE  	     Designates that a previously allocated extent has been returned to the free pool.
LOP_SORT_BEGIN 	             A sort begins with index creation. � SORT_END end of the sorting while creating an index.
LOP_SORT_EXTENT	             Sorting extents as part of building an index.
LOP_UNDO_DELETE_SPLIT	     The page split process has been dumped.
LOP_XACT_CKPT	             During the Checkpoint, open transactions were detected.
*/


GO


-----CASO 2: FULLTEXT

/*


O que � o FULLTEXT?
Um �ndice de texto completo armazena informa��es sobre PALAVRAS 
importantes e sua localiza��o em uma ou mais colunas 
de uma tabela de banco de dados, em FORMA de CATALOGOS
  
P�S: *Rapidez consultas quando tem toda a palavra.
	 * F�cil implementa��o
	

CONTRA: quando n�o temos a palavra inteira na busca n�o funciona

Existe um mundo de op��es para pesquisa fultext,
vamos falar aqui de um caso que aconteceu na PWT 
que usamos uma das formas que esse conceito da para ser implementado
*/


--ver se o banco esta habilitado fulltext
select is_fulltext_enabled, * from sys.databases where database_id = 5
SELECT DATABASEPROPERTYEX('POWER_WEEK', 'isFulltextEnabled')


--Para habilitar basta rodar o exec sem impacto. 
--Recomenda-se fazer um teste em QA.
EXEC sp_fulltext_database 'enable'


--Mostrar como criar Fulltext na interface > Botao direito em cima da tabela >Full-Text Index
--ou POWER_WEEK > Storage > Full Text Catalogs


SET STATISTICS IO, TIME ON
--SELECT COM LIKE
SELECT * FROM cliente_pwt  WHERE NOME LIKE '%GRUPO%'
SELECT * FROM cliente_pwt  WHERE NOME LIKE '%UPO%'


CREATE FULLTEXT CATALOG pwt_fullteste WITH ACCENT_SENSITIVITY=OFF;
/* Criar indice fulltext. � premissa a tabela ter uma PK*/
CREATE FULLTEXT INDEX ON  dbo.cliente_pwt (nome)
KEY INDEX PK_cliente_pwt
 ON pwt_fullteste WITH CHANGE_TRACKING AUTO

 --O indice fulltext cria um Catalogo no SQL Server.
  select * from  sys.fulltext_catalogs

 SELECT * FROM dbo.cliente_pwt where FREETEXT(nome, '*GRUPO*') 
 SELECT * FROM dbo.cliente_pwt where contains(nome, '*GRUPO*') 


--Dica 14, 15, 16: Fabiano Amorim - 25 Dicas de Performance no SQL Server | Parte 1
 --nao funciona, PARTE da palavra
  SELECT * FROM dbo.cliente_pwt where FREETEXT(nome, '*UPO*') 

 
--Campo do tipo LOB 

/* 

Casos que ocorreram na PWT: 
1 - n�o estavamos conseguindo fazer shrink cliente que tinha campo na tabela VARCHAR(MAX) 
2 - Casos lobs que tivemos que alterar tipo campos

 Ativa a op��o de armazenamento de dados LOB fora das p�ginas de dados 
(Dica n�mero 24 Curso Fabiano Amorim: Fabiano Amorin - 25 Dicas de Performance no SQL Server | Parte 1 
*/
--campos lob, s�o campos que ultrapssam o valor tamanho de uma pagina (8K)


--Quais os tipos campos Lob?Varchar(max), nvarchar(max), varbinary(max) e XML
--Quais os tipos campos Blob?Text, Ntext e Image


SELECT COUNT(*) FROM TabelaVARMAX
GO

-- E o que isso pode nos ajudar ou atrapalhar no ponto de vista de PERFOMANCE?

/* 

Cada parti��o de uma tabela � alocada em um tipo 
de Allocation Unit, que pode ser IN_ROW_DATA, 
ROW_OVERFLOW_DATA ou LOB_DATA. 

TabelaVARMAX	IN_ROW_DATA	PRIMARY	26401	 26279	26378	100000
TabelaVARMAX	ROW_OVERFLOW_DATA	PRIMARY	0	0	0	100000
TabelaVARMAX	LOB_DATA	PRIMARY	25785	0	25780	100000
*/


-- Verifica aloca��o dos dados nas tabelas
exec dbo.GetPagesAllocation @object = 'TabelaVARMAX'


SET STATISTICS IO,TIME ON
--porque tem tando logical reads?os dados do tipo lobs (maiores que 8k) ocupam muito espa�o, ent�o se em uma p�gina tivermos esses dados misturados, a gente realiza muita leitura desnecess�ria, exemplo:
select nome, DataRegistro from TabelaVARMAX

(100000 rows affected)
Table 'TabelaVARMAX'. Scan count 1, logical reads 26393, physical reads 0, read-ahead reads 10448, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
SQL Server parse and compile time: 
   CPU time = 125 ms, elapsed time = 134 ms.


--sp_tableoption : separar LOB_DATA e IN_ROW_DATA
EXEC sp_tableoption 'TabelaVARMAX', 'large value types out of row', 1




GO

/*
Ao alterar o modo de armazenamento 
da tabela TabelaVARMAX o SQL SERVER 
vai considerar apenas as novas opera��es. 
O que j� est� armazenado continua do mesmo jeito. 
Qual a solu��o ent�o? For�ar uma opera��o em todas as 
linhas sem alterar o conte�do. Ap�s isso, 
vamos rodar um Rebuild e consultar como ficou a distribui��o das p�ginas de dados na tabela.


*/

update TabelaVARMAX set Texto = Texto
-- Realiza o REBUILD pra eliminar eventual fragmenta��o (verificar janela em ambiente producao)
alter index all on TabelaVARMAX rebuild 

-- Por fim, verifica aloca��o dos dados com novo modelo de armazenamento
exec dbo.GetPagesAllocation @object = 'TabelaVARMAX'

select nome, DataRegistro from TabelaVARMAX

--VER DIFEREN�A READS
(100000 rows affected)
Table 'TabelaVARMAX'. Scan count 1, logical reads 783, physical reads 0, read-ahead reads 457, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 62 ms,  elapsed time = 555 ms.


----CASO 4
/*
NON-SARGABLE  - SEARCH ARGUMENT ABLE
o SARG (�S� search argument) e Non-SARGable,
cuja tradu��o livre pode ser �argumento de busca�.

O termo SARG nada mais 
� que a coluna que voc� est� utilizando como 
�predicate� na cl�usula WHERE se ela pode ser 
utilizada em uma opera��o de �Index Seek�.

J� quando o nosso �predicate� n�o permite 
a opera��o de �Index Seek�, 
podemos dizer que estamos utilizando um 
�predicate Non-Sargable� e consequentemente 
teremos um custo maior para execu��o da query.
*/
create nonclustered index IX_funcionario_apontamento ON funcionario (data_entrada_empresa) INCLUDE (nome,idade)

SET STATISTICS IO,TIME ON
SELECT nome
       ,idade
FROM funcionario(NOLOCK) f
WHERE  datediff(MINUTE, f.data_entrada_empresa, GETDATE()) > 1

(8004 rows affected)
Table 'funcionario'. Scan count 1, logical reads 45, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 91 ms.

--SEARCH ARGUMENT ABLE
SELECT nome
       ,idade
FROM funcionario(NOLOCK) f
WHERE f.data_entrada_empresa < dateadd(MINUTE, - 1, GETDATE())

(8004 rows affected)
Table 'funcionario'. Scan count 1, logical reads 37, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 71 ms.


/*
PERGUNTAS

1 - � possivel criar um �ndice em uma COLUNA do tipo VARCHAR(MAX) no INCLUDE?


VERDADEIRO ou FALSO

 

R: VERDADEIRO


---------------------------------------------------------------------------------------------------- 


2 - Quais s�o os TIPOS DE DADOS LOB?

A) TEXT, IMAGE  
B) BIGINT e DATETIMEOFFSITE2  
C) VARCHAR(MAX), NVARCHAR(MAX), VARBINARY(MAX) e XML 
D) Nunca ouvi falar

 

R: C

 
obs:
N�o conseguimos criar INDICE em colunas VARCHAR(MAX), acontece o erro abaixo:
Msg 1919, Level 16, State 1, Line 20
A coluna 'Texto' da tabela 'TabelaVARMAX' � do tipo inv�lido para uso como coluna de chaves em um �ndice.

*/