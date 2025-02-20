create database pizzadb;

use pizzadb;

-- imported pizzas and pizza_types table

-- creating orders file to get the correct data type

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

-- imported the orders data

-- creating order_details file to get the correct data type

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

-- imorted the order_details data

-- Questions

-- 1. Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS Total_Orders
FROM
    orders;

-- 2. Calculate the total revenue generated from pizza sales.

SELECT 
    CAST(SUM(od.quantity * p.price) AS DECIMAL (10 , 2 )) AS Total_Revenue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;
    
-- 3. Identify the highest-priced pizza.

SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- 4. Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(od.order_details_id) as Most_Common_Size
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY Most_common_Size DESC
LIMIT 1;

-- 5. List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.name, SUM(od.quantity) AS Total_quantity
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY Total_quantity DESC
LIMIT 5;

-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, SUM(od.quantity) AS Total_Quantity_Ordered
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY Total_Quantity_Ordered DESC;

-- 7. Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS Hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY hour
ORDER BY order_count DESC;

-- 8. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name) AS Total_Pizzas
FROM
    pizza_types
GROUP BY category
ORDER BY Total_Pizzas DESC;

-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    CAST(AVG(Total_Orders) AS DECIMAL (10.2)) AS Avg_Orders_Per_Day
FROM
    (SELECT 
        CAST(SUM(od.quantity) AS DECIMAL (10 , 2 )) AS Total_Orders
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date
    ORDER BY Total_orders DESC) AS order_quantity;
    
-- 10. Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name,
    CAST(SUM(od.quantity * p.price) AS DECIMAL (10 , 2 )) AS Total_Revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Total_Revenue DESC
LIMIT 3;

-- 11. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category,
    ROUND(CAST(SUM(od.quantity * p.price) AS DECIMAL (10 , 2 )) / (SELECT 
                    SUM(od.quantity * p.price)
                FROM
                    pizza_types pt
                        JOIN
                    pizzas p ON pt.pizza_type_id = p.pizza_type_id
                        JOIN
                    order_details od ON p.pizza_id = od.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC;

-- 12. Analyze the cumulative revenue generated over time.

select order_date, round(sum(revenue) over (order by order_date),2) as cum_revenue
from
(select o.order_date, sum(od.quantity*p.price) as revenue
from order_details od join pizzas p
on od.pizza_id = p.pizza_id
join orders o
on o.order_id = od.order_id
group by o.order_date) as sales;

-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category, name, revenue from
(select category, name, revenue, 
rank() over(partition by category order by revenue desc) as top from
(select pt.name, pt.category, round(sum(od.quantity*p.price),2) as revenue 
from order_details od join pizzas p
on od.pizza_id = p.pizza_id
join pizza_types pt
on pt.pizza_type_id = p.pizza_type_id
group by pt.category, pt.name) as sales) as rank_find
where top<=3;