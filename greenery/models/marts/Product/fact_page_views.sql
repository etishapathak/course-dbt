{{
  config(
    materialized='table'
  )
}}

with int_session_events as(
  select * from {{ref('int_session_events')}}
)

select 
event_user_guid
,sum(add_to_carts) as add_to_carts_total
,sum(page_views) as page_views_total
,sum(checkouts) as chckouts_total
,sum(package_shipped) as Package_shipped_total
,DATE(min(first_user_session_utc)) as First_interaction
,DATE(max(last_user_session_utc)) as Last_interaction
from {{ref ('int_session_events')}}
group by event_user_guid