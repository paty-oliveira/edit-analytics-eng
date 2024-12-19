{{
  config(
    materialized = 'view',
    )
}}


with
    transformed_profile as (
        SELECT
            id as customer_id,
            coalesce(age, 0) as age,
            coalesce(gender,'N/A') as gender,
            coalesce(income,0) as income,
            to_date(became_member_on::text,'YYYYMMDD') as subscribed_date,
            current_timestamp as ingested_at
        FROM {{ ref('profile') }}
        WHERE age < 118
    )

select *
from transformed_profile
