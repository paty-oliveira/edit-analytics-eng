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
            COALESCE(income, 0) AS income,
            TO_DATE(CAST(became_member_on AS TEXT), 'YYYYMMDD') AS converted_date,
            age,
            current_timestamp as ingested_at
        from {{ ref('profile') }}
        where age != 118
    )

select *
from transformed_profile
