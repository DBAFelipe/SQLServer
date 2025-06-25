DECLARE @DatabaseName NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)

-- Tabela temporária para armazenar resultados
IF OBJECT_ID('tempdb..#TriggerCheck') IS NOT NULL DROP TABLE #TriggerCheck
CREATE TABLE #TriggerCheck (
    DatabaseName NVARCHAR(128),
    TriggerName NVARCHAR(128)
)

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE'
  AND name NOT IN ('master', 'tempdb', 'model', 'msdb')

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @DatabaseName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = '
    USE ' + QUOTENAME(@DatabaseName) + ';
    IF EXISTS (
        SELECT 1
        FROM sys.triggers
        WHERE name = N''TR_DDL_DB_repl''
          AND parent_class_desc = ''DATABASE''
    )
    BEGIN
        INSERT INTO tempdb..#TriggerCheck (DatabaseName, TriggerName)
        VALUES (N''' + @DatabaseName + ''', N''TR_DDL_DB_repl'')
    END
    '

    EXEC (@SQL)
    FETCH NEXT FROM db_cursor INTO @DatabaseName
END

CLOSE db_cursor
DEALLOCATE db_cursor

-- Exibir resultado
SELECT * FROM #TriggerCheck
