-- Data Cleaning

-- 1. Standardize data
-- 2. Remove duplicates
-- 3. Null values or blank values
-- 4. Remove any columns and rows
-- 5. Replacing values
-- 6. Exploratory data analysis
-- 7. Identifying top sellers
-- 8. Beginning to identify CLV/loyalty


-- 1. Standardize data

SELECT * 
FROM wine_customer_segmentation;


CREATE TABLE wcs_staging2
LIKE wine_customer_segmentation;

SELECT * FROM wcs_staging2;

INSERT wcs_staging2
SELECT *
FROM wine_customer_segmentation;

SELECT * FROM wcs_staging2;

SELECT Dt_Customer,
STR_TO_DATE(Dt_Customer, '%d-%m-%Y')
FROM wcs_staging2;

UPDATE wcs_staging2
SET Dt_Customer = STR_TO_DATE(Dt_Customer, '%d-%m-%Y');

SELECT Dt_Customer
FROM wcs_staging2;

ALTER TABLE wcs_staging2
MODIFY COLUMN Dt_Customer DATE;

SELECT * FROM wcs_staging2;

ALTER TABLE wcs_staging2
RENAME COLUMN Dt_Customer TO Customer_Since;

SELECT * FROM wcs_staging2;

ALTER TABLE wcs_staging2
RENAME COLUMN Year_Birth TO Birth_Year,
RENAME COLUMN Recency TO Last_Purchase_Day_Count,
RENAME COLUMN MntWines TO Wine,
RENAME COLUMN MntFruits TO Fruit,
RENAME COLUMN MntMeatProducts TO Meat,
RENAME COLUMN MntFishProducts TO Fish,
RENAME COLUMN MntSweetProducts TO Sweets,
RENAME COLUMN MntGoldProds TO Gold,
RENAME COLUMN NumDealsPurchases TO Count_Discounted_Purchases,
RENAME COLUMN NumWebPurchases TO Web_Orders,
RENAME COLUMN NumCatalogPurchases TO Catalog_Orders,
RENAME COLUMN NumStorePurchases TO Store_Orders,
RENAME COLUMN NumWebVisitsMonth TO Web_Visits_This_Month,
RENAME COLUMN AcceptedCmp1 TO Converted_on_Camp1,
RENAME COLUMN AcceptedCmp2 TO Converted_on_Camp2,
RENAME COLUMN AcceptedCmp3 TO Converted_on_Camp3,
RENAME COLUMN AcceptedCmp4 TO Converted_on_Camp4,
RENAME COLUMN AcceptedCmp5 TO Converted_on_Camp5, 
RENAME COLUMN Complain TO Complaints_past_2Y,
RENAME COLUMN Z_CostContact TO CPGA,
RENAME COLUMN Z_Revenue TO ARPU;

SELECT * FROM wcs_staging2;


-- 2. Remove Duplicates

SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY ID, Year_Birth, Education, Marital_Status, Income) AS row_num
FROM wcs_staging2;

-- No duplicates found


-- 3. Null values or blank values

SELECT *
FROM wcs_staging2
WHERE ID = '0';

DELETE
FROM wcs_staging2
WHERE ID = '0';

SELECT * FROM wcs_staging2;

SELECT *
FROM wcs_staging2
WHERE ID is null;


-- 4. Removing unecessary columns and rows

-- We could drop the CPGA and ARPU columns, since they contain repeated numbers, but I decided to rename and keep for viz purposes of this project.

DELETE FROM wcs_staging2
WHERE Marital_Status = 'Absurd';

DELETE FROM wcs_staging2
WHERE Marital_Status = 'YOLO';

-- 5. Replacing values with better descriptors

SELECT DISTINCT Education
FROM wcs_staging2
ORDER BY 1;

UPDATE wcs_staging2
SET Education = 'Postgraduate'
WHERE Education LIKE '2n Cycle';

UPDATE wcs_staging2
SET Education = 'Bachelors'
WHERE Education LIKE 'Graduation';

UPDATE wcs_staging2
SET Education = 'High Scool'
WHERE Education LIKE 'Basic';

SELECT DISTINCT Marital_Status
FROM wcs_staging2
ORDER BY 1;

UPDATE wcs_staging2
SET Marital_Status = 'Single'
WHERE Marital_Status LIKE 'Alone';

UPDATE wcs_staging2
SET Marital_Status = 'Partner'
WHERE Marital_Status LIKE 'Together';


-- 6. Exploratory data analysis
-- Finding and dropping outliers

SELECT min(Birth_Year), avg(Birth_Year), max(Birth_Year)
FROM wcs_staging2;

SELECT DISTINCT Birth_Year
FROM wcs_staging2
ORDER BY 1;

DELETE FROM wcs_staging2
WHERE Birth_Year = '1893';

DELETE FROM wcs_staging2
WHERE Birth_Year = '1899';

DELETE FROM wcs_staging2
WHERE Birth_Year = '1900';

SELECT min(Birth_Year), avg(Birth_Year), max(Birth_Year)
FROM wcs_staging2;

SELECT * FROM wcs_staging2;

SELECT min(Income), avg(Income), max(Income)
FROM wcs_staging2;

SELECT DISTINCT Income
FROM wcs_staging2
ORDER BY 1;

DELETE FROM wcs_staging2
WHERE Income = '666666';

SELECT * FROM wcs_staging2;

SELECT min(Kidhome), avg(Kidhome), max(Kidhome)
FROM wcs_staging2;

SELECT min(Teenhome), avg(Teenhome), max(Teenhome)
FROM wcs_staging2;

SELECT min(Customer_Since), max(Customer_Since)
FROM wcs_staging2;

SELECT min(Last_Purchase_Day_Count), avg(Last_Purchase_Day_Count), max(Last_Purchase_Day_Count)
FROM wcs_staging2;

SELECT * FROM wcs_staging2;

-- Not noticing any other crazy outliers in this dataset


-- 7. Identifying top sellers

SELECT min(Wine), avg(Wine), max(Wine), sum(Wine)
FROM wcs_staging2;
-- 0	305.2569	1493 	673702

SELECT min(Fruit), avg(Fruit), max(Fruit), sum(Fruit)
FROM wcs_staging2;
-- 0	26.3054		199 	8056

SELECT min(Meat), avg(Meat), max(Meat), sum(Meat)
FROM wcs_staging2;
-- 0	166.8287	1725	368191

SELECT min(Fish), avg(Fish), max(Fish), sum(Fish)
FROM wcs_staging2;
-- 0	37.4291		259		82606

SELECT min(Sweets), avg(Sweets), max(Sweets), sum(Sweets)
FROM wcs_staging2;
-- 0	27.0381		262		59673

SELECT min(Gold), avg(Gold), max(Gold), sum(Gold)
FROM wcs_staging2;
-- 0	43.7780		321		96618

SELECT * FROM wcs_staging2;

SELECT ID, SUM(`Wine`+`Fruit`+`Meat`+`Fish`+`Sweets`+`Gold`) AS Total_Orders
FROM wcs_staging2
GROUP BY ID;

ALTER TABLE wcs_staging2 
ADD Total_Orders INT
GENERATED ALWAYS AS (`Wine`+`Fruit`+`Meat`+`Fish`+`Sweets`+`Gold`) STORED;


-- 8. Beginning to identify CLV/loyalty

SELECT Customer_Since, curdate(), datediff(curdate(), Customer_Since) AS Customer_Since_in_Days, Total_Orders
FROM wcs_staging2;

SELECT * FROM wcs_staging2;

-- Now that I have a good idea of top selling products, and how long the customers have been users, now is a good time to pop this database into Excel for further analysis



























