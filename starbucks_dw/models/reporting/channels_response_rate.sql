{{
  config(
    materialized = 'table'
  )
}}


select
    o.channel as offer_channel,
    o.offer_type as offer_type,
    o.difficulty_rank as difficulty_rank, 
    {{ calculate_response_rate("f.transaction_type", ["completed"], "f.transaction_id", "completed_response_rate") }},
    {{ calculate_response_rate("f.transaction_type", ["viewed"], "f.transaction_id", "viewed_response_rate") }},
    {{ calculate_response_rate("f.transaction_type", ["received"], "f.transaction_id", "received_response_rate") }},
    {{ count_transactions("f.transaction_type", ["completed"], "completed_status_transactions") }},
    {{ count_transactions("f.transaction_type", ["viewed"], "viewed_status_transactions") }},
    {{ count_transactions("f.transaction_type", ["received"], "received_status_transactions") }},
    count(f.transaction_id) as total_transactions
from {{ ref('fct_offer_transactions') }} f
inner join {{ ref('dim_offer') }} o on f.offer_id = o.offer_id
where f.transaction_type in ('received', 'viewed', 'completed', 'transaction')
group by o.channel, o.offer_type, o.difficulty_rank
