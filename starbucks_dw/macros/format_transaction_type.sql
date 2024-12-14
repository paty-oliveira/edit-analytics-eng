{% macro format_transaction_type(transactions_type) %}
    case
        when {{ transactions_type }} = 'offer received'
        then 'received'
        when {{ transactions_type }} = 'offer viewed'
        then 'viewed'
        when {{ transactions_type }} = 'offer completed'
        then 'completed'
        when {{ transactions_type }} = 'transaction'
        then 'transaction'
    end
{% endmacro %}
