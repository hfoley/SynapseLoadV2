/*
This script is to create the metadata tables.  
There are some example insert statements.  Edit these based
on your tables, containers, files, tables, etc. 
*/
CREATE SCHEMA [ADF]
GO


CREATE TABLE [ADF].[ExtractTables](
	[DBName] [varchar](100) NULL,
	[TargetTableSchema] [varchar](10) NULL,
	[TableName] [varchar](100) NULL,
	[DateColumn] [varchar](100) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[NotDateColumn] [varchar](100) NULL,
	[TargetContainer] [varchar](20) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
GO

/* Update based with information on SQL tables
you want to extract from to parquet files
*/ 

INSERT INTO [ADF].[ExtractTables]
           ([DBName]
           ,[TargetTableSchema]
           ,[TableName]
           ,[DateColumn]
           ,[StartDate]
           ,[EndDate]
           ,[NotDateColumn]
           ,[TargetContainer]
           ,[IsActive])
     VALUES
           ('<DB name of source SQL table>'
           ,'<schema name of source SQL table>'
           ,'<table name of source SQL table>'
           ,'<Column name for date based extracts>'
           ,'<beginning date for date based extract>'
           ,'<end date for date based extract>'
           ,'<Column name for not date based extracts/where clause>'
           ,'<Target container to land file in ADLS>'
           ,'1 for active to extract, 0 to not extract')
GO


select * from [ADF].[ExtractTables] 

--truncate table [ADF].[ExtractTables] 
--delete from [ADF].[ExtractTables] where tablename = '<table name>'

/* Query used to run ADF Lookup */ 
SELECT [DBName], [TargetTableSchema], 
[TableName], [DateColumn], [StartDate], 
[EndDate], [TargetContainer] FROM 
[ADF].[ExtractTables] WHERE [IsActive] = 1
and DateColumn is not null 

/* Table driving the load pipelines */ 
CREATE TABLE [ADF].[MetadataLoad](
	[FileName] [varchar](100) NULL,
	[BlobContainer] [varchar](100) NULL,
	[TargetTableSchema] [varchar](10) NULL,
	[StagingTable] [varchar](100) NULL,
	[TargetTable] [varchar](100) NULL,
	[ColumnKey] [varchar](100) NULL
) ON [PRIMARY]
GO

select * from [ADF].[MetadataLoad]
--truncate table [ADF].[MetadataLoad]

INSERT INTO [ADF].[MetadataLoad]
           ([FileName]
           ,[BlobContainer]
           ,[TargetTableSchema]
           ,[StagingTable]
           ,[TargetTable]
           ,[ColumnKey])
     VALUES
           ('<Name of parquet file to load>'
           ,'<Container holding parquet file to load>'
		   ,'<target table schema in synapse sql pool>'
           ,'<staging table to load in sql pool for incremental loads>'
           ,'<final target table for either truncate reload or incremental pipeline>'
		   ,'<unique key to use to find differences in staging vs target tables>')
GO

--drop table [ADF].[PipelineLog]
CREATE TABLE [ADF].[PipelineLog](
	[ADFName] [varchar](100) NULL,
	[ADFPipelineName] [varchar](100) NULL,
	[ADFRowsCopied] [int] NULL,
	[ADFStarted] [datetime] NULL,
	[ADFFinished] [datetime] NULL,
	[FileName] [varchar](100) NULL,
	[BlobContainer] [varchar](100) NULL,
	[StagingTable] [varchar](100) NULL,
	[TargetTable] [varchar](100) NULL,
	[ColumnKey] [varchar](100) NULL,
	[SourceDBName] [varchar](100) NULL,
	[TargetTableSchema] [varchar](10) NULL,
	[TargetTableName] [varchar](100) NULL,
	[DateColumn] [varchar](100) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[NotDateColumn] [varchar](100) NULL,
	[TargetContainer] [varchar](20) NULL,
	[NotDateColumnValue] [varchar](100) NULL,
	  [Pipeline_Name] [nvarchar](100) NULL,
	  [Source] [nvarchar](500) NULL,
   [Destination] [nvarchar](500) NULL
) ON [PRIMARY]
GO

select * from [ADF].[PipelineLog]

