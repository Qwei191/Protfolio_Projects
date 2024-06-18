## Data Cleaning
# First Look at the data

SELECT *
FROM netflix.netflix_full
LIMIT 100
;

## Looking for duplicate
SELECT *
FROM (SELECT *, 
ROW_NUMBER() OVER(PARTITION BY id) as row_num
FROM netflix.netflix_full) AS duplicate_table
WHERE row_num > 1
;

## Looking for NULL values

SELECT *
FROM netflix.netflix_full
WHERE country IS NULL
;

# seems like '' are used instead of NULL values

SELECT *
FROM netflix.netflix_full
WHERE country = ''
;


UPDATE netflix.netflix_full
SET country = 'Unknown'
WHERE country = ''
;



SELECT *
FROM netflix.netflix_full
WHERE type = ''
;


SELECT *
FROM netflix.netflix_full
WHERE name = ''
;


SELECT *
FROM netflix.netflix_full
WHERE creator = ''
;

UPDATE netflix.netflix_full
SET creator = 'Unknown'
WHERE creator = ''
;

SELECT *
FROM netflix.netflix_full
WHERE year = ''
;

SELECT *
FROM netflix.netflix_full
WHERE rating = ''
;


SELECT *
FROM netflix.netflix_full
WHERE genres = ''
;

UPDATE netflix.netflix_full
SET genres = 'Comedy, Romance, Life, Youth'
WHERE name = 'Hidden Love'
;


## Convert time into numeric values for future use

SELECT CONVERT(TRIM(REPLACE(time, ' min', '')), DECIMAL(3,0)) AS time_mim
FROM netflix.netflix_full
;



ALTER TABLE netflix.netflix_full 
ADD time_min DECIMAL(3,0) AS (CONVERT(TRIM(REPLACE(time, ' min', '')), DECIMAL(3,0)))
;

## EDA

## number of shows by year and type
 
SELECT type,
year,
COUNT(id) AS count
FROM netflix.netflix_full
GROUP BY type, year
ORDER BY type, year
;



SELECT year, 
rating,
COUNT(id)
FROM netflix.netflix_full
GROUP BY rating, year
ORDER BY year, rating
;


SELECT year,
AVG(time_min) AS avg_length_min
FROM netflix.netflix_full
GROUP BY year
;


SELECT country, COUNT(id) AS count
FROM netflix.netflix_full
GROUP BY country
ORDER BY count DESC
;
