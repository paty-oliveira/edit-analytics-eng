{{
  config(
    materialized = 'table'
  )
}}


select
    o.channel AS offer_channel,
    o.offer_type AS offer_type,
    o.difficulty_rank AS difficulty_rank,
    round((COUNT(CASE WHEN f.transaction_type IN ('completed', 'transaction') THEN 1 END) * 1.0) / COUNT(f.transaction_id),4) AS completed_response_rate,
    round((COUNT(CASE WHEN f.transaction_type IN ('viewed', 'transaction') THEN 1 END) * 1.0) / COUNT(f.transaction_id),4) AS viewed_response_rate,
    round((COUNT(CASE WHEN f.transaction_type IN ('received', 'transaction') THEN 1 END) * 1.0) / COUNT(f.transaction_id),4) AS received_response_rate,
    COUNT(CASE WHEN f.transaction_type IN ('completed', 'transaction') THEN 1 END) AS completed_status_transactions,
    COUNT(CASE WHEN f.transaction_type IN ('viewed', 'transaction') THEN 1 END) AS viewed_status_transactions,
    COUNT(CASE WHEN f.transaction_type IN ('received', 'transaction') THEN 1 END) AS received_status_transactions,
    COUNT(f.transaction_id) AS total_transactions
from {{ ref('fct_offer_transactions') }} f
inner join {{ ref('dim_offer') }} o on f.offer_id = o.offer_id
where f.transaction_type in ('received', 'viewed', 'completed', 'transaction')
group by o.channel,o.offer_type,o.difficulty_rank
