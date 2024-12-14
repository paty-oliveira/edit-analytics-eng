{{
  config(
    materialized = 'view',
    )
}}

with   transformed_profile as (
        select
            id as customer_id,
            coalesce(gender , 'N/A') as gender,
            age,
            coalesce(income,0) as income,
            to_date(cast(became_member_on as text), 'YYYYMMDD') as subscribed_date,
            current_timestamp as ingested_at
        from {{ ref('profile') }}
        where age < 118
    )

select *
from transformed_profile
