
{{
  config(
    materialized = 'view',
    )
}}

with
    transformed_profile as (
        select
            id as customer_id,
            COALESCE(gender, 'N/A') AS gender,
            age,
            COALESCE(income, 0) AS income,
            TO_DATE(became_member_on::TEXT, 'YYYYMMDD') AS subscribed_date,
            CURRENT_TIMESTAMP AS ingested_at
        from {{ ref('profile') }}
        where age >= 118
    )

select *
from transformed_profile