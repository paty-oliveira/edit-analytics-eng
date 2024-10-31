{{
  config(
    materialized = 'table',
    )
}}

{% set surrogate_key_columns = ['offer_id', 'channel'] %}

with
    unnested_channels as (
        select
            offer_id,
            offer_type,
            difficulty_rank,
            reward,
            duration,
            ingested_at,
            unnest(channels) as channel
        from {{ ref('stg_portfolio') }}
    ),

    final as (
        select
            {{ dbt_utils.generate_surrogate_key(surrogate_key_columns) }}
            as offer_channel_key,
            offer_id,
            offer_type,
            channel,
            difficulty_rank,
            reward,
            duration,
            ingested_at
        from unnested_channels

    )

select *
from final
