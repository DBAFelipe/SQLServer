DECLARE @DatabaseName SYSNAME;
DECLARE @SQL NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE database_id > 4 AND state_desc = 'ONLINE'; -- ignora bases de sistema

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DatabaseName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = '
    DECLARE @stmt NVARCHAR(MAX);

    SELECT @stmt = 
        ''IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'''''' + @DatabaseName + '''''')'' + CHAR(13) +
        ''BEGIN'' + CHAR(13) +
        ''    CREATE DATABASE ['' + @DatabaseName + ''] ON PRIMARY'' + CHAR(13) +
        ''    ( NAME = N'''''' + mf.name + '''''','' +
        '' FILENAME = N'''''' + mf.physical_name + '''''','' +
        '' SIZE = 512MB,'' +
        '' MAXSIZE = '' + 
            CASE 
                WHEN mf.max_size = -1 THEN ''UNLIMITED''
                ELSE CAST(CAST(mf.max_size AS BIGINT) * 8 / 1024 AS VARCHAR) + ''MB''
            END + '','' +
        '' FILEGROWTH = '' + 
            CASE 
                WHEN mf.is_percent_growth = 1 THEN CAST(mf.growth AS VARCHAR) + ''%''
                ELSE CAST(CAST(mf.growth AS BIGINT) * 8 / 1024 AS VARCHAR) + ''MB''
            END + '')'' + CHAR(13) +
        ''    LOG ON'' + CHAR(13) +
        ''    ( NAME = N'''''' + logmf.name + '''''','' +
        '' FILENAME = N'''''' + logmf.physical_name + '''''','' +
        '' SIZE = 512MB,'' +
        '' MAXSIZE = '' + 
            CASE 
                WHEN logmf.max_size = -1 THEN ''UNLIMITED''
                ELSE CAST(CAST(logmf.max_size AS BIGINT) * 8 / 1024 AS VARCHAR) + ''MB''
            END + '','' +
        '' FILEGROWTH = '' + 
            CASE 
                WHEN logmf.is_percent_growth = 1 THEN CAST(logmf.growth AS VARCHAR) + ''%''
                ELSE CAST(CAST(logmf.growth AS BIGINT) * 8 / 1024 AS VARCHAR) + ''MB''
            END + '')'' + CHAR(13) +
        ''END'' 
    FROM sys.master_files mf
    INNER JOIN sys.master_files logmf 
        ON mf.database_id = logmf.database_id AND logmf.type_desc = ''LOG''
    WHERE mf.type_desc = ''ROWS'' AND DB_NAME(mf.database_id) = @DatabaseName;

    PRINT @stmt;
    ';

    EXEC sp_executesql @SQL, N'@DatabaseName SYSNAME', @DatabaseName;

    FETCH NEXT FROM db_cursor INTO @DatabaseName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;
