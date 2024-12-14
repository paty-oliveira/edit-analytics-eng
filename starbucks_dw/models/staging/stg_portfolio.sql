{{
  config(
    materialized = 'view',
    )
}}

with
    transformed_portfolio as (
        select
            id as offer_id,
            reward,
            duration,
            difficulty as difficulty_rank,
            offer_type,
            replace(replace(replace(channels, '''', ''), '[', '{'), ']', '}')::text[
            ] as channels,
            current_timestamp as ingested_at
        from {{ ref('portfolio') }}
    )

select *
from transformed_portfolio
