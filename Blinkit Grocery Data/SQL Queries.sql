create database blinkitdb;

use blinkitdb;

select * from grocery;

select count(*) from grocery;

-- Data Cleaning

UPDATE grocery 
SET 
    item_fat_content = CASE
        WHEN item_fat_content IN ('LF' , 'low fat') THEN 'Low Fat'
        WHEN item_fat_content = 'reg' THEN 'Regular'
        ELSE item_fat_content
    END;

SELECT DISTINCT
    (item_fat_content)
FROM
    grocery;

-- 1. Total Sales: The overall revenue generated from all items sold.

SELECT 
    CONCAT(CAST(SUM(total_sales) / 1000000 AS DECIMAL (10 , 2 )),
            ' Million') AS Total_Sales_Millions
FROM
    grocery;

-- 2. Average Sale: The average revenue per sale

SELECT 
    ROUND(AVG(total_sales)) AS Avg_Sales
FROM
    grocery;

-- 3. Number of Items: The total count of diffrent item sold.

SELECT 
    item_type, COUNT(item_type) AS Total_Sold
FROM
    grocery
GROUP BY item_type
ORDER BY Total_Sold DESC;

-- 4. Average Rating: The average customer rating for item sold.

SELECT 
    item_type, ROUND(AVG(Rating), 1) AS Avg_Rating
FROM
    grocery
GROUP BY item_type
ORDER BY Avg_rating DESC;

-- 5. Total sales for "Low Fat" Category.

SELECT 
    item_fat_content,
    CAST(SUM(total_sales) / 1000000 AS DECIMAL (10 , 2 )) AS LF_Total_Sales_Million
FROM
    grocery
WHERE
    item_fat_content = 'Low Fat'
GROUP BY item_fat_content;

-- 6. Total sales, Average Sales, Total number of items, and Average Ratings for Each Category.

SELECT 
    item_fat_content,
    CONCAT(CAST(SUM(total_sales) / 1000000 AS DECIMAL (10 , 2 )),
            ' Million') AS Total_Sales,
    CAST(AVG(total_sales) AS DECIMAL (10 , 2 )) AS Avg_Sales,
    COUNT(*) AS number_of_items,
    CAST(AVG(rating) AS DECIMAL (10 , 2 )) AS Avg_Rating
FROM
    grocery
GROUP BY item_fat_content
ORDER BY Total_Sales DESC;

-- 7. Total sales, Average Sales, Total number of items, and Average Ratings for Each Item Type.

SELECT 
    item_type,
    CAST(SUM(total_sales) AS DECIMAL (10 , 2 )) AS Total_Sales,
    CAST(AVG(total_sales) AS DECIMAL (10 , 2 )) AS Avg_Sales,
    COUNT(*) AS number_of_items,
    CAST(AVG(rating) AS DECIMAL (10 , 2 )) AS Avg_Rating
FROM
    grocery
GROUP BY item_type
ORDER BY Total_Sales DESC;

-- 8. Fat Content by Outlet for Total Sales, Average Sales, Number of Items, and Average Ratings

SELECT 
    Outlet_Location_Type,
    SUM(CASE
        WHEN item_fat_content = 'Low Fat' THEN Total_Sales
        ELSE 0
    END) AS Low_Fat,
    SUM(CASE
        WHEN item_fat_content = 'Regular' THEN Total_Sales
        ELSE 0
    END) AS Regular
FROM
    grocery
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

-- 9. Total Sales, Average Sales, Number of Items, and Average Ratings by Outlet Establishment

SELECT 
    Outlet_Establishment_Year,
    CAST(SUM(total_sales) AS DECIMAL (10 , 2 )) AS Total_Sales,
    CAST(AVG(total_sales) AS DECIMAL (10 , 2 )) AS Avg_Sales,
    COUNT(*) AS number_of_items,
    CAST(AVG(rating) AS DECIMAL (10 , 2 )) AS Avg_Rating
FROM
    grocery
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year DESC;

-- 10. Percentage of sales by outlet size (Analyze the correlation between outlet size and total sales)

select 
	outlet_size,
    cast(sum(total_sales) as decimal (10,2)) as Total_Sales,
    cast((sum(total_sales) * 100.0 / sum(sum(total_sales)) over()) as decimal (10,2)) as Sales_Percentage
from grocery
group by Outlet_Size
order by total_sales desc;

-- 11. Sales by Outlet Location (Assess the geographic distribution of sales across different locations)

select Outlet_Location_Type, 
		cast(sum(total_sales) as Decimal(10,2)) as Total_Sales,
        cast(avg(total_sales) as Decimal(10,2)) as Avg_Sales,
        count(*) as number_of_items,
        cast((sum(total_sales) * 100.0 / sum(sum(total_sales)) over()) as decimal (10,2)) as Sales_Percentage,
        cast(avg(rating) as Decimal(10,2)) as Avg_Rating
from grocery
group by Outlet_Location_Type
order by total_sales desc;

-- 12. All Matrics by Outlet Type (Provide a comprehensive view of all key matrics (Total Sales, Average Sales, Number of Items, Average Rating) broken down by different outlet types)

select Outlet_Type, 
		cast(sum(total_sales) as Decimal(10,2)) as Total_Sales,
        cast(avg(total_sales) as Decimal(10,2)) as Avg_Sales,
        count(*) as number_of_items,
        cast((sum(total_sales) * 100.0 / sum(sum(total_sales)) over()) as decimal (10,2)) as Sales_Percentage,
        cast(avg(rating) as Decimal(10,2)) as Avg_Rating
from grocery
group by Outlet_Type
order by total_sales desc;