{% macro format_transaction_type(column_name) %}
    CASE
        WHEN {{ column_name }} = 'offer received' THEN 'received'
        WHEN {{ column_name }} = 'offer viewed' THEN 'viewed'
        WHEN {{ column_name }} = 'offer completed' THEN 'completed'
        WHEN {{ column_name }} = 'transaction' THEN 'transaction'
        ELSE NULL
    END
{% endmacro %}

