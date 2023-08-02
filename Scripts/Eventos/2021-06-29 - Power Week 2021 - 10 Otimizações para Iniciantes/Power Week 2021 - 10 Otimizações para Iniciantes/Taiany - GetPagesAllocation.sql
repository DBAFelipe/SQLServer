create or alter procedure dbo.GetPagesAllocation (@object sysname)
as
begin

	SELECT
		OBJECT_NAME ([sp].[object_id])	AS [Object Name]
	,	[au].[type_desc]				AS [Alloc Unit Type]
	,	[fg].name						as [FileGroup]
	,	[au].total_pages				AS TotalPages
	,	[au].data_pages					AS DataPages
	,	[au].used_pages					as UsedPages
	,	sp.[rows]						AS [Rows]
	FROM
				sys.partitions AS [sp]
	inner join	sys.system_internals_allocation_units [au]
				on  [au].container_id = sp.[partition_id]
	inner join	sys.filegroups [fg]
				on [fg].data_space_id = [au].filegroup_id
	WHERE
		[sp].[object_id] =	(	CASE WHEN (@object IS NULL)
									THEN [sp].[object_id]
									ELSE OBJECT_ID (@object)
								END )

end		
go