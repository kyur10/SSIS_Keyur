# SSIS Package Execution Report

**Execution Date:** 26 July 2024

**Package Name:** SSIS1

---
## Outcome

### Data Extraction and Transformation 
- *Extract:* Successfully extracted **33** records from CSV file.
- *Transform:* All **33** records converted to appropriate SQL data types (INT, NVARCHAR, FLOAT AND DATE).

### Data Cleaning in Staging Table

- *Isolate:* **8** records isolated to Users_Errors table due to data quality issues.
- *Remove:* **3** duplicate records identified and removed.

### Incremental Load to Production Table

- *Insert:* **24** new and error free records from staging table successfully inserted into the production table.
- *Update:* **1** existing records successfully updated in the production table.

---

## Exclusions and Reasons

#### Total Records Excluded: *8*


#### Reasons

1. **Duplicate Records:** **3**
   - *Details:* Records identified as duplicates based on User ID.
  
2. **Null Values:** **2**
   - *Details:* A User should not have Null values for UserId, Full Name, Email or Registration Date. 

3. **Invalid Age:** **1**
   - *Details:* Records with null values in fields that are required to have a value.

4. **Future Date in Login & Register:** **1**
   - *Details:* Last Login and Register date of the user should not exceed current date.

5. **Invalid Email:** **1**
   - *Details:* Email should have @ and length should be greater than 5.

---

## Challenges Faced and Solutions

### 1. Incorrect Data Formats
- **Challenge:** 
  - CSV file had values surrounded by quotation marks.
  - Data type were not compatible with SQL Server.
- **Solution:** 
  - Configured the flat file connection and added quotation mark in "Text qualifier"
  - Using "Data Conversion" task  converted to appropriate SQL Data Type (DT_I4, DT_WSTR(255), DT_DBDATE AND DT_R8)

### 2. Error Records
- **Challenge:** Source data contained records that did not meet data quality standards, such as null values, Future Login/Register dates, Negative Age and Invalid Email.
- **Solution:** Created a separate error table (Users_Errors) for review and correction.

### 3. Duplicate Records
- **Challenge:** Source data contained duplicate records.
- **Solution:** Isolated duplicate records into Users_Errors table and deleted duplicates from staging table (so that can perform lookup with production table with only unique values)


### 4. Incremental Loading
- **Challenge:** Differentiating new from existing records for incremental loading into the production table.
- **Solution:** Checked existing values in production table with staging table to separate new from matching records
    - **Insert:**  For new records, checked with the Users_Errors table to only select the valid records from staging table.
    - **Update:**  
      - For matching records, checked with the Registration Date to update that record if the value is different in both tables.
      - Also update the value of "RecordLastUpdated" by using GETDATE() when updating the record.

---