/* 
Exercicio Pratico III 

Rename id column to customer_id
● Replace NULL values of gender column to N/A
● Replace NULL values of income column to 0
● Cast become_member_on column to Date type
● Add ingested_at column with the current timestamp
● Apply a filter to remove customers with 118 years old. It seems a placeholder
for missing values.

*/
{{
  config(
    materialized = 'view',
    )
}}

WITH
    transformed_profile as (
        SELECT
            a,
            COALESCE(gender,'N/A') AS gender,
            age,
            id AS customer_id,
            CAST(CAST(became_member_on AS TEXT) AS DATE) AS subscribed_date,
            COALESCE(income,0) AS income,
            current_timestamp as ingested_at
        FROM {{ ref('profile') }}
        WHERE age <> 118
    )

select *
from transformed_profile
