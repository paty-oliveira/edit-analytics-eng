/* TO BE IMPLEMENTED BY THE STUDENT */
{{
  config(
    materialized = 'view',
    )
}}

with
    transformed_profile as (
        select
            id as customer_id,
            COALESCE(gender, 'N/A') as gender,
            age,
            TO_DATE(became_member_on::text, 'YYYYMMDD') as subscribed_date,
            COALESCE(income, 0) as income,
            current_timestamp as ingested_at
        from {{ ref('profile') }}
    )

select *
from transformed_profile
