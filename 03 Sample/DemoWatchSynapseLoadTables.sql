/****** Watch Synapse Tables Load and validate  ******/
select count(*) as Biometrics from [COW].[Biometrics]
select count(*) as Biometrics_Stg from [COW].[Biometrics_Stg]

SELECT TOP 10 * 
  FROM [COW].[Biometrics]

select min(BirthDate) as MinAttendanceDate
from [COW].[Biometrics]

select max(BirthDate) as MaxAttendanceDate
from [COW].[Biometrics]

select distinct(Animal)
from [COW].[Biometrics]

--  truncate table [COW].[Biometrics]
--  truncate table [COW].[Biometrics_Stg]



