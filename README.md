Global Layoffs Analysis Using SQL (2019–2025)


Project Overview

This project explores worldwide company layoffs between 2019 and 2025, analyzing trends across industries, countries, company stages, and funding levels.
The goal is to perform end-to-end data cleaning, transformation, and exploratory data analysis (EDA) entirely using SQL (MySQL). This allows for deep insights into workforce reduction trends before, during, and after the pandemic.

Objectives

Data Cleaning & Preparation:

Remove duplicate records

Handle missing and null values

Standardize columns and text formats

Convert data types for analysis (dates, integers, decimals)

Exploratory Data Analysis (EDA):

Calculate total, average, minimum, and maximum layoffs

Identify top companies, industries, and countries impacted

Examine layoffs over time (monthly, yearly, rolling totals)

Analyze layoffs by company stage and funding

Insights Generation:

Identify patterns and trends in layoffs

Compare pre-pandemic and post-pandemic layoff scenarios

Understand seasonal or recurring workforce changes

Dataset

The dataset contains real-world records of layoffs from multiple companies worldwide.
Columns include:

company – Name of the company

location – City or region

industry – Industry category

total_laid_off – Number of employees laid off

percentage_laid_off – Percentage of workforce laid off

date – Date of layoff

stage – Company stage (Series A, Post-IPO, etc.)

country – Country of the company

funds_raised_in_dollars – Funding amount raised by the company

Tools & Skills Used

MySQL – for data cleaning, querying, and EDA

SQL Functions – GROUP BY, COUNT, SUM, MAX, MIN, DISTINCT, JOINs, CTEs, Window Functions

Data Cleaning Techniques – Handling nulls, duplicates, trimming, and type conversion

Problem-Solving & Analytical Skills – Extracting actionable insights from raw data

Workflow
1. Data Staging

Created a staging table to preserve raw data before cleaning.

Inserted all raw records into the staging table to maintain data integrity.

2. Data Cleaning

Removed duplicate records using GROUP BY and COUNT.

Standardized missing or blank values to NULL for easier calculations.

Trimmed unwanted characters (e.g., $ from funds raised).

Corrected inconsistent country names (e.g., “United States.” → “United States”).

Converted strings to proper data types (DATE, INT, DECIMAL).

3. Data Transformation

Renamed and cleaned columns (funds_raised → funds_raised_in_dollars).

Converted percentage and currency columns to numeric formats.

Populated null values wherever possible using existing company records.

4. Exploratory Data Analysis (EDA)

Total and average layoffs across all companies

Maximum and minimum layoffs

Number of companies with 100% workforce layoffs (complete shutdown)

Industry-wise, country-wise, and location-wise layoff analysis

Stage-wise layoffs and trends

Month-wise and year-wise trends with rolling totals

Key Insights

Post-pandemic layoffs (2023–2025) nearly doubled compared to 2020–2022.

Top impacted industries: Hardware, Consumer, Retail, Transportation.

Countries with highest layoffs: United States, India, Germany, United Kingdom, Netherlands.

Company stages: Post-IPO companies reported the most layoffs.

Seasonal trends: Q1 consistently sees higher layoffs; mid-year months are relatively stable.

Rolling total analysis: Highlights spikes during economic slowdowns and pandemic recovery periods.

Future Enhancements

Integrate visualizations using Python (Matplotlib/Seaborn) or Power BI.

Automate data ingestion from APIs to update layoffs dataset in real-time.

Include rehiring trends and recovery patterns to understand workforce stability.

Explore correlation with company funding, revenue, and other business metrics.

Author

Kapuram Kiran Kumar Reddy
📧 kirankapuram@gmail.com
🔗 www.linkedin.com/in/kiran-kapuram

