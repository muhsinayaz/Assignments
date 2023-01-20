/*
Discount Effects

Generate a report including product IDs and discount effects on whether 
the increase in the discount rate positively impacts the number of orders for the products.

In this assignment, you are expected to generate a solution 
using SQL with a logical approach. 

Sample Result:
Product_Id		Discount_Effect
1				Positive
2				Negative
3				Negative
4				Neutral

*/

/*
Sipariþler ürün ve indirim oranýna göre gruplandýðýnda satýþ miktar ortalamasý,
en düþük indirim oranýnda(0.05) yapýlan satýþ miktarýndan yüksek ise positive, düþük ise negative,
eþit ise neutral olmasýna karar verdim.
*/

with t1 as
(select b.product_id, b.discount, count(*) as order_count		
from product.product a, sale.order_item b
where a.product_id = b.product_id
group by b.product_id, b.discount)
select distinct product_id, 
		case
		when avg(order_count) over (partition by product_id) > first_value(order_count) over (partition by product_id order by discount )
		then 'Positive'
		when avg(order_count) over (partition by product_id) < first_value(order_count) over (partition by product_id order by discount)
		then 'Negative'
		when avg(order_count) over (partition by product_id) = first_value(order_count) over (partition by product_id order by discount)
		then 'Neutral'
		end disc_efect
from  t1







