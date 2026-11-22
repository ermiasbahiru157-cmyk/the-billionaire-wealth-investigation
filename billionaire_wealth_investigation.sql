-- ============================================================================
-- SQL PROJECT: THE BILLIONAIRE WEALTH INVESTIGATION
-- ============================================================================

-- STEP 0: DATA CLEANING (Fixes hidden spaces in 'China ' & ' Brazil')
UPDATE "Top 200 Richest Person in the World"
SET country = TRIM(country),
    industry = TRIM(industry),
    name = TRIM(name);

-- Q1: Retrieve the 20 richest billionaires
SELECT rank, name, age, country, networth_billion_US_dollars, industry
FROM "Top 200 Richest Person in the World"
ORDER BY networth_billion_US_dollars DESC
LIMIT 20;

-- Q2: Identify the five youngest billionaires
SELECT name, age, country, networth_billion_US_dollars, industry
FROM "Top 200 Richest Person in the World"
ORDER BY age ASC, networth_billion_US_dollars DESC
LIMIT 5;

-- Q3: Calculate the average age and average net worth
SELECT 
    ROUND(AVG(age), 1) AS average_age,
    ROUND(AVG(networth_billion_US_dollars), 2) AS average_networth_billions
FROM "Top 200 Richest Person in the World";

-- Q4: Identify the five most represented countries
SELECT 
    country,
    COUNT(*) AS billionaire_count
FROM "Top 200 Richest Person in the World"
GROUP BY country
ORDER BY billionaire_count DESC
LIMIT 5;

-- Q5: Calculate the combined net worth of billionaires from each country
SELECT 
    country,
    COUNT(*) AS billionaire_count,
    ROUND(SUM(networth_billion_US_dollars), 2) AS combined_networth_billions
FROM "Top 200 Richest Person in the World"
GROUP BY country
ORDER BY combined_networth_billions DESC;

-- Q6: Identify the five industries with the highest number of billionaires
SELECT 
    industry,
    COUNT(*) AS billionaire_count
FROM "Top 200 Richest Person in the World"
GROUP BY industry
ORDER BY billionaire_count DESC
LIMIT 5;

-- Q7: Find countries with at least five billionaires
SELECT 
    country,
    COUNT(*) AS billionaire_count,
    ROUND(SUM(networth_billion_US_dollars), 2) AS combined_networth_billions
FROM "Top 200 Richest Person in the World"
GROUP BY country
HAVING COUNT(*) >= 5
ORDER BY billionaire_count DESC;

-- Q8: Calculate the total wealth of billionaires younger than 50
SELECT 
    COUNT(*) AS billionaires_under_50,
    ROUND(SUM(networth_billion_US_dollars), 2) AS total_wealth_billions
FROM "Top 200 Richest Person in the World"
WHERE age < 50;

-- Q9: Identify billionaires whose net worth exceeds the overall average net worth
SELECT 
    rank, name, country, industry, networth_billion_US_dollars
FROM "Top 200 Richest Person in the World"
WHERE networth_billion_US_dollars > (
    SELECT AVG(networth_billion_US_dollars) FROM "Top 200 Richest Person in the World"
)
ORDER BY networth_billion_US_dollars DESC;

-- Q10: Identify the industry with the highest average net worth
SELECT 
    industry,
    COUNT(*) AS billionaire_count,
    ROUND(AVG(networth_billion_US_dollars), 2) AS avg_networth_billions
FROM "Top 200 Richest Person in the World"
GROUP BY industry
ORDER BY avg_networth_billions DESC
LIMIT 1;

-- BONUS 1: Generational Wealth Breakdown across Age Brackets
SELECT 
    CASE 
        WHEN age < 40 THEN 'Under 40'
        WHEN age BETWEEN 40 AND 59 THEN '40 - 59'
        WHEN age BETWEEN 60 AND 79 THEN '60 - 79'
        ELSE '80 and Above'
    END AS age_bracket,
    COUNT(*) AS billionaire_count,
    ROUND(SUM(networth_billion_US_dollars), 2) AS total_wealth_billions
FROM "Top 200 Richest Person in the World"
GROUP BY age_bracket
ORDER BY total_wealth_billions DESC;

-- BONUS 2: #1 Richest Billionaire in Every Industry (Window Function)
WITH RankedIndustry AS (
    SELECT 
        industry, name, country, networth_billion_US_dollars,
        RANK() OVER (PARTITION BY industry ORDER BY networth_billion_US_dollars DESC) AS rnk
    FROM "Top 200 Richest Person in the World"
)
SELECT industry, name, country, networth_billion_US_dollars
FROM RankedIndustry
WHERE rnk = 1
ORDER BY networth_billion_US_dollars DESC;