# Sales Analysis of ecommerce store to bring insights and data 
# Easy:
# 1. Total Sales Analysis: Calculate the total sales amount for the given dataset.
SELECT ROUND(SUM(Sales), 2) AS Total_Sales_To_Date FROM COM;

# Year on year sales
SELECT
	YEAR(ShipDate) as Year,
    SUM(Sales) as Sales
FROM  
	COM
GROUP BY 
	YEAR(Shipdate)
ORDER BY 
	YEAR;
# Month on Month Aggregate Sales
SELECT 
	MONTH(SHIPDATE ) AS MONTH, 
    SUM(SALES) AS SALES 
FROM 
	COM
GROUP BY 
	MONTH(SHIPDATE)
ORDER BY MONTH, SALES DESC;

# sales per month and year
SELECT 
	MONTH(SHIPDATE) AS MONTH,
	YEAR(SHIPDATE) AS YEAR,
    SUM(SALES) AS SALES 
FROM COM
GROUP BY 
	 MONTH, YEAR
ORDER BY 
	MONTH;
# Aggregate sales quarter on quarter
WITH CTE AS (
SELECT 
	(CASE 
		WHEN MONTH(SHIPDATE) IN (4,5,6) THEN 'QTR1'
        WHEN MONTH(SHIPDATE) IN (7, 8, 9) THEN 'QTR2'
        WHEN MONTH(SHIPDATE) IN (10, 11, 12) THEN 'QTR3'
        ELSE 'QTR4' END )
        AS QTR,
        SUM(SALES) AS SALES
        FROM COM
	GROUP BY 
		QTR )
	SELECT 
		QTR, SALES
	FROM CTE
    GROUP BY 
		QTR
	ORDER BY 
		QTR;
        
# Sales per year quarter on quarter
 WITH CTE AS (
	SELECT 
		(CASE
			WHEN MONTH(SHIPDATE) IN (4,5,6) THEN 'QTR1'
			WHEN MONTH(SHIPDATE) IN (7,8,9) THEN 'QTR2'
            WHEN MONTH(SHIPDATE) IN (10, 11, 12) THEN 'QTR3'
            ELSE 'QTR4' END ) AS QTR,
        YEAR(SHIPDATE) AS YEAR,
        SUM(SALES) AS SALES
FROM COM
GROUP BY QTR, YEAR
 )
 SELECT 
	QTR, 
    YEAR, 
    SALES
    FROM CTE
ORDER BY 
	YEAR, QTR;
    
# 2. Order Priority Analysis: Determine the distribution of orders based on their priority (e.g., high, medium, low).
# Priority in aggregate
SELECT 
	OrderPriority, 
    count(*) as Count
    FROM COM
GROUP BY 
	ORDERPRIORITY;

# Change in priority yearwise
SELECT 
	ORDERPRIORITY, 
    YEAR(SHIPDATE) AS YEAR,
    COUNT(*) AS COUNT
FROM COM 
GROUP BY 
	YEAR(SHIPDATE), ORDERPRIORITY
ORDER BY 
	YEAR DESC;
    
# 3. Product Category Analysis: Identify the most popular product categories based on the number of orders.
SELECT 	
	PRODUCTCATEGORY,
    COUNT(*) AS COUNT 
    FROM COM
GROUP BY 
	PRODUCTCATEGORY
ORDER BY 
	COUNT DESC;

# Yearwise change
SELECT 
	YEAR(SHIPDATE) AS YEAR, 
    PRODUCTCATEGORY,
    COUNT(*) AS COUNT
FROM
	COM
GROUP BY 
	YEAR(SHIPDATE), 
    PRODUCTCATEGORY
ORDER BY 
	YEAR;
    
# 4. Segment Analysis: Analyze the distribution of customers across different segments & purchase power. (e.g., consumer, corporate, home office).
SELECT 
	COUNT(*) COUNT,
    SEGMENT,
    ROUND(AVG(SALES), 2) AVGORDERVALUE
FROM 
	COM
GROUP BY 
	SEGMENT
ORDER BY COUNT DESC, AVGORDERVALUE DESC;

# 5. Region-wise Sales: Calculate the total sales amount for each region represented in the dataset.
SELECT 
	SUM(SALES) SALES,
    COUNTRY, STATE, CITY
FROM 
	COM
GROUP BY 
	COUNTRY, STATE, CITY
ORDER BY 
	SALES DESC;
	
# 6. Average Shipping Days: Calculate the average shipping days for all orders.
# for each order
SELECT 
	SHIPDATE, ORDERDATE,
   MIN(DATEDIFF(SHIPDate, ORDERDate)) AS AverageShippingDays
FROM 
    COM
GROUP BY 
	ORDERDATE, SHIPDATE
    ORDER BY 
    AverageShippingDays;
