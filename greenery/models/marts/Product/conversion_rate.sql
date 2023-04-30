{{
  config(
    materialized='table'
  )
}}

with int_sessions as (
  select * from {{ref('stg_events')}}
)

,conversion_count as(
    select count(distinct session_id) as session_cnt,
     count(distinct case when event_type='checkout' then session_id end) as checkout_session_cnt,
     round((checkout_session_cnt / session_cnt), 2) as conversion_rate 
      from int_sessions
   )

   select conversion_rate from conversion_count