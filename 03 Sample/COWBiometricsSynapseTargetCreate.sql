/****** Object:  Table [ADF].[Biometrics]    Script Date: 9/22/2020 9:07:28 PM ******/

CREATE SCHEMA [COW]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADF].[Biometrics]') AND type in (N'U'))
DROP TABLE [COW].[Biometrics]
GO

/****** Object:  Table [ADF].[Biometrics]    Script Date: 9/22/2020 9:07:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [COW].[Biometrics]
(
	[Order] [float] NULL,
	[Pen] [float] NULL,
	[Animal] [float] NULL,
	[Gender] [nvarchar](255) NULL,
	[BirthDate] [datetime] NULL,
	[Age_days] [float] NULL,
	[Date] [datetime] NULL,
	[WitherHeight] [float] NULL,
	[HipHeight] [float] NULL,
	[WidthHeight] [float] NULL,
	[GirthCirc] [float] NULL,
	[BCS] [float] NULL,
	[BW] [float] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO



CREATE TABLE [COW].[Biometrics_Stg]
(
	[Order] [float] NULL,
	[Pen] [float] NULL,
	[Animal] [float] NULL,
	[Gender] [nvarchar](255) NULL,
	[BirthDate] [datetime] NULL,
	[Age_days] [float] NULL,
	[Date] [datetime] NULL,
	[WitherHeight] [float] NULL,
	[HipHeight] [float] NULL,
	[WidthHeight] [float] NULL,
	[GirthCirc] [float] NULL,
	[BCS] [float] NULL,
	[BW] [float] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO


