## Data Cleaning
# First Look at the data

SELECT * 
FROM retail.new_retail_data
LIMIT 100
;

# Looking for duplication
SELECT *
FROM (SELECT *, 
ROW_NUMBER() OVER(PARTITION BY Transaction_ID,Customer_ID) as row_num
FROM retail.new_retail_data) AS duplicate_table
WHERE row_num > 1
;


# Remove duplicate

DELETE FROM retail.new_retail_data
WHERE Transaction_ID IN (
	SELECT Transaction_ID
	FROM (SELECT *, 
		ROW_NUMBER() OVER(PARTITION BY Transaction_ID,Customer_ID) as row_num
		FROM retail.new_retail_data) AS duplicate_table
	WHERE row_num > 1
)
;

# Standardize Data

## remove .0 at the end of Phone number

SELECT REPLACE(Phone, '.0',''),
Phone
FROM retail.new_retail_data
;

UPDATE retail.new_retail_data
SET Phone = REPLACE(Phone, '.0','')
;



## Convert Date into datetime format

SELECT  CAST(CONCAT(STR_TO_DATE(Date,'%m/%d/%Y'),' ' , Time) AS datetime)
FROM retail.new_retail_data
;


ALTER TABLE retail.new_retail_data
ADD Date_1 datetime AS (CAST(CONCAT(STR_TO_DATE(Date,'%m/%d/%Y'),' ' , Time) AS datetime))
;


# EDA

SELECT * 
FROM retail.new_retail_data
LIMIT 100
;

## Purchases made By month
SELECT Month,
SUM(Total_Purchases)
FROM retail.new_retail_data
WHERE Month != '0'
GROUP BY Month
;

## Purchases made By year

SELECT Year,
SUM(Total_Purchases)
FROM retail.new_retail_data
WHERE Year != '0'
GROUP BY Year
;


## How Customer Segment affect the purchasing behavior
SELECT Customer_Segment,
AVG(Total_Amount) AS avg_expenditure,
COUNT(Customer_Segment) AS num_purchase,
COUNT(DISTINCT Customer_ID) AS distinct_customer,
COUNT(Customer_Segment)/COUNT(DISTINCT Customer_ID) AS avg_purchase_per_customer
FROM retail.new_retail_data
WHERE Customer_Segment != '0'
GROUP BY Customer_Segment
;


## Factor affect rating

SELECT Order_Status,
AVG(Ratings)
FROM retail.new_retail_data
WHERE Order_Status != '0' AND Ratings != 0
GROUP BY Order_Status
;

SELECT Shipping_Method,
AVG(Ratings)
FROM retail.new_retail_data
WHERE Shipping_Method != '0' AND Ratings != 0
GROUP BY Shipping_Method
;



SELECT Product_Type,
AVG(Ratings) AS avg_rating
FROM retail.new_retail_data
WHERE Product_Type != '0' AND Ratings != 0
GROUP BY Product_Type
ORDER BY avg_rating DESC
;

SELECT Gender,
AVG(Ratings) AS avg_rating
FROM retail.new_retail_data
WHERE Gender != '0' AND Ratings != 0
GROUP BY Gender
ORDER BY avg_rating DESC
;


SELECT Country,
AVG(Ratings) AS avg_rating
FROM retail.new_retail_data
WHERE Country != '0' AND Ratings != 0
GROUP BY Country
ORDER BY avg_rating DESC
;

SELECT Payment_Method,
AVG(Ratings) AS avg_rating
FROM retail.new_retail_data
WHERE Payment_Method != '0' AND Ratings != 0
GROUP BY Payment_Method
ORDER BY avg_rating DESC
;

SELECT Product_Brand,
AVG(Ratings) AS avg_rating
FROM retail.new_retail_data
WHERE Product_Brand != '0' AND Ratings != 0
GROUP BY Product_Brand
ORDER BY avg_rating DESC
;