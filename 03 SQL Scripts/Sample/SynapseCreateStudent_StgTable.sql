

CREATE TABLE [ADF].[Student_Stg]
(
	[CRMID] [int] NOT NULL,
	[LAST_NAME] [nvarchar](1) NULL,
	[FIRST_NAME] [nvarchar](1) NULL,
	[MIDDLE_NAME] [nvarchar](1) NULL,
	[ADMIT_TERM] [smallint] NOT NULL,
	[ADMIT_DESCR] [nvarchar](50) NOT NULL,
	[ACAD_CAREER] [nvarchar](50) NOT NULL,
	[ADMIT_TYPE] [nvarchar](50) NOT NULL,
	[ADMIT_TYPE_DESCR] [nvarchar](50) NOT NULL,
	[APPL_SOURCE] [nvarchar](50) NOT NULL,
	[ACAD_PROG] [nvarchar](50) NOT NULL,
	[ACAD_PROG_DESCR] [nvarchar](50) NOT NULL,
	[ACAD_PLAN] [nvarchar](50) NOT NULL,
	[ACAD_PLAN_DESCR] [nvarchar](50) NOT NULL,
	[CURRENT_PROGRAM] [nvarchar](50) NOT NULL,
	[CURRENT_PROGRAM_DESCR] [nvarchar](50) NOT NULL,
	[CURRENT_PLAN] [nvarchar](50) NOT NULL,
	[CURRENT_PLAN_DESCR] [nvarchar](50) NOT NULL,
	[GENDER] [nvarchar](50) NOT NULL,
	[AGE_BY_YEARS] [tinyint] NOT NULL,
	[ADDRESS1] [nvarchar](1) NULL,
	[ADDRESS2] [nvarchar](1) NULL,
	[CITY] [nvarchar](50) NULL,
	[STATE] [nvarchar](50) NULL,
	[POSTAL] [nvarchar](50) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO


