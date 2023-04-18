## How many users do we have? --130
```
select count(user_id) from DEV_DB.DBT_EPATHAKUCSCEDU.STG_USERS
```



## On average, how many orders do we receive per hour? --13
```
select ROUND(avg(orders_at_hour), 0) from
(
select HOUR(created_at) as Created_hour, count(order_id) as orders_at_hour
from DEV_DB.DBT_EPATHAKUCSCEDU.stg_orders 
where delivered_at is not null
Group By 1
)
```

## On average, how long does an order take from being placed to being delivered? -- 4 days
```
select ROUND(avg(DATEDIFF('DAY',created_at, delivered_at)),0) as Avg_delivery_time_days
from DEV_DB.DBT_EPATHAKUCSCEDU.stg_orders
```

## How many users have only made one purchase? Two purchases? Three+ purchases?
PUCHASE_ORDERS	NO_OF_USERS
Three_or_more_orders	71
One_Order		25
Two_Orders		28


```
with count_orders as(
select user_id,
RANK() OVER (PARTITION BY USER_ID ORDER BY created_at) as No_of_Orders
from DEV_DB.DBT_EPATHAKUCSCEDU.stg_orders
)
,max_orders as(
select distinct user_id, max(No_of_Orders) as Max_Purchases 
from Count_orders group by 1
)
,group_by_purchase as(
select 
  CASE
     WHEN Max_Purchases =1 THEN 'One_Order'
     WHEN Max_Purchases =2 THEN 'Two_Orders'
     ELSE 'Three_or_more_orders'
     END as Puchase_orders,
count(*) as No_of_users
from max_orders
GROUP BY 1
)
select * from group_by_purchase
```



## On average, how many unique sessions do we have per hour? --39.46
```
with unique_sessions_per_hour as(
select 
HOUR(created_at) as created_hour, 
count(DISTINCT session_id) as sessions_per_hour
from DEV_DB.DBT_EPATHAKUCSCEDU.stg_events 
Group by created_hour
)

select round(avg(sessions_per_hour),0) 
from unique_sessions_per_hour
```

