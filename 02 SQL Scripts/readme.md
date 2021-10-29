# 02 SQL Scripts
This folder contains MetadataTablesCreate.sql.  The MetadataTablesCreate.sql script will create 3 metadata tables and statements to insert data into them.  

## Asset List - These items will be created 
	1. ADF schema - can change based on your naming conventions
	2. [ADF].[ExtractTables] - table that drives the SQL Date Based Extract pipeline and dictates which SQL Server tables are extracted and what timeframe to extract
	3. [ADF].[MetadataLoad] - table that drives the other 2 ADF pipelines to load which parquet files and what tables to load them into within the Synapse sql pool 
  	4. [ADF].[PipelineLog] - table to capture metadata and parameter values from pipeline runs. 

## Steps 
1. Connect to the Azure SQL DB to create the metadata tables.  Open the MetadataTablesCreate.sql file and update the insert statements for the extracts with your Azure SQL DB.  
2. Run the script to create and insert statements for [ADF].[ExtractTables].  You will come back later to the insert for [ADF].[MetadataLoad] once you have a file to load.  
3. Navigate to your dedicated SQL pool.  You can do this within Synapse Studio or use the dedicated SQL endpoint and your preferred query tool.  Make sure that your dedicated pool is running.  Make sure you have destination tables created in your dedicated SQL pool for a final table and a staging table.  You can view the sample scripts in XX location for reference.  You'll want to make sure your distribution is appropriate.  See this link for further details.  
4.  Navigate to pipelines (left pane pipe icon).  Run the SQL Date Based Extract pipeline - this pipeline will extract data based on the date range in the [ADF].[ExtractTables].  The pipeline will extract all the rows in the source table from [ADF].[ExtractTables] values that have [DateColumn] column values between [StartDate] and [EndDate] (example values "2019-02-18' to '2019-02-22').  
5.  Verify the parquet file extracts successfully into your ADLS storage location (paramfile01.json value supplied for azstoragename2).  You can skip to #7 if you'd like to upload it now. 
6.  Run the PL SQL Not Date Based Extract pipeline - this pipeline will extract data based on the [NotDateColumn] value in the [ADF].[ExtractTables].  You need to supply a valid column value for the column in the NotDateColumnValue parameter.  The NotDateColumn needs to be supplied the same value column contained in the metadata [NotDateColumn].  For example, the sample is set to extract all the rows in the COW.Biometrics table that have Animal column value = value you specify at run time.  You can use 9111 for first value and Animal for the second. That will extract all the rows where the Animal = 9111.  
7.  Now that we have parquet files to use, we can now update the [ADF].[MetadataLoad] table with filenames we want to load.  Navigate back to query tool and update the insert statement with filename from one of the extract pipeline runs above.  Run the insert statement.  
8.  You can now run the Truncate Load Synapse pipeline.  You will be prompted again for the filename that will match to our [ADF].[MetadataLoad] for where it will load the data in the dedicated SQL pool.  This pattern will truncate and reload the destination table.  Verify it loads successfully in the dedicated SQL pool tables. 
9.  You can also now run the Incremental Load pipeline.  This will use a staging table to load what's contained in the parquet file.  It will then trunate the staging table, check for values in the final target table that match, delete them, and reload from the staging table.  
10.  Validate you have values within your staging and target tables.  You can add another entry into the [ADF].[MetadataLoad] for the other extracted parquet file and re-run the pipeline passing that filename into the parameter.  
11. If running the SQL Not Date Based Extract, validate the logging is captured in ADF.PipelineLog table. Note: not all fields populate (update later to come to resolve)
  
	
