

{% macro format_transaction_type(transaction_type) %}
    {% set type_map = {'offer received': 'received', 'offer viewed': 'viewed', 'offer completed': 'completed', 'transaction': 'transaction'} %}
    CASE 
        {% for key, value in type_map.items() %}
            when {{ transaction_type }} = '{{ key }}' then '{{ value }}'
        {% endfor %}
    else null
    end
{% endmacro %}
