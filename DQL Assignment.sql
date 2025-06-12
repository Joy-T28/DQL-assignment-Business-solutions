--1. SALES REPS AND THEIR REGIONS
SELECT
    accounts.name AS Account_name,
    sales_reps.name AS sales_rep_name,
	region.name AS region_name
FROM 
    accounts
JOIN
    sales_reps ON  accounts.sales_rep_id = sales_reps.id
JOIN  
   region ON  sales_reps.region_id = region_id
ORDER BY 
      account_name ASC;


--2.  Unit Price Paid Per Order
SELECT 
    orders.id, 
     region.name AS region_name, 
     accounts.name AS account_name, 
	 CASE
WHEN   
    orders.total > 0 THEN ROUND(orders.total_amt_usd/orders.total,2)
ELSE null
END AS 
     unit_price
FROM  
   orders
JOIN   
   accounts ON orders.account_id = accounts.id
JOIN   
   sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN  
   region ON sales_reps.region_id = region.id;



--3.  Channel Usage Summary
SELECT
     channel,
COUNT (*) AS count_of_channel
FROM 
    web_events
GROUP BY 
     channel
ORDER BY 
      count_of_channel DESC; 


--4.   Channel usage by Sales Rep
SELECT 
    web_events.Channel,
COUNT(*) AS
       count_of_event, 
	   sales_reps.name as sales_rep_name
FROM
   web_events
JOIN
    accounts on web_events.account_id = accounts.id
JOIN
    sales_reps ON accounts.sales_rep_id = sales_reps.id
GROUP BY 
       sales_rep_name, channel
Order By
       count_of_event DESC; 


--5.  High Volume Orders (standard quantity)
SELECT orders.standard_qty ,
       region.name AS region_name,
       accounts.name AS account_name, CASE
WHEN  
    orders.total > 0 THEN ROUND(orders.total_amt_usd/orders.total,2)
ELSE NULL
END AS
   unit_price
FROM  
   orders
JOIN  
   accounts ON orders.account_id = accounts.id
JOIN  
   sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN   
  region ON sales_reps.region_id = region.id
WHERE
    (standard_qty) > 100
ORDER BY  
     standard_qty ASC;


--6.  Orders in 2015 
SELECT 
     accounts.name AS account_name,
     orders.occurred_at::date As order_date, 
	 orders.total AS total_qty_ordered,
	 orders.total_amt_usd As total_amt_usd
FROM 
   orders 
JOIN 
   accounts ON orders.account_id = accounts.id 
where 
    orders.occurred_at >= '2015-01-01'
Group by 
     account_name,order_date,  total_qty_ordered,  orders.total_amt_usd
ORDER BY  
     order_date;



-- 6.  Different Approach
SELECT 
     accounts.name AS account_name,
     orders.occurred_at::date As order_date, 
	 orders.standard_qty,
	 orders.gloss_qty,
	 orders.poster_qty,
	 orders.total AS total_qty_ordered,
	 orders.total_amt_usd As total_amt_usd
FROM 
   orders 
JOIN 
   accounts ON orders.account_id = accounts.id 
where
    orders.occurred_at >= '2015-01-01'
Group by 
       account_name,order_date,  total_qty_ordered,  orders.total_amt_usd, orders.standard_qty,
	   orders.gloss_qty, orders.poster_qty
ORDER BY 
      order_date;



--7.   High Volume Orders (standard + Posters )
SELECT
     orders.standard_qty , 
     orders.poster_qty,
     region.name AS region_name,
     accounts.name AS account_name, 
	 ROUND(orders.total_amt_usd/orders.total,2) AS unit_price
FROM  
   orders
JOIN   
   accounts ON orders.account_id = accounts.id
JOIN  
  sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN   
   region ON sales_reps.region_id = region.id
WHERE 
    (standard_qty) > 100 AND (poster_qty) > 50
ORDER BY  
     unit_price DESC;
   
