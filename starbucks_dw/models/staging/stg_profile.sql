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
            a,
            COALESCE(gender, 'N/A') AS gender,
            age,
            TO_DATE(became_member_on::TEXT, 'YYYYMMDD') AS became_member_on,
            COALESCE(income, 0) AS income,
            CURRENT_TIMESTAMP AS ingested_at
        from {{ ref('profile') }}
        where age <> 118

    )



select *
from transformed_profile