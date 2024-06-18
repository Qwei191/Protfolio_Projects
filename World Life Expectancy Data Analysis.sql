# World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM world_life_expectancy
;


SELECT Country,
MIN(`Life expectancy`),
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`)) AS Life_increase_15_years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) != 0
AND MAX(`Life expectancy`) != 0
ORDER BY Life_increase_15_years ASC
;



SELECT Year, 
ROUND(AVG(`Life expectancy`),2) AS Life_exp
FROM world_life_expectancy
WHERE `Life expectancy` > 0
AND GDP > 0
GROUP BY Year
ORDER BY Year
;



SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS Life_exp,
AVG(GDP)
FROM world_life_expectancy
WHERE GDP > 0 AND `Life expectancy` > 0
GROUP BY Country
ORDER BY  AVG(GDP) DESC
;

SELECT SUM(
CASE 
	WHEN GDP >= 1500 THEN 1
    ELSE 0
    END) AS High_GDP_count,
AVG(CASE 
		WHEN GDP >= 1500 THEN `Life expectancy`
		ELSE NULL
		END) AS High_GDP_Life_expectancy,
SUM(CASE 
		WHEN GDP <= 1500 THEN 1
		ELSE 0
		END) AS Low_GDP_count,
AVG(CASE 
		WHEN GDP <= 1500 THEN `Life expectancy`
		ELSE NULL
		END) AS Low_GDP_Life_expectancy
FROM world_life_expectancy
;


SELECT Status,
ROUND(AVG(`Life expectancy`),1),
COUNT(DISTINCT Country),
AVG(GDP)
FROM world_life_expectancy
GROUP BY Status
;


SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS Life_exp,
ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
WHERE BMI > 0 AND `Life expectancy` > 0
GROUP BY Country
ORDER BY  BMI  
;


# Rolling Total
SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;

