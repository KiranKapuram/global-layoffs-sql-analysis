-- SQL PROJECT ON WORLD WIDE LAYOFFS BY DIFFERENT COMPANIES FROM 2019 - 2022
-- DATA CLEANING 

USE world_layoffs;
SELECT * FROM world_layoffs.layoffs_raw;

-- First thing I would like to do is Clean Data and then perform EDA using SQL. 
-- so, I would like to be this raw data as it and I would like to create staging table, Because I want this raw data in case something goes wrong.

CREATE TABLE layoffs
LIKE world_layoffs.layoffs_raw;

SELECT * FROM layoffs;

-- now physical structure of staging table is ready, Now I will insert that raw data into this staging table 
INSERT  layoffs SELECT * FROM  world_layoffs.layoffs_raw;

-- Now I would like to clean the data like:
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

-- # First let's check for duplicates
SELECT 
    company, location, industry, total_laid_off, percentage_laid_off,
    date, stage, country, funds_raised,
    COUNT(*) AS duplicate_count
FROM layoffs
GROUP BY 
    company, location, industry, total_laid_off, percentage_laid_off,
    date, stage, country, funds_raised
;


-- -- these are the ones we want to delete where the row number is > 1 or 2or greater essentially
SELECT 
    company, location, industry, total_laid_off, percentage_laid_off,
    date, stage, country, funds_raised,
    COUNT(*) AS duplicate_count
FROM layoffs
GROUP BY 
    company, location, industry, total_laid_off, percentage_laid_off,
    date, stage, country, funds_raised
HAVING duplicate_count > 1;

CREATE TABLE layoffs_clean
LIKE layoffs;

select * from layoffs_clean;

Alter table layoffs_clean DROP COLUMN date_added;
Alter table layoffs_clean DROP COLUMN Source;
Alter table layoffs_clean ADD COlumn duplicate_count int;

