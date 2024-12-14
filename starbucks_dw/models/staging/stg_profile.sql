{{
  config(
    materialized = 'view',
    )
}}

with
    transformed_profile as (
        select
              COALESCE(gender, 'N/A') AS gender
            , age
            , id AS customer_id
            , TO_DATE(CAST(became_member_on AS TEXT), 'YYYYMMDD') AS became_member_on
            , COALESCE(income, 0) AS income
            , current_timestamp as ingested_at
        from {{ ref('profile') }}
    where age <> 118
    )

select *
from transformed_profile
