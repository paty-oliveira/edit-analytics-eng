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
            COALESCE(gender, 'N/A') AS gender,
            COALESCE(income, 0) AS income,
            age,
            to_date(became_member_on::TEXT, 'YYYYMMDD') as became_member_on,
            current_timestamp as ingested_at
        from {{ ref('profile') }}
    )

select *
from transformed_profile
where age <> 118
