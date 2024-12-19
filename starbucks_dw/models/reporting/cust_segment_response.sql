{{
  config(
    materialized = 'table'
  )
}}


with age_buckets as (
    select
        customer_id,
        case 
            when age < 18 then 'Under 18'
            when age between 18 AND 24 then '18-24'
            when age between 25 AND 34 then '25-34'
            when age between 35 AND 44 then '35-44'
            when age between 45 AND 54 then '45-54'
            when age between 55 AND 64 then '55-64'
            when age between 65 AND 74 then '65-74'
            when age between 75 AND 84 then '75-84'
            when age between 85 AND 94 then '85-94'
            when age >= 95 then '95+'
            else 'Unknown'
        end as age_bucket
    from {{ ref('dim_customer') }}
),
income_buckets as (
    select
        customer_id,
        case 
            when income < 30000 then 'Below 30k'
            when income between 30000 and 39999 then '30k-40k' 
            when income between 40000 and 59999 then '40k-60k'
            when income between 60000 and 79999 then '60k-80k'
            when income between 80000 and 99999 then '80k-100k'
            when income between 100000 and 120000 then '100k-120k'
            when income >= 120001 then '120k+'
            else 'Out of range'
        end as income_bucket
    from {{ ref('dim_customer') }}
),
customer_tenure as (
    select
        customer_id,
        case
            when current_date - subscribed_date <= 30 then 'New Customer (< 1 month)'
            when current_date - subscribed_date between 31 and 365 then 'Established Customer (1-12 months)'
            when current_date - subscribed_date between 366 and 730 then 'Loyal Customer (1-2 years)'
            when current_date - subscribed_date > 730 then 'Long-term Customer (> 2 years)'
        end as customer_tenure
    from {{ ref('dim_customer') }}
),
purchase_recency as (
    select
        customer_id,
        case
            when current_date - date(ingested_at) <= 30 then 'Recent Buyer (< 1 month)'
            when current_date- date(ingested_at) between 31 and 90 then 'Engaged Buyer (1-3 months)'
            when current_date - date(ingested_at) > 90 then 'Lapsed Buyer (> 3 months)'
            else 'Unknown'
        end as purchase_recency
    from {{ ref('fct_customer_transactions') }}
),

final as (
    select
        ab.age_bucket,
        ib.income_bucket,
        c.gender,
        ct.customer_tenure,
        pr.purchase_recency,
        count(*) as customer_count,
        o.offer_type,
        {{ calculate_response_rate("fct.transaction_type", ["completed"], "fct.transaction_id", "response_rate") }},
        {{ count_transactions("fct.transaction_type", ["completed"], "completed_status_transactions") }},
        count(fct.transaction_id) as total_transactions
    from {{ ref('fct_customer_transactions') }} fct
        left join {{ ref('dim_customer') }} c on fct.customer_id = c.customer_id
        left join {{ ref('dim_offer') }} o on fct.offer_id = o.offer_id
        left join age_buckets ab on c.customer_id = ab.customer_id
        left join income_buckets ib on c.customer_id = ib.customer_id
        left join customer_tenure ct on c.customer_id = ct.customer_id
        left join purchase_recency pr on fct.customer_id = pr.customer_id
    group by ab.age_bucket, ib.income_bucket, c.gender, ct.customer_tenure, pr.purchase_recency, o.offer_type
    order by response_rate desc
)

select *
from final