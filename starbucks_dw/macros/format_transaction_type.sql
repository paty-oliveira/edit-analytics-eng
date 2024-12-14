{% macro format_transaction_type(transaction = 'transactions.transaction_type') %}
    case
                when {{transaction}} = 'offer received'
                then 'received'
                when {{transaction}} = 'offer viewed'
                then 'viewed'
                when {{transaction}} = 'offer completed'
                then 'completed'
                when {{transaction}} = 'transaction'
                then 'transaction'
            end
{% endmacro %}