# for all orders
SELECT 
	AVG(DATEDIFF(SHIPDATE, ORDERDATE)) AVGDAYS
    FROM COM;
    
    
# Intermediate:
# 1. Profit Margin Analysis: Calculate the profit margin (profit/sales) for each order and analyze the distribution.
SELECT 
    year(shipdate) YEAR,
    SEGMENT,
    ROUND(SUM(Profit)/ SUM(Sales) *100, 2) AS PROFITMARGIN
FROM 
   COM
GROUP BY SEGMENT, YEAR(shipdate)
ORDER BY 
	SEGMENT, YEAR(SHIPDATE) DESC;

# 2. Order Delay Analysis: Determine the average delay in days between the order date and the ship date.
SELECT 
    AVG(DATEDIFF(SHIPDATE, ORDERDATE)) AS DATEDIFFERANCE
FROM 
	COM
    ORDER BY DATEDIFFERANCE DESC;

#3. Discount Impact Analysis: Analyze the impact of discounts on sales and profit margins.
# Sum of sales total discount given and average discount percent
WITH CTE AS (
SELECT 
	PRODUCT,
    AVG(DISCOUNT) AVGDISC,
	SUM(SALES) SALES,
    SUM(DISCOUNT) DISCOUNT
    FROM COM
    GROUP BY PRODUCT
)
SELECT 
	PRODUCT,
	SALES, 
    DISCOUNT,
    AVGDISC
FROM 
	CTE;

# average sales and profit margins
SELECT 
    AVG(Sales) AS AVGSALES,
    AVG(Profit / Sales) AS AVGPROFITDISC
FROM 
    COM 
WHERE 
    Discount > 0;
    
# Average sales, discount , discounted amount and sales witout discount
SELECT 
	AVG(SALES) SALES, 
    AVG(DISCOUNT) DISCOUNT,
    round ((AVG(SALES) * AVG(DISCOUNT) /100), 2) AS DISCAMOUNT,
    round((AVG(SALES) + (AVG(SALES) * AVG(DISCOUNT) /100)), 2) AVGSALELESSDISCOUNT 
    FROM COM;

# 4. Customer Loyalty Analysis: Identify repeat customers based on the frequency of their orders.
SELECT 
	ORDERID,
    COUNT(*) COUNT FROM COM
GROUP BY
	ORDERID
ORDER BY 
	COUNT DESC;
    
# repeat percentage of customer
SELECT 
    COUNT(DISTINCT CustomerID) AS RepeatCustomers,
    COUNT(DISTINCT CustomerID) * 100.0 / COUNT(DISTINCT CASE WHEN OrderFrequency = 1 THEN CustomerID END) AS RepeatCustomerPercentage
FROM 
    (SELECT 
        CustomerID,
        COUNT(*) AS OrderFrequency
    FROM 
        com
    GROUP BY 
        CustomerID) AS CustomerOrders;

# 5. Shipping Cost Analysis: Determine the distribution of shipping costs across different shipping modes.
SELECT count(*), 
shipmode
from com
group by shipmode;

# 6. Product Performance Analysis: Identify top-performing products based on sales and profit.
SELECT 
	PRODUCT,
    ROUND(SUM(SALES), 2) SALES,
    ROUND(SUM(PROFIT), 2) PROFIT
FROM 
	COM
GROUP BY 
	PRODUCT
ORDER BY 
	SUM(PROFIT) DESC;

### Hard:
# 1. Time Series Analysis: Analyze the sales trend over time (daily, monthly) and identify any seasonality or trends.
# Aggregate to date
SELECT 
	SUM(SALES) SALES, 
    MONTH(SHIPDATE) month
    FROM COM
GROUP BY 
	MONTH(SHIPDATE)
ORDER BY 
	MONTH(SHIPDATE) ASC;
    
# Yearly sales 
SELECT 
	 SUM(SALES) SALES, 
     YEAR(SHIPDATE) YEAR , 
     MONTH(SHIPDATE) MONTH
FROM 
	COM
GROUP BY 
	YEAR(SHIPDATE), 
    MONTH(SHIPDATE)
ORDER BY 
	YEAR(SHIPDATE),
    MONTH(SHIPDATE);

# Aggregate sales per day
SELECT 
	SUM(SALES) SALES, 
    DAY(SHIPDATE) DAY
FROM 
	COM
GROUP BY 
	DAY 
ORDER BY 
	SALES DESC ;

# Daily sales
SELECT 
    OrderDate,
    SUM(Sales) AS DailySales
FROM 
   com
GROUP BY 
    OrderDate
ORDER BY 
    OrderDate;
# monthaly sales
SELECT 
    extract(month from OrderDate) AS Month,
    SUM(Sales) AS MonthlySales
FROM 
    com
GROUP BY 
     extract(month from OrderDate) 
ORDER BY 
     extract(month from OrderDate) ;

