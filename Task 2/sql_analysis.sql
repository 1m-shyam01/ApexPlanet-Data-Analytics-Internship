CREATE TABLE dataset(
Order_ID VARCHAR(30),
Order_Date DATE,
Customer_ID VARCHAR(30),
Customer_Name VARCHAR(40),
Age	INT,
Gender VARCHAR(8),
City VARCHAR(20),
Product VARCHAR(20),
Category VARCHAR(20),
Quantity INT,
Unit_Price NUMERIC(10,2),
Total_Sales NUMERIC(12,2),
Month_name CHAR(10),
Day_name CHAR(10)
);

ALTER TABLE dataset
ADD COLUMN age_group VARCHAR(10);

UPDATE dataset
SET age_group =
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        WHEN age BETWEEN 56 AND 65 THEN '56-65'
        WHEN age >= 66 THEN '66+'
    END;

--What is the total sales generated overall?
SELECT SUM(	total_sales) AS Overall_Sales
FROM dataset;

--What is the total number of orders?
SELECT COUNT(Order_ID) AS Total_orders
FROM dataset;

--What is the total quantity of products sold?
SELECT SUM(Quantity) AS Total_quantity
FROM dataset;

--What is the average sales value per order?
SELECT 
    ROUND(AVG(total_sales),2) AS average_sales_per_order
FROM dataset;

--What is the monthly total sales?
SELECT Month_name, SUM(Total_Sales) AS Total_Sales
FROM dataset
GROUP BY Month_name;

--What is the monthly total number of orders?
SELECT Month_name, COUNT(Order_id) AS Total_Order
FROM dataset
GROUP BY Month_name;

--Which are the Top 5 products based on total sales?
SELECT Product, SUM(Total_Sales) AS Total_Sales
FROM dataset
GROUP BY Product 
ORDER By Total_Sales DESC
LIMIT 5;

--Which are the Top 5 products based on quantity sold?
SELECT Product, SUM(Quantity) AS Total_Quantity
FROM dataset
GROUP BY Product 
ORDER By Total_Quantity DESC
LIMIT 5;

--Which product has the highest unit price?
SELECT Product, MAX(Unit_Price) AS Unit_Price
FROM dataset
GROUP BY Product
ORDER BY Unit_Price DESC
LIMIT 1;

--Which products generate high sales despite having a relatively low unit price?
SELECT Product,
    ROUND(AVG(Unit_Price),2) AS Avg_Unit_Price,
    SUM(Total_Sales) AS Total_Sales
FROM dataset
GROUP BY Product
HAVING AVG(Unit_Price) < (SELECT AVG(Unit_Price) FROM dataset)
   AND SUM(Total_Sales) > (SELECT AVG(Total_Sales) FROM dataset)
ORDER BY Total_Sales DESC;

--Which product category generates the highest total sales?
SELECT Category,
    SUM(Total_Sales) AS Total_Sales
FROM dataset
GROUP BY Category
ORDER BY Total_Sales DESC
LIMIT 1;

--Which product category has the highest quantity sold?
SELECT Category,
    SUM(Quantity) AS Total_Quantity
FROM dataset
GROUP BY Category
ORDER BY Total_Quantity DESC
LIMIT 1;

--Which city generates the highest total sales?
SELECT City,
    SUM(Total_sales) AS Total_Sales
FROM dataset
GROUP BY City
ORDER BY Total_Sales DESC
LIMIT 1;

--What is the total sales contribution of each city?
SELECT City,
    SUM(Total_sales) AS Total_Sales
FROM dataset
GROUP BY City
ORDER BY Total_Sales DESC;

--How do total sales differ by gender?
SELECT Gender,
    SUM(Total_sales) AS Total_Sales
FROM dataset
GROUP BY Gender
ORDER BY Total_Sales DESC;

--Which gender has the higher average sales per order?
SELECT Gender,
    ROUND(SUM(Total_sales)/COUNT(ORDER_ID),2) AS avg_Sales
FROM dataset
GROUP BY Gender
ORDER BY avg_Sales DESC;

--What is the average age of customers?
SELECT ROUND(AVG(Age),2) AS Avg_Age
FROM dataset;

--Which age group generates the highest sales?
SELECT age_group,
    SUM(Total_sales) AS Total_Sales
FROM dataset
GROUP BY age_group
ORDER BY Total_Sales DESC;

--Which city has the highest number of orders?
SELECT City,
    COUNT(Order_ID) AS Total_Order
FROM dataset
GROUP BY City
ORDER BY Total_Order DESC
LIMIT 1;

--Which category has the highest average unit price?
SELECT Category,
    ROUND(AVG(Unit_Price),2) AS Unit_Price
FROM dataset
GROUP BY Category
ORDER BY Unit_Price DESC
LIMIT 1;

--Which products have total sales above the overall average sales?
SELECT Product, Customer_ID, 
	SUM(Total_Sales) AS Total_Sales
FROM dataset
GROUP BY Product,Customer_ID
HAVING  SUM(Total_Sales)>(SELECT AVG(Total_Sales) FROM dataset)
ORDER BY Total_SaleS DESC;

--Which months generated sales above the average monthly sales?
SELECT Month_name, 
	SUM(Total_Sales) AS Total_Sales
FROM dataset
GROUP BY Month_name
HAVING  SUM(Total_Sales)>(SELECT AVG(Total_Sales) FROM dataset)
ORDER BY Total_SaleS DESC
LIMIT 1;

--Which cities generated sales above the average city sales?
SELECT City, 
	SUM(Total_Sales) AS Total_Sales
FROM dataset
GROUP BY City
HAVING  SUM(Total_Sales)>(SELECT AVG(Total_Sales) FROM dataset)
ORDER BY Total_SaleS DESC
LIMIT 1;
