/* TO BE IMPLEMENTED BY THE STUDENT */
{{
  config(
    materialized = 'table',
    )
}}

{{ dbt_date.get_date_dimension("2015-01-01", "2025-12-31") }}
