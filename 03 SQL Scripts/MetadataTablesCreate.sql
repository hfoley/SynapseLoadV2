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
	[TargetContainer] [varchar](20) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
GO

--INSERT [ADF].[ExtractTables] ([DBName], [TargetTableSchema], [TableName], [DateColumn], [StartDate], [EndDate], [TargetContainer], [IsActive]) VALUES (N'hopeedu', N'K12', N'ClassAttendance', N'AttendanceDate', CAST(N'2016-08-31' AS Date), CAST(N'2016-11-16' AS Date), N'highered', 1)
INSERT [ADF].[ExtractTables] ([DBName], [TargetTableSchema], [TableName], [DateColumn], [StartDate], [EndDate], [TargetContainer], [IsActive]) VALUES (N'hopeedu', N'COW', N'Biometrics', N'BirthDate', CAST(N'2019-02-18' AS Date), CAST(N'2019-02-22' AS Date), N'dataflow', 1)
--INSERT [ADF].[ExtractTables] ([DBName], [TargetTableSchema], [TableName], [DateColumn], [StartDate], [EndDate], [TargetContainer], [IsActive]) VALUES (N'hopeedu', N'HigherEd', N'StudentSurveyDetails', N'SurveyTakenDate', CAST(N'2020-02-27' AS Date), CAST(N'2020-02-27' AS Date), N'dataflow', 0)
--INSERT [ADF].[ExtractTables] ([DBName], [TargetTableSchema], [TableName], [DateColumn], [StartDate], [EndDate], [TargetContainer], [IsActive]) VALUES (N'hopeedu', N'dbo', N'Orders', N'OrderDate', CAST(N'1996-07-18' AS Date), CAST(N'1996-12-31' AS Date), N'highered', 1)
GO

select * from [ADF].[ExtractTables] 

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


INSERT INTO [ADF].[MetadataLoad]
           ([FileName]
           ,[BlobContainer]
           ,[TargetTableSchema]
           ,[StagingTable]
           ,[TargetTable]
           ,[ColumnKey])
     VALUES
           ('ParquetBiometrics2020-09-23-0047'
           ,'highered'
		   ,'ADF'
           ,'Biometrics_Stg'
           ,'Biometrics'
		   ,'Animal')
GO


INSERT INTO [ADF].[MetadataLoad]
           ([FileName]
           ,[BlobContainer]
           ,[TargetTableSchema]
           ,[StagingTable]
           ,[TargetTable]
           ,[ColumnKey])
     VALUES
           ('ParquetStudent'
           ,'hopemadedis3cont'
		   ,'ADF'
           ,'Student_Stg'
           ,'Student'
		   ,'CRMID')
GO