INSERT INTO layoffs_clean
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised`,
`Duplicate_count`)
SELECT 
    company, location, industry, total_laid_off, percentage_laid_off,
    date, stage, country, funds_raised,
    COUNT(*) AS duplicate_count
FROM layoffs
GROUP BY 
    company, location, industry, total_laid_off, percentage_laid_off,
    date, stage, country, funds_raised;

select * from layoffs_clean
where duplicate_count >1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM layoffs_clean
where duplicate_count >= 2;


-- 2. Standardize Data

SELECT * FROM layoffs_clean;

-- if we look at industry it looks like we have empty rows, let's take a look at these
SELECT DISTINCT industry FROM layoffs_clean
ORDER BY industry;

SELECT * FROM layoffs_clean 
WHERE industry = ''
ORDER BY industry;

-- let's take a look at these
SELECT *
FROM world_layoffs.layoffs_clean
WHERE company LIKE 'Eyeo%';
-- nothing wrong here
SELECT *
FROM world_layoffs.layoffs_clean
WHERE company LIKE 'appsmith%';

-- we should set the blanks to nulls since those are typically easier to work with
UPDATE world_layoffs.layoffs_clean
SET industry = NULL
WHERE industry = '';


SELECT DISTINCT industry FROM layoffs_clean
ORDER BY industry;

-- now if we check those are all null

SELECT *
FROM world_layoffs.layoffs_clean
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- we should set the blanks to nulls since those are typically easier to work with 
SELECT *
FROM world_layoffs.layoffs_clean
WHERE percentage_laid_off IS NULL 
OR percentage_laid_off = ''
ORDER BY percentage_laid_off;

UPDATE world_layoffs.layoffs_clean
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';


UPDATE world_layoffs.layoffs_clean
SET total_laid_off = NULL
WHERE total_laid_off = '';

UPDATE world_layoffs.layoffs_clean
SET funds_raised = NULL
WHERE funds_raised = '';

UPDATE world_layoffs.layoffs_clean
SET location = NULL
WHERE location = '';


-- now we need to populate those nulls if possible

UPDATE layoffs_clean t1
JOIN layoffs_clean t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


select * from layoffs_clean 
where industry Like '%crypto%';

select * from layoffs_clean;

-- everything looks good except apparently we have some "United States" and some "United States." with a period at the end. Let's standardize this.

SELECT DISTINCT country
FROM layoffs_clean
ORDER BY country;

UPDATE layoffs_clean
SET country = TRIM(TRAILING '.' FROM country);

-- now if we run this again it is fixed
SELECT DISTINCT country
FROM layoffs_clean
ORDER BY country;


-- Let's also fix the date columns:
SELECT *
FROM layoffs_clean;

-- we can use str to date to update this field
UPDATE layoffs_clean
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


-- now we can convert the data type properly
ALTER TABLE layoffs_clean
MODIFY COLUMN `date` DATE;

-- we can use str to int to update this field
ALTER TABLE layoffs_clean
MODIFY total_laid_off INT;

---- we can use str to decimal to update this field
ALTER TABLE layoffs_clean
MODIFY percentage_laid_off DECIMAL(5,2);

/* we can use str to int to update this field , as the funds_raised values there is $ symbobl first I need to rename the column to funds_raised_in_Dollars 
then I will remove the dollor sybol, from all the values and then I will convertn them into int type*/
ALTER TABLE layoffs_clean
RENAME COLUMN funds_raised TO funds_raised_in_dollars;

-- triming the $ sign from the funds raised column 
UPDATE layoffs_clean
SET funds_raised_in_dollars = TRIM(BOTH '$' FROM funds_raised_in_dollars);

-- convert type to int 
ALTER TABLE layoffs_clean
MODIFY funds_raised_in_dollars float;

SELECT *
FROM world_layoffs.layoffs_clean
order by date ;


-- 3. Look at Null Values

-- the null values in total_laid_off, percentage_laid_off, idustry, and funds_raised_millions all look normal. I don't think I want to change that
-- I like having them null because it makes it easier for calculations during the EDA phase

-- so there isn't anything I want to change with the null values




-- 4. remove any columns and rows we need to

SELECT *
FROM layoffs_clean
WHERE total_laid_off IS NULL;

SELECT *
FROM layoffs_clean
WHERE total_laid_off IS NULL
OR percentage_laid_off IS NULL
OR industry IS NULL;

-- Delete Useless data we can't really use
DELETE FROM world_layoffs.layoffs_clean
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
OR industry IS NULL
;

SELECT * 
FROM layoffs_clean;

ALTER TABLE layoffs_clean
DROP COLUMN duplicate_count;


SELECT * 
FROM world_layoffs.layoffs_clean;

-- EXPLARATORY DATA ANALYSIS 

-- let's first check data quality and structure 

-- How many total rows and columns are present in the dataset?

SELECT COUNT(*) 
FROM layoffs_clean;  -- it has 4165 rows and 9 columns 

-- Which columns contain missing or null values, and how many?
SELECT * FROM layoffs_clean;

SELECT count(*) as company_null from layoffs_clean where company = '' or Company is Null; -- zero null values in company column 
SELECT count(*) as location_null from layoffs_clean where location = '' or location is Null; -- one Null record found in location column 
SELECT count(*) as total_laid_off_null from layoffs_clean where  total_laid_off  = '' or  total_laid_off  is Null;  -- 1450 null values 
SELECT count(*) as percentage_laid_off_null from layoffs_clean where  percentage_laid_off  = '' or  percentage_laid_off  is Null; -- 1532
SELECT count(*) as industry_off_null from layoffs_clean where  industry  = '' or  industry  is Null; -- Zero null values
SELECT count(*) as stage_off_null from layoffs_clean where  stage  = '' or  stage  is Null; -- five null values 
SELECT count(*) as funds_raised_null from layoffs_clean where  funds_raised  = '' or  funds_raised  is Null;  -- 465 null values
SELECT count(*) as country_null from layoffs_clean where  country  = '' or  country  is Null; -- two null values 


-- What is the total number of layoffs across all companies?
Select sum(total_laid_off) as total_layoffs 
FROM layoffs_clean;

-- What is the average number of layoffs per company?
SELECT DISTINCT company, AVG(total_laid_off) as Avg_layoffs_company 
FROM layoffs_clean
GROUP BY company
ORDER BY avg_layoffs_company DESC; 

-- What is the maximum and minimum number of layoffs recorded?
SELECT MAX(total_laid_off) as max_layoff, MIN( total_laid_off) AS min_layoff
FROM  layoffs_clean; -- max : 22000 , min :3

-- How many unique companies are in the dataset?
SELECT count(DISTINCT company) AS unique_company
FROM layoffs_clean; -- 2818 uniques companies 

-- How many unique industries are represented?
SELECT count(DISTINCT industry) AS unique_industies
FROM layoffs_clean; -- 30 unique industries 

-- How many companies reported a percentage_laid_off of 100% (complete shutdown)?
SELECT count(DISTINCT COMPANY) as complete_shutdown
FROM layoffs_clean
WHERE percentage_laid_off = 100; -- 329 companies have completly shutdown 


-- Which companies have the highest total layoffs?
SELECT 
    company,
    SUM(total_laid_off) AS total_layoffs
FROM 
    layoffs_clean
GROUP BY 
    company
ORDER BY 
    total_layoffs DESC
LIMIT 5;   

-- Which companies have the lowest total layoffs?
SELECT 
    company,
    SUM(total_laid_off) AS total_layoffs
FROM 
    layoffs_clean
GROUP BY 
    company
ORDER BY 
    total_layoffs ASC
LIMIT 5;

-- What is the total number of layoffs per year overall?
SELECT YEAR(date) AS YEAR , SUM(total_laid_off) AS total_layoffs_per_year
FROM layoffs_clean
GROUP BY YEAR(DATE); 

-- layoffs during pre pandamic 
SELECT  SUM(total_laid_off) as total_Layoffs
FROM layoffs_clean
where date between '2020-01-01' AND '2022-12-31'; -- 260190 layoffs

-- layoofs post pandamic 
SELECT SUM(total_laid_off) as total_Layoffs
FROM layoffs_clean
where date between '2023-01-01' AND '2025-09-30'; -- 507391 layoffs

-- layoffs by industries Post pandamic 
SELECT DISTINCT industry, SUM(total_laid_off) AS layoffs_by_industry
FROM layoffs_clean
WHERE date between '2023-01-01' AND '2025-09-30'
GROUP BY industry
ORDER BY layoffs_by_industry DESC
LIMIT 5; 


-- layoffs by industries during pandamic 
SELECT DISTINCT industry, SUM(total_laid_off) AS layoffs_by_industry
FROM layoffs_clean
WHERE date between '2020-01-01' AND '2022-12-31'
GROUP BY industry
ORDER BY layoffs_by_industry DESC
Limit 5;


-- Let's see what are the countries that have higses number of layoffs 
SELECT DISTINCT country, SUM(total_laid_off) as total_layoffs
FROM layoffs_clean
GROUP BY country
ORDER BY total_layoffs DESC
LIMIT 5; 

-- locations (cities or regions) had the most layoffs?
SELECT DISTINCT location, SUM(total_laid_off) as total_layoffs
FROM layoffs_clean
GROUP BY location
ORDER BY total_layoffs DESC
LIMIT 5; 

-- layoofs by Stage , TOP 5 
SELECT stage, SUM(total_laid_off) AS total_layoffs
FROM layoffs_clean
GROUP BY STAGE
ORDER BY total_layoffs DESC
LIMIT 5 ;


-- layoffs by month 
SELECT  MONTH(date) AS month , SUM(total_laid_off) AS totla_layoffs
FROM layoffs_clean
GROUP BY month 
ORDER BY totla_layoffs DESC;

-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;


/*
INSIGHTS FROM THE ANALYSIS :

Layoffs peaked in 2023, marking the highest number of layoffs in the dataset — a clear post-pandemic market correction phase.

A steady rise in layoffs began in mid-2022, reflecting early signs of a global economic slowdown.

2020–2021 (pandemic period) showed moderate layoffs, but the impact accelerated post-COVID as companies adjusted their workforce sizes.

2024–2025 data indicates a recovery trend, with layoffs gradually declining month-over-month.

The first quarter (Jan–Mar) consistently records the highest layoff numbers, likely due to companies restructuring at the start of the fiscal year.

June and July months show relatively fewer layoffs — possibly because companies avoid large staffing changes mid-year.

Late-year layoffs (Oct–Dec) slightly increase again, reflecting budget realignments and end-of-year performance cuts.

The earliest layoffs recorded in 2019 were minimal, serving as a baseline before pandemic disruptions.

Seasonal trend: Layoffs show a cyclical pattern, peaking early each year and stabilizing toward mid-year.

Cumulative trend: The rolling total layoffs curve (using a window function) demonstrates sharp rises during 2022–2023 and plateaus by late 2025.
*/