{{
  config(
    materialized='table'
  )
}}

with session_event_agg as(
  select * from {{ref('int_session_events')}}
)

,users as(
    select * from {{ref('stg_users')}}
)

select 
     session_event_agg.event_user_guid
    ,session_event_agg.event_session_guid
    ,users.first_name
    ,users.last_name
    ,users.email
    ,session_event_agg.page_views
    ,session_event_agg.add_to_carts
    ,session_event_agg.checkouts
    ,session_event_agg.package_shipped
    ,session_event_agg.first_user_session_utc as first_session_event
    ,session_event_agg.last_user_session_utc as last_session_event
    ,datediff('minute',first_session_event,last_session_event) as session_length_minutes
    from session_event_agg
    JOIN users ON session_event_agg.event_user_guid = users.user_id