/* =====================================================================
   Gaza Humanitarian Supply Analysis
   02 - SILVER LAYER
   Purpose: Cleaned, trusted version of the raw data.
   Missing values in TEXT columns only are replaced with explicit
   placeholders instead of being dropped, to preserve every valid
   data point in the other columns of the same record.
   No rows are ever deleted at this layer.
===================================================================== */

USE [GazaSupply_Analysis2]
GO

/****** Object:  View [silver].[commodities_clean]    Script Date: 8/3/2026 4:52:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE or alter VIEW [silver].[commodities_clean] AS
SELECT
    ID,
    NoOfTrucks,
    ReceivedDate,
    DataSource,
    ISNULL(ManifestOf, 'Not Specified')        AS ManifestOf,
    DescriptionOfCargo,
    CargoCategory,
    Status,
    Quantity,
    ISNULL(Units, 'Not Specified')             AS Units,
    ISNULL(DonatingOrg, 'Unknown')             AS DonatingOrg,
    DonationType,
    Crossing,
    ISNULL(DestinationPartner, 'Not Recorded') AS DestinationPartner,
    DataPeriod,
    DataEntryType,
    LastEditedTime
FROM bronze.commodities_raw;
GO


