{{
  config(
    materialized = 'view'
  )
}}

with offer_transactions AS (
    SELECT
        o.offer_id,
        o.channel,
        t.transaction_status
    FROM
        {{ ref('dim_offer') }} o
    LEFT JOIN
        {{ ref('fct_offer_transactions') }} t
        ON o.offer_id = t.offer_id
),

channel_metrics AS (
    SELECT
        channel,
        {{ calculate_response_rate('transaction_status', 'offer_id') }} AS response_rate,
        COUNT(offer_id) AS total_offers,
        COUNT(CASE WHEN transaction_status = 'completed' THEN 1 END) AS total_completions
    FROM
        offer_transactions
    GROUP BY
        channel
)

SELECT
    channel,
    response_rate,
    total_offers,
    total_completions
FROM
    channel_metrics
ORDER BY
    response_rate DESC
