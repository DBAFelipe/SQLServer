DECLARE @ProcedureName NVARCHAR(100) = ''  -- Altere aqui
DECLARE @SQL NVARCHAR(MAX) = ''

-- Gera o SQL dinâmico para cada banco de dados
SELECT @SQL += '
IF EXISTS (SELECT 1 FROM [' + name + '].sys.objects 
           WHERE type = ''P'' AND name = ''' + @ProcedureName + ''')
BEGIN
    PRINT ''Encontrado em: [' + name + ']''
END
'
FROM sys.databases
WHERE state_desc = 'ONLINE' 
  AND name NOT IN ('master', 'tempdb', 'model', 'msdb')  -- opcional: excluir bancos do sistema

-- Executa o SQL dinâmico
EXEC sp_executesql @SQL
