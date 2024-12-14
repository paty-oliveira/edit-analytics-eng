{% macro format_transation_type(column) %}
case
    {% set conditions = [
        ('offer received', 'received'),
        ('offer viewed', 'viewed'),
        ('offer completed', 'completed'),
        ('transaction', 'transaction')
    ] %}
    {% for condition, result in conditions %}
    when {{ column }} = '{{ condition }}'
    then '{{ result }}'
    {% endfor %}
end
{% endmacro %}
