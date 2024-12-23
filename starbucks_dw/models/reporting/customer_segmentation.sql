{{
  config(
    materialized = 'view'
  )
}}

WITH customer_behavior AS (
    SELECT
        c.customer_id,
        c.gender,
        c.age,
        {{ calculate_response_rate('o.transaction_status', 'o.offer_id') }} AS response_rate
    FROM
        {{ ref('dim_customer') }} c
    LEFT JOIN
        {{ ref('fct_customer_transactions') }} t
        ON c.customer_id = t.customer_id
    LEFT JOIN
        {{ ref('fct_offer_transactions') }} o
        ON t.transaction_id = o.transaction_id
    GROUP BY
        c.customer_id, c.gender, c.age
)

SELECT
    customer_id,
    gender,
    age,
    response_rate,
    CASE
        WHEN response_rate > 0.75 THEN 'Highly Responsive'
        WHEN response_rate BETWEEN 0.5 AND 0.75 THEN 'Moderately Responsive'
        WHEN response_rate BETWEEN 0.25 AND 0.5 THEN 'Low Responsive'
        ELSE 'Unresponsive'
    END AS responsiveness_segment
FROM customer_behavior
