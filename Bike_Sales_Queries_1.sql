-- Author: Olivier Vadiavaloo

-- Bike Sales Dataset
-- Source: https://www.kaggle.com/datasets/sadiqshah/bike-sales-in-europe

-- (1)
-- Find the number of customers by region/country. Order results in ascending
-- alphabetical order.
SELECT Country, COUNT(*) AS [No. Of Customers]
FROM BikeSalesDB..bike_sales
GROUP BY Country
ORDER BY 1


-- (2)
-- Find the sum of revenue
SELECT SUM(Revenue) AS [Sum of Revenue]
FROM BikeSalesDB..bike_sales


-- (3)
-- Find the sum of revenue by region/country. Order results in ascending
-- alphabetical order.
SELECT Country, SUM(Revenue) AS [Sum of Revenue]
FROM BikeSalesDB..bike_sales
GROUP BY Country
ORDER BY 1


-- (4)
-- Find the sum of discounts.
SELECT SUM((Order_Quantity * Unit_Price) - Revenue) AS [Sum of Discounts]
FROM BikeSalesDB..bike_sales


-- (5)
-- Find the sum of discounts by region/country.
SELECT Country, SUM((Order_Quantity * Unit_Price) - Revenue) AS [Sum of Discounts]
FROM BikeSalesDB..bike_sales
GROUP BY Country
ORDER BY 1


-- (6)
-- Find the sum of profit.
SELECT SUM(Profit) AS [Sum of Profit]
FROM BikeSalesDB..bike_sales


-- (7)
-- Find the sum of profit by region/country.
SELECT Country, SUM(Profit) AS [Sum of Profit]
FROM BikeSalesDB..bike_sales
GROUP BY Country
ORDER BY 1


-- (8)
-- Find the sum of items sold.
SELECT SUM(Order_Quantity) AS [Sum of Units Sold]
FROM BikeSalesDB..bike_sales


-- (9)
-- Find the sum of items sold by country.
SELECT Country, SUM(Order_Quantity) AS [Sum of Units Sold]
FROM BikeSalesDB..bike_sales
GROUP BY Country
ORDER BY 1


-- (10)
-- Find the average number of units sold per customer.
SELECT ROUND(AVG(Order_Quantity), 3) AS [Avg Number of Units Sold By Customer]
FROM BikeSalesDB..bike_sales


-- (11)
-- Find the net revenue by category
SELECT Product_Category, SUM(Profit) AS [Net Revenue]
FROM BikeSalesDB..bike_sales
GROUP BY Product_Category


-- (12)
-- Find the top 5 most sold items
SELECT TOP(5) Product, SUM(Order_Quantity) AS [Sum of Units Sold]
FROM BikeSalesDB..bike_sales
GROUP BY Product
ORDER BY 2 DESC


-- (13)
-- Find the percentage of units sold of each category per country.
WITH sum_units_sold_coun_cat AS (
	SELECT Country, SUM(Order_Quantity) AS Total_Sold
	FROM BikeSalesDB..bike_sales
	GROUP BY Country
)
SELECT bsales.Country, bsales.Product_Category, 
	   ROUND(SUM(bsales.Order_Quantity) / coun_cat.Total_Sold, 5) AS [Perc of Units Sold]
FROM BikeSalesDB..bike_sales bsales INNER JOIN 
	 sum_units_sold_coun_cat coun_cat
	 ON bsales.Country = coun_cat.Country
GROUP BY bsales.Country, bsales.Product_Category, coun_cat.Total_Sold
ORDER BY 1, 2


-- (14)
-- Find the number of units sold by year
SELECT Year, SUM(Order_Quantity)
FROM BikeSalesDB..bike_sales
GROUP BY Year
ORDER BY 1


-- (15)
-- Find the most sold product for each age group
WITH product_quant_by_age AS (
	SELECT Age_Group, Product, SUM(Order_Quantity) AS Order_Quantity
	FROM BikeSalesDB..bike_sales
	GROUP BY Age_Group, Product
),
max_quant_by_age AS (
	SELECT Age_Group, MAX(Order_Quantity) AS Max_Order_Quant
	FROM product_quant_by_age
	GROUP BY Age_Group
)
SELECT pqba.Age_Group AS [Age Group], 
	   pqba.Product AS [Most Sold Product], 
	   pqba.Order_Quantity AS [Units Sold]
FROM product_quant_by_age pqba INNER JOIN
	 max_quant_by_age mqba ON
	 pqba.Age_Group = mqba.Age_Group AND
	 pqba.Order_Quantity = mqba.Max_Order_Quant


-- (16)
-- Find the TOP 3 products for each age group in terms of revenue.
WITH product_rev_by_age AS (
	SELECT Age_Group, Product, SUM(Revenue) AS Revenue
	FROM BikeSalesDB..bike_sales
	GROUP BY Age_Group, Product
),
top_three_prod AS (
	SELECT Age_Group, Product, Revenue,
		   RANK() OVER (PARTITION BY Age_Group ORDER BY Revenue DESC) Rev_Rank
	FROM product_rev_by_age
)
SELECT Age_Group AS [Age Group],
	   Product,
	   Rev_Rank AS [Revenue Rank],
	   Revenue
FROM top_three_prod
WHERE Rev_Rank < 4