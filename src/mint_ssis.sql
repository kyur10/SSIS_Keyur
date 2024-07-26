
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'KoreAssignment_Keyur_Maheria')
BEGIN
    CREATE DATABASE KoreAssignment_Keyur_Maheria;
END
GO

USE KoreAssignment_Keyur_Maheria
GO

-- Check and create stg schema if it does not exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'stg')
BEGIN
    EXEC('CREATE SCHEMA stg');
END
GO

-- Check and create prod schema if it does not exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'prod')
BEGIN
    EXEC('CREATE SCHEMA prod');
END
GO

-- Check and create stg.Users table if it does not exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'stg.Users') AND type in (N'U'))
BEGIN
CREATE TABLE stg.Users (
    StgID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    FullName NVARCHAR(255),
    Age INT,
    Email NVARCHAR(255),
    RegistrationDate DATE,
    LastLoginDate DATE,
    PurchaseTotal FLOAT
);
END
GO

-- Check and create prod.Users table if it does not exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'prod.Users') AND type in (N'U'))
BEGIN
CREATE TABLE prod.Users (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    FullName NVARCHAR(255),
    Age INT,
    Email NVARCHAR(255),
    RegistrationDate DATE,
    LastLoginDate DATE,
    PurchaseTotal FLOAT,
    RecordLastUpdated DATETIME DEFAULT GETDATE()
);
END
GO

-- Data Insert
IF (SELECT COUNT(*) FROM prod.Users) = 0
BEGIN
INSERT INTO prod.Users (UserID, FullName, Age, Email, RegistrationDate, LastLoginDate, PurchaseTotal)
VALUES
(101, 'John Doe', 30, 'johndoe@example.com', '2021-01-10', '2023-03-01', 150.00),
(102, 'Jane Smith', 25, 'janesmith@example.com', '2020-05-15', '2023-02-25', 200.00),
(103, 'Emily Johnson', 22, 'emilyjohnson@example.com', '2019-03-23', '2023-01-30', 120.50),
(104, 'Michael Brown', 35, 'michaelbrown@example.com', '2018-07-18', '2023-02-20', 300.75),
(105, 'Jessica Garcia', 28, 'jessicagarcia@example.com', '2022-08-05', '2023-02-18', 180.25),
(106, 'David Miller', 40, 'davidmiller@example.com', '2017-12-12', '2023-02-15', 220.40),
(107, 'Sarah Martinez', 33, 'sarahmartinez@example.com', '2018-11-30', '2023-02-10', 140.60),
(108, 'James Taylor', 29, 'jamestaylor@example.com', '2019-06-22', '2023-02-05', 210.00),
(109, 'Linda Anderson', 27, 'lindaanderson@example.com', '2021-04-16', '2023-01-25', 165.95),
(110, 'Robert Wilson', 31, 'robertwilson@example.com', '2020-02-20', '2023-01-20', 175.00);
END

-- Create Users_Errors table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'stg.Users_Errors') AND type in (N'U'))
BEGIN
CREATE TABLE stg.Users_Errors (
    StgID INT PRIMARY KEY,
    UserID INT,
    FullName NVARCHAR(255),
    Age INT,
    Email NVARCHAR(255),
    RegistrationDate DATE,
    LastLoginDate DATE,
    PurchaseTotal FLOAT
);
END