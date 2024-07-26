# Data ETL using SSIS
This SSIS package automates the ETL process by *extracting* data from a CSV file, *transforming* it into appropriate SQL data types, *cleaning* the data of the staging table, and incrementally *loading* the cleaned data into a production table. 

The package addresses common data issues such as incorrect data formats, duplicates, and error handling. 

---

## Setup

#### Required Tools 

- Visual Studio: 
  - Install `SQL Server Integration Services Projects` extension in Visual studio 
- SQL Server 
- SQL Server Management Studio (SSMS) **OR** Azure Data Studio

#### Steps to run the package

1. **Clone the Repository:**
   - Clone this repository to your local machine using Git.
     ```bash
     git clone https://github.com/kyur10/SSIS_Keyur.git
     cd SSIS_Keyur
     ```

2. **Open the SSIS Project:**
   - Open the SSIS project in Visual Studio by double-clicking the `SSIS1.sln` file.

3. **Setup SQL Server:**
   - Connect to SQL Server using Azure Data Studio or SQL Server Management Studio (SSMS). 
   - Restore the backup from `\src\backup_ssis.bak`
      ```sql 
      USE master 
      RESTORE DATABASE KoreAssignment_Keyur_Maheria
      FROM DISK='[path..]\src\backup_ssis.bak'
      WITH MOVE N'KoreAssignment_Keyur_Maheria' TO N'[path..]\src\backup_ssis.mdf',
      MOVE N'KoreAssignment_Keyur_Maheria_log' TO N'[path..]\src\backup_ssis.ldf'
      ```
   - **OR** 
   - execute `\src\mint_ssis.sql` script

4. **Configure Connection Manager:**
   - Select `Native OLE DB\Microsoft OLE DB Driver for SQL Server` for Provider in Connection Manager.
   - Enter server name and provide database name: `KoreAssignment_Keyur_Maheria` in Initial Catalog.
   - Click `Test Connection` on bottom left to ensure that Sql Server is connected.  
  
5. **Flat File Connection Manager:** 
   - Enter File name by browsing the path of the `\src\data.csv` file.
   - Enter `"` in `Text qualifier:` field.
   - Ensure that the `Column names in the first data row` checkbox is clicked. 

6. **Execute the SSIS Package:**
   - Run the SSIS package by clicking "Start" button in Visual Studio.

---

## Process

1. **Extract:**
   - **Task:** Using SSIS package, extract data from a CSV file. The source data may contain various errors, including incorrect formats (e.g., date or number format), null values (blank or incompatible data type) and the values may be  surrounded by quotations.
   - **Operation:** 
     - Extract from CSV file using "Flat File Source" in  Data Flow.

2. **Transform:**
   - **Task:**  Convert extracted data to appropriate SQL data types in order to load the data into a staging table.
   - **Operation:** 
     - Apply "Data Conversion" to the extracted data from the Flat file source and provide appropriate data types (e.g., DT_I4, DT_WSTR(255), DT_DBDATE AND DT_R8). 
     - Add a "OLE DB Destination" for staging table and map the converted columns to the staging table.

3. **Data Cleaning:**
   - **Tasks:**
     - **Handling error records:** 
       - Use "Conditional Split" and split rows containing Null values, Invalid Age (<=0), Future Login/Register date and Invalid Email (Not containing @ or length < 5). 
       - Combine all these records by applying "Union All"
       - Isolate these records for future review by inserting them in "Users_Errors" table.
     - **Removing duplicates:** 
       - From the staging table, copy the duplicate records into the "Users_Errors" table, except the latest one.
       - Then delete these records from the staging table.
       - Used "Execute SQL Task" for executing this SQL commands.

4. **Incremental Load:**
   - **Task:** Insert new records and update existing records in the production table.
   - **Operation:**
     - Apply "Lookup" on Staging table and compare it with the Production table based on UserID column 
     - **Insert:** 
       - Redirect non matching rows and compare them with Users_Errors table to get the data without errors. 
       - Insert the clean data to the production table.
     - **Update:**
       - Compare "Registration Date" column for the matching records to decide if the record is updated or not.
       - If the record is updated then update the record in production table and set the "RecordLastUpdated" column to current time.
       
---