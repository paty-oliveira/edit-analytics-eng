{% macro count_transactions(column_name, statuses, alias) %}
    COUNT(CASE WHEN {{ column_name }} IN (
        {%- for status in statuses -%}
            '{{ status }}'{% if not loop.last %}, {% endif %}
        {%- endfor -%}
    ) THEN 1 END) AS {{ alias }}
{% endmacro %}