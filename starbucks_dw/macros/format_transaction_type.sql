{% macro format_transaction_type(column) %}
    case 
        when {{column}} = 'offer received'
        then 'received'
        when {{column}} = 'offer viewed'
        then 'viewed'
        when {{column}} = 'offer completed'
        then 'completed'
        when {{column}} = 'transaction'
        then 'transaction'
    end

{% endmacro %}
