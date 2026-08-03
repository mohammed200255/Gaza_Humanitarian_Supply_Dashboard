/* =====================================================================
   Gaza Humanitarian Supply Analysis
   03 - GOLD LAYER
   Purpose: Pre-aggregated, analysis-ready views. Each view feeds
   one page of the Power BI dashboard. No duplicate/derivable
   columns are kept (e.g. SUM(NoOfTrucks) was dropped since
   NoOfTrucks = 1 for every raw record, making it identical to
   COUNT(*)).
===================================================================== */

USE GazaSupply_Analysis2;
GO

CREATE SCHEMA gold;
GO

/* ---------------------------------------------------------------
   1) OVERVIEW  -> Dashboard page: Overview
------------------------------------------------------------------ */
USE [GazaSupply_Analysis2]
GO

/****** Object:  View [gold].[overview_summary]    Script Date: 8/3/2026 5:05:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [gold].[overview_summary] AS
SELECT
    CargoCategory,
    Crossing,
    DonationType,
    YEAR(ReceivedDate)  AS ReceivedYear,
    MONTH(ReceivedDate) AS ReceivedMonth,
    ReceivedDate,
    SUM(Quantity)     AS TotalQuantity,
    COUNT(*)          AS NumShipments
FROM silver.commodities_clean
GROUP BY 
    CargoCategory, Crossing, DonationType,
    YEAR(ReceivedDate), MONTH(ReceivedDate), ReceivedDate;
GO



/* ---------------------------------------------------------------
   2) FOOD ITEMS  -> Dashboard page: Food Items
------------------------------------------------------------------ */
USE [GazaSupply_Analysis2]
GO

/****** Object:  View [gold].[food_analysis]    Script Date: 8/3/2026 5:03:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [gold].[food_analysis] AS
SELECT
    DescriptionOfCargo,
    Crossing,
    DonatingOrg,
    DonationType,
    ReceivedDate,
    YEAR(ReceivedDate)  AS ReceivedYear,
    MONTH(ReceivedDate) AS ReceivedMonth,
    SUM(Quantity)      AS TotalQuantity,
    COUNT(*)           AS NumShipments
FROM silver.commodities_clean
WHERE CargoCategory = 'Food Items'
GROUP BY 
    DescriptionOfCargo, Crossing, DonatingOrg, DonationType,
    ReceivedDate, YEAR(ReceivedDate), MONTH(ReceivedDate);
GO



/* ---------------------------------------------------------------
   3) NON-FOOD ITEMS  -> Dashboard page: Non-Food Items
------------------------------------------------------------------ */
USE [GazaSupply_Analysis2]
GO

/****** Object:  View [gold].[nfi_analysis]    Script Date: 8/3/2026 5:04:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [gold].[nfi_analysis] AS
SELECT
    DescriptionOfCargo,
    Crossing,
    DonatingOrg,
    DonationType,
    ReceivedDate,
    YEAR(ReceivedDate)  AS ReceivedYear,
    MONTH(ReceivedDate) AS ReceivedMonth,
    SUM(Quantity)      AS TotalQuantity,
    COUNT(*)           AS NumShipments
FROM silver.commodities_clean
WHERE CargoCategory = 'Non-Food Items'
GROUP BY 
    DescriptionOfCargo, Crossing, DonatingOrg, DonationType,
    ReceivedDate, YEAR(ReceivedDate), MONTH(ReceivedDate);
GO



/* ---------------------------------------------------------------
   4) MEDICAL SUPPLIES  -> Dashboard page: Medical Supplies
------------------------------------------------------------------ */
USE [GazaSupply_Analysis2]
GO

/****** Object:  View [gold].[medical_analysis]    Script Date: 8/3/2026 5:04:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [gold].[medical_analysis] AS
SELECT
    DescriptionOfCargo,
    Crossing,
    DonatingOrg,
    DonationType,
    ReceivedDate,
    YEAR(ReceivedDate)  AS ReceivedYear,
    MONTH(ReceivedDate) AS ReceivedMonth,
    SUM(Quantity)      AS TotalQuantity,
    COUNT(*)           AS NumShipments
FROM silver.commodities_clean
WHERE CargoCategory = 'Medical Supplies'
GROUP BY 
    DescriptionOfCargo, Crossing, DonatingOrg, DonationType,
    ReceivedDate, YEAR(ReceivedDate), MONTH(ReceivedDate);
GO




/****** Object:  View [gold].[cross_category_compare]    Script Date: 8/3/2026 5:02:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [gold].[cross_category_compare] AS
SELECT
    CargoCategory,
    Crossing,
    DonationType,
    DonatingOrg,
    DataPeriod,
    ReceivedDate,
    YEAR(ReceivedDate)  AS ReceivedYear,
    MONTH(ReceivedDate) AS ReceivedMonth,
    SUM(Quantity)       AS TotalQuantity,
    COUNT(*)            AS NumShipments
FROM silver.commodities_clean
GROUP BY 
    CargoCategory, Crossing, DonationType, DonatingOrg, DataPeriod,
    ReceivedDate, YEAR(ReceivedDate), MONTH(ReceivedDate);
GO



/* ---------------------------------------------------------------
   Sanity checks
------------------------------------------------------------------ */
SELECT COUNT(*) AS OverviewRows FROM gold.overview_summary;
SELECT COUNT(*) AS FoodRows     FROM gold.food_analysis;
SELECT COUNT(*) AS NFIRows      FROM gold.nfi_analysis;
SELECT COUNT(*) AS MedicalRows  FROM gold.medical_analysis;
SELECT COUNT(*) AS CompareRows  FROM gold.cross_category_compare;
GO
