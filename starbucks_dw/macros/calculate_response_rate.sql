{% macro calculate_response_rate(transaction_status, offer_id) %}
  COALESCE(
    COUNT(CASE WHEN {{ transaction_status }} = 'completed' THEN 1 END) * 1.0 /
        NULLIF(COUNT({{ offer_id }}), 0)
        , 0)
{% endmacro %}
