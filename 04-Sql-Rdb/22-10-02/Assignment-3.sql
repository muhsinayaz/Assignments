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
Sipari�ler �r�n ve indirim oran�na g�re grupland���nda sat�� miktar ortalamas�,
en d���k indirim oran�nda(0.05) yap�lan sat�� miktar�ndan y�ksek ise positive, d���k ise negative,
e�it ise neutral olmas�na karar verdim.
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







