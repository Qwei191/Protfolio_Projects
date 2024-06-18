# World Life Expectancy Data (Data Cleaning)


SELECT * 
FROM world_life_expectancy.world_life_expectancy
;


# find missing data at first glance
# start by removing duplicate
# there should be only one country-year conbination, use that to identify duplicate

SELECT Country, Year, concat(Country,Year) ,count(concat(Country,Year))
FROM world_life_expectancy.world_life_expectancy
group by Country, Year, concat(Country,Year)
having count(concat(Country,Year)) > 1
;

select Row_ID,
 concat(Country,Year),
 row_number() over( partition by concat(Country,Year)) as row_num
from world_life_expectancy
;

select *
from (
	select Row_ID,
	concat(Country,Year),
	row_number() over( partition by concat(Country,Year)) as row_num
	from world_life_expectancy) as row_table
where row_num > 1
;

DELETE FROM world_life_expectancy
WHERE Row_ID IN (
select row_ID
from (
	select Row_ID,
	concat(Country,Year),
	row_number() over( partition by concat(Country,Year)) as row_num
	from world_life_expectancy) as row_table
where row_num > 1
)
;


# working with missing data, starts with status

SELECT *
FROM world_life_expectancy.world_life_expectancy
where Status = ''
;


SELECT distinct country
from world_life_expectancy
where Status = 'Developing'
;


update world_life_expectancy
set status = 'Developing'
where country in (
SELECT distinct country
from world_life_expectancy
where Status = 'Developing')
;

update world_life_expectancy as t1
join world_life_expectancy as t2
	on t1.country = t2.country
set t1.status = 'Developing'
Where t1.status = ''
and t2.status != ''
and t2.status = 'Developing'
;


update world_life_expectancy as t1
join world_life_expectancy as t2
	on t1.country = t2.country
set t1.status = 'Developed'
Where t1.status = ''
and t2.status != ''
and t2.status = 'Developed'
;

# now life expectancy

SELECT * 
FROM world_life_expectancy.world_life_expectancy
where `Life expectancy` = ''
;

SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy.world_life_expectancy
where `Life expectancy` = ''
;


SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
round((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy.world_life_expectancy as t1
join world_life_expectancy.world_life_expectancy as t2
	on t1.Country = t2.Country
    and t1.Year = t2.Year - 1
join world_life_expectancy.world_life_expectancy as t3
	on t1.Country = t3.Country
    and t1.Year = t3.Year + 1
where t1.`Life expectancy` = ''
;


update world_life_expectancy as t1
join world_life_expectancy.world_life_expectancy as t2
	on t1.Country = t2.Country
    and t1.Year = t2.Year - 1
join world_life_expectancy.world_life_expectancy as t3
	on t1.Country = t3.Country
    and t1.Year = t3.Year + 1
set t1.`Life expectancy` = round((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
where t1.`Life expectancy` = '' 
;