# Month on mont sales
SELECT 
	YEAR(ORDERDATE) AS YEAR, 
    MONTH(ORDERDATE) AS MONTH, 
    SUM(SALES) AS SALES
FROM 
	COM 
GROUP BY 
	YEAR(ORDERDATE),
    MONTH(ORDERDATE)
ORDER BY 
	MONTH, YEAR;

# 2. Customer Segmentation: Segment customers based on their purchasing behavior and demographics, and analyze their contribution to sales.
SELECT 
	COUNT(*) CUSTOMERCOUNT,
    CASE WHEN SALES > 15000 THEN 'HIGH VALUE'
			WHEN SALES BETWEEN 10000 AND 15000 THEN 'MEDIUM VALUE'
            ELSE 'LOW VALUE' END AS CUSTOMER, 
            SUM(SALES) TOTALSALES
FROM COM
GROUP BY CUSTOMER
ORDER BY TOTALSALES DESC;

# 3. Geospatial Analysis: Visualize the distribution of sales on a map and analyze any regional patterns.
#Sales per country
SELECT 
	COUNTRY,
    COUNT(*) ORDERCOUNT,
    SUM(SALES) SALES
FROM 
	COM
GROUP BY 
	COUNTRY
ORDER BY 
	SALES DESC;

# Sales per state
SELECT 
    STATE,
    COUNT(*) ORDERCOUNT, 
    SUM(SALES) SALES
FROM 
	COM 
GROUP BY 
	STATE
ORDER BY 
	SALES DESC;

# Sales per city
SELECT 
    CITY, 
    COUNT(*) COUNT,
    SUM(SALES) SALES
    FROM COM
    GROUP BY CITY
    ORDER BY SALES DESC;
    
# Sales per region
SELECT 
	REGION, 
    COUNT(*) COUNT,
    SUM(SALES) SALES
FROM COM
GROUP BY REGION 
ORDER BY SALES DESC;

# Sales per region, country, state, city
WITH CTE AS(
SELECT 
	REGION, 
    COUNTRY,
    STATE, 
    CITY,
    COUNT(*) COUNT,
    SUM(SALES) SALES
FROM COM
GROUP BY
	REGION, 
	COUNTRY, 
    STATE, 
    CITY
ORDER BY SALES DESC)
SELECT *, 
	(COUNT *100/(select count(*) from cte) )PERCENT
FROM CTE
GROUP BY 
	REGION, COUNTRY, STATE, CITY;

# 4. Predictive Analysis: Build a predictive model to forecast future sales based on historical data and other relevant factors.
# Based on year on year growth percent
SELECT 
    EXTRACT(YEAR FROM OrderDate) AS Year,
    SUM(Sales) AS TotalSales,
    (SUM(Sales) - LAG(SUM(Sales), 1) OVER (ORDER BY EXTRACT(YEAR FROM OrderDate))) * 100.0 /
    NULLIF(LAG(SUM(Sales), 1) OVER (ORDER BY EXTRACT(YEAR FROM OrderDate)), 0) AS YoYGrowthPercent
FROM 
    COM
GROUP BY 
    EXTRACT(YEAR FROM OrderDate)
ORDER BY 
    EXTRACT(YEAR FROM OrderDate);


# 5. Supply Chain Optimization: Optimize shipping strategies to minimize shipping costs while maintaining delivery efficiency.
# Shipping details & prview on numbers
SELECT 
	round(AVG(shippingcost), 2) as cost,
	avg(shippingdays) days, 
    shipmode
from com
group by shipmode
order by COST, DAYS;

# Shipping details
select 
	shipdate, shipmonth, shippingdays, shipmode, product, sales, profit, shippingcost, segment, country 
from com
order by shippingcost desc;

# Segment wise shipping cost
SELECT 
	SUM(PROFIT) PROFIT, 
    SUM(SHIPPINGCOST) COST, 
    SUM(SALES) SALES, 
    SEGMENT 
FROM COM 
GROUP BY SEGMENT
ORDER BY COST DESC;

# Country wise shipping cost
SELECT 
	SUM(PROFIT) PROFIT, 
    SUM(SHIPPINGCOST) COST, 
    SUM(SALES) SALES, 
    country
FROM COM 
GROUP BY country
ORDER BY COST DESC;

# 6. Market Basket Analysis:	
SELECT 
	SUM(SALES) SALES, 
    PRODUCTCATEGORY
    FROM COM
GROUP BY 
	PRODUCTCATEGORY
ORDER BY 
	SALES DESC;

# PRODUCT WISE SALES
SELECT 
	PRODUCT, 
    PRODUCTCATEGORY,
    SUM(SALES) SALES
FROM COM
GROUP BY 
	PRODUCT, PRODUCTCATEGORY
ORDER BY 
	SALES DESC;

SELECT * FROM COM;
    
