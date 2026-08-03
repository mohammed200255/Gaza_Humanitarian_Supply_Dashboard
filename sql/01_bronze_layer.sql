/* =====================================================================
   Gaza Humanitarian Supply Analysis
   01 - BRONZE LAYER
   Purpose: Raw ingestion of UNRWA supply data exactly as received.
   No transformations are applied at this stage — this is the
   single source of truth / backup layer.
   Source: UNRWA Gaza Supply Dashboard (data.humdata.org)
===================================================================== */
USE [GazaSupply_Analysis2]

CREATE DATABASE GazaSupply_Analysis2;
GO
USE GazaSupply_Analysis2;
GO

CREATE SCHEMA bronze;
GO

CREATE TABLE bronze.commodities_raw (
    ID                      INT PRIMARY KEY,
    NoOfTrucks              INT,
    ReceivedDate            DATE,
    DataSource              NVARCHAR(20),
    ManifestOf              NVARCHAR(50),
    DescriptionOfCargo      NVARCHAR(150),
    CargoCategory           NVARCHAR(20),
    Status                  NVARCHAR(20),
    Quantity                INT,
    Units                   NVARCHAR(20),
    DonatingOrg             NVARCHAR(100),
    DonationType            NVARCHAR(30),
    Crossing                NVARCHAR(20),
    DestinationPartner      NVARCHAR(60),
    DataPeriod              NVARCHAR(50),
    DataEntryType           NVARCHAR(20),
    LastEditedTime           DATETIME
);
GO

/* -----------------------------------------------------------------
   Load data from the CSV export of the source Excel file.
   NOTE: FORMAT='CSV' + FIELDQUOTE='"' are required because several
   free-text fields (e.g. Description of Cargo) contain commas
   inside quoted values (e.g. "IEHK, NCD, Tesk {Kits#7}").
   Without these options, BULK INSERT misaligns columns.
------------------------------------------------------------------ */
TRUNCATE TABLE bronze.commodities_raw;
GO

BULK INSERT bronze.commodities_raw
FROM 'E:\Data Analysis\Gaza_Humanitarian_Supply_Analysis\data\commodities-received-13.csv'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    CODEPAGE        = '65001',
    FORMAT          = 'CSV',
    FIELDQUOTE      = '"',
    TABLOCK
);
GO

-- Sanity check: should return 50,059
SELECT COUNT(*) AS TotalRows FROM bronze.commodities_raw;
GO
