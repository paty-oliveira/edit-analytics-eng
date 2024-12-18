{{
  config(
    materialized = 'table'
  )
}}


WITH age_buckets AS (
    SELECT
        customer_id,
        CASE 
            WHEN age < 18 THEN 'Under 18'
            WHEN age BETWEEN 18 AND 24 THEN '18-24'
            WHEN age BETWEEN 25 AND 34 THEN '25-34'
            WHEN age BETWEEN 35 AND 44 THEN '35-44'
            WHEN age BETWEEN 45 AND 54 THEN '45-54'
            WHEN age BETWEEN 55 AND 64 THEN '55-64'
            WHEN age BETWEEN 65 AND 74 THEN '65-74'
            WHEN age BETWEEN 75 AND 84 THEN '75-84'
            WHEN age BETWEEN 85 AND 94 THEN '85-94'
            WHEN age >= 95 THEN '95+'
            ELSE 'Unknown'
        END AS age_bucket
    from {{ ref('dim_customer') }}
),
income_buckets AS (
    SELECT
        customer_id,
        CASE 
            WHEN income < 30000 THEN 'Below 30k'
            WHEN income BETWEEN 30000 AND 39999 THEN '30k-40k' 
            WHEN income BETWEEN 40000 AND 59999 THEN '40k-60k'
            WHEN income BETWEEN 60000 AND 79999 THEN '60k-80k'
            WHEN income BETWEEN 80000 AND 99999 THEN '80k-100k'
            WHEN income BETWEEN 100000 AND 120000 THEN '100k-120k'
            WHEN income >= 120001 THEN '120k+'
            ELSE 'Out of range'
        END AS income_bucket
    from {{ ref('dim_customer') }} 
),
customer_tenure AS (
    SELECT
        customer_id,
        CASE
            WHEN CURRENT_DATE - subscribed_date <= 30 THEN 'New Customer (< 1 month)'
            WHEN CURRENT_DATE - subscribed_date BETWEEN 31 AND 365 THEN 'Established Customer (1-12 months)'
            WHEN CURRENT_DATE - subscribed_date BETWEEN 366 AND 730 THEN 'Loyal Customer (1-2 years)Loyal Customer (1-2 years)'
            WHEN CURRENT_DATE - subscribed_date > 730 THEN 'Long-term Customer (> 2 years)'
        END AS customer_tenure
    from {{ ref('dim_customer') }}
),
purchase_recency AS (
    SELECT
        customer_id,
        CASE
            WHEN CURRENT_DATE - DATE(ingested_at) <= 30 THEN 'Recent Buyer (< 1 month)'
            WHEN CURRENT_DATE - DATE(ingested_at) BETWEEN 31 AND 90 THEN 'Engaged Buyer (1-3 months)'
            WHEN CURRENT_DATE - DATE(ingested_at) > 90 THEN 'Lapsed Buyer (> 3 months)'
            ELSE 'Unknown'
        END AS purchase_recency
    from {{ ref('fct_customer_transactions') }}
),

final as (
    SELECT 
        ab.age_bucket,
        ib.income_bucket,
        ct.customer_tenure,
        pr.purchase_recency,
        c.gender,
        COUNT(*) AS customer_count,
        ROUND(SUM(CASE WHEN fct.transaction_type = 'completed' THEN 1 ELSE 0 END) * 1.0 / COUNT(fct.transaction_id), 4) AS response_rate,
        COUNT(CASE WHEN fct.transaction_type = 'completed' THEN 1 END) AS completed_status_transactions,
        COUNT(fct.transaction_id) AS total_transactions
    FROM fct_customer_transactions fct
        LEFT JOIN dim_customer c ON fct.customer_id = c.customer_id
        LEFT JOIN dim_offer o ON fct.offer_id = o.offer_id
        LEFT JOIN age_buckets ab ON c.customer_id = ab.customer_id
        LEFT JOIN income_buckets ib ON c.customer_id = ib.customer_id
        LEFT JOIN customer_tenure ct ON c.customer_id = ct.customer_id
        LEFT JOIN purchase_recency pr ON fct.customer_id = pr.customer_id
    GROUP BY ab.age_bucket, ib.income_bucket, ct.customer_tenure, pr.purchase_recency, c.gender
    ORDER BY response_rate DESC
)

select *
from final