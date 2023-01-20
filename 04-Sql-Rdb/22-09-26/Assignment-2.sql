/*
1. Product Sales
You need to create a report on whether customers who 
purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' 
buy the product below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)

To generate this report, you are required to use the 
appropriate SQL Server Built-in functions or 
expressions as well as basic SQL knowledge.
*/

-------------------------
select a.customer_id, a.first_name, a.last_name, isnull(b.other, 'No') as other_product
from sale.customer a left join
				(select c.customer_id, d.first_name, d.last_name,a.product_name, 'Yes' as Other
				from product.product a, sale.order_item b,
				sale.orders c, sale.customer d
				where a.product_id = b.product_id and
				b.order_id = c.order_id and 
				c.customer_id = d.customer_id
				and a.product_name = 'Polk Audio - 50 W Woofer - Black'
				and d.customer_id in
									(select distinct  c.customer_id
									from product.product a, sale.order_item b,
									sale.orders c, sale.customer d
									where a.product_id = b.product_id and
									b.order_id = c.order_id and 
									c.customer_id = d.customer_id and
									a.product_name =  '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD')
				) as b
on a.customer_id = b.customer_id
where a.customer_id in (select distinct  c.customer_id
									from product.product a, sale.order_item b,
									sale.orders c, sale.customer d
									where a.product_id = b.product_id and
									b.order_id = c.order_id and 
									c.customer_id = d.customer_id and
									a.product_name =  '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD')




--v2

WITH T1 AS
(
SELECT	DISTINCT A.product_name, D.customer_id, D.first_name, D.last_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
), T2 AS
(
SELECT	DISTINCT A.product_name, D.customer_id, D.first_name, D.last_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Polk Audio - 50 W Woofer - Black'
)
SELECT	T1.customer_id, T1.first_name, T1.last_name,
		ISNULL (NULLIF (ISNULL(T2.first_name, 'No'), T2.first_name) , 'Yes') as is_otherproduct_order
FROM	T1
		LEFT JOIN
		T2
		ON	T1.customer_id = T2.customer_id








-------------------------

--2. Conversion Rate
--Below you see a table of the actions of customers visiting the website by clicking on two different
--types of advertisements given by an E-Commerce company. Write a query to return the conversion rate for each Advertisement type.

--a.    Create above table (Actions) and insert values,

 

--b.    Retrieve count of total Actions and Orders for each Advertisement Type,

 

--c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.

use Assignment

create table actions
( visitor_id tinyint not null primary key identity(1,1),
  adv_type char(1),
  action varchar(7));

insert actions (adv_type, action)
values  ( 'A', 'Left'),
		( 'A', 'Order'),
		( 'B', 'Left'),
		( 'A', 'Order'),
		( 'A', 'Review'),
		( 'A', 'Left'),
		( 'B', 'Left'),
		( 'B', 'Order'),
		( 'B', 'Review'),
		( 'A', 'Review');

select * from actions

select adv_type,left((COUNT(case when action = 'Order' then 1 end) * 1.0 / count(adv_type)),4) as conversion_rate
from actions
group by adv_type


--v2-

SELECT * INTO #TABLE1
FROM
( VALUES 			
				(1,'A', 'Left'),
				(2,'A', 'Order'),
				(3,'B', 'Left'),
				(4,'A', 'Order'),
				(5,'A', 'Review'),
				(6,'A', 'Left'),
				(7,'B', 'Left'),
				(8,'B', 'Order'),
				(9,'B', 'Review'),
				(10,'A', 'Review')
			) A (visitor_id, adv_type, actions)
WITH T1 AS
(
SELECT	adv_type, COUNT (*) cnt_action
FROM	#TABLE1
GROUP BY
		adv_type
), T2 AS
(
SELECT	adv_type, COUNT (actions) cnt_order_actions
FROM	#TABLE1
WHERE	actions = 'Order'
GROUP BY
		adv_type
)
SELECT	T1.adv_type, CAST (ROUND (1.0*T2.cnt_order_actions / T1.cnt_action, 2) AS numeric (3,2)) AS Conversion_Rate
FROM	T1, T2
WHERE	T1.adv_type = T2.adv_type
