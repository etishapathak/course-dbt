{{
  config(
    materialized='table'
  )
}}

with int_session_events as(
  select * from {{ref('int_session_events')}}
)

select 
sum(case when page_views >0 then 1 else 0 end) as sessions_with_page_views,
sum(case when add_to_carts >0 then 1 else 0 end) as sessions_with_add_to_carts,
sum(case when checkouts >0 then 1 else 0 end) as sessions_with_checkouts,
round((sessions_with_add_to_carts/sessions_with_page_views),2) as add_to_cart_rate,
round((sessions_with_checkouts/sessions_with_page_views),2) as checkout_rate
from int_session_events