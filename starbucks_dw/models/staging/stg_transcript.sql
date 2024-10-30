{{
  config(
    materialized = 'view',
    )
}}

with
    cleaned_transcript as (
        select
            a as transaction_id,
            person as customer_id,
            event as transaction_type,
            replace(value, '''', '"')::json as transaction_value,
            time as hours_since_start,
            {{ get_days_from_hours('time') }} as days_since_start,
            current_timestamp as ingested_at
        from {{ ref('transcript') }}
    ),

    unnest_offer_received as (
        select
            *,
            transaction_value ->> 'offer id' as offer_id,
            transaction_value ->> 'reward' as reward,
            null as amount
        from cleaned_transcript
        where transaction_type = 'offer received'
    ),

    unnest_offer_viewed as (
        select
            *,
            transaction_value ->> 'offer id' as offer_id,
            null as reward,
            null as amount
        from cleaned_transcript
        where transaction_type = 'offer viewed'
    ),

    unnest_offer_completed as (
        select
            *,
            transaction_value ->> 'offer_id' as offer_id,
            transaction_value ->> 'reward' as reward,
            null as amount
        from cleaned_transcript
        where transaction_type = 'offer completed'
    ),

    unnest_transaction as (
        select
            *,
            null as offer_id,
            null as reward,
            transaction_value ->> 'amount' as amount
        from cleaned_transcript
        where transaction_type = 'transaction'
    ),

    all_transactions as (
        select *
        from unnest_offer_received
        union all
        select *
        from unnest_offer_viewed
        union all
        select *
        from unnest_offer_completed
        union all
        select *
        from unnest_transaction
    ),

    final as (
        select
            transaction_id,
            customer_id,
            offer_id,
            transaction_type,
            hours_since_start,
            days_since_start,
            ingested_at,
            coalesce(reward::numeric, 0) as reward,
            coalesce(amount::numeric, 0) as amount
        from all_transactions
    )

select *
from final
