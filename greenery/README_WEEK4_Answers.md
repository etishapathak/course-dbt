## Part 1. dbt Snapshots
Which products had their inventory changed from week 3 to week 4? 
```
Monstera
Bamboo
Philodendron
ZZ Plant
String of pearls
Pothos
```

Now that we have 3 weeks of snapshot data, can you use the inventory changes to determine which products had the most fluctuations in inventory? 

```
with Product_change as
(
select name, price, inventory,dbt_updated_at, dbt_valid_from, dbt_valid_to,
RANK() OVER (PARTITION BY name ORDER BY dbt_updated_at) as No_of_Changes
from DEV_DB.DBT_EPATHAKUCSCEDU.products_snapshot
)
select name as product_name, max(No_of_changes) as Total_changes
from product_change
group by name
having total_changes > 1
order by total_changes desc
```

Did we have any items go out of stock in the last 3 weeks? 
```
select name
from DEV_DB.DBT_EPATHAKUCSCEDU.products_snapshot
where inventory =0
and CAST(dbt_updated_at as DATE) <= '2023-04-30'
```
```
String of pearls
Pothos
```

## Part 2. Modeling challenge
How are our users moving through the product funnel?
```
SESSIONS_WITH_PAGE_VIEWS    578
SESSIONS_WITH_ADD_TO_CARTS  467
SESSIONS_WITH_CHECKOUTS     361
ADD_TO_CART_RATE            0.81
CHECKOUTS_RATE              0.62
				


I have created products_funnel in order to show this data.
```
Which steps in the funnel have largest drop off points?
```
Between the users adding products to their carts but not actually checking out those.
```
Use an exposure on your product analytics model to represent that this is being used in downstream BI tools. 
```
Created product_funnel_exposures.yml in the project.
```
## Part 3: Reflection question
While learning dbt for the past one month in this class, I am able to understand how powerful this tool is in terms of modelling. Structuring of models, snapshots, tests and exposure are all very unique styles of dbt which models your data and makes it efficient for reporting.
I learnt different ways to think about while trying to create metrics so that you can further slice them based on business requirements.
```


