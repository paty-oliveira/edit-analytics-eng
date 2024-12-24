


{% macro format_transaction_type(collumn) %}
    {% set map = [
        {
            "key": "offer received",
            "value": "received"
        },
        {
            "key": "offer viewed",
            "value": "viewed"
        },
        {
            "key": "offer completed",
            "value": "completed"
        },
        {
            "key": "transaction",
            "value": "transaction"
        }
    ] %}
    case
        {% for item in map %}
        when {{ collumn }} =  '{{ item.key }}'
        then '{{ item.value }}'
        {% endfor %}
    end as transaction_status
{% endmacro %}
