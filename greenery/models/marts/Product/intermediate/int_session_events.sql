{{
  config(
    materialized='table'
  )
}}

with events as(
  select * from {{ref('stg_events')}}
)

,page_events as(
select 
  user_id as event_user_guid
 ,session_id as event_session_guid
 ,sum(case when event_type ='add_to_cart' then 1 else 0 end) as add_to_carts
 ,sum(case when event_type ='page_view' then 1 else 0 end) as page_views
 ,sum(case when event_type ='checkout' then 1 else 0 end) as checkouts
 ,sum(case when event_type ='package_shipped' then 1 else 0 end) as package_shipped
 ,min(created_at) as first_user_session_utc
 ,max(created_at) as last_user_session_utc
 from events
 group by 1,2
)
select * from page_events