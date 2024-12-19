{% macro calculate_response_rate(column_name, statuses, total_count_column, alias) %}
    ROUND(
        (COUNT(CASE WHEN {{ column_name }} IN (
            {%- for status in statuses -%}
                '{{ status }}'{% if not loop.last %}, {% endif %}
            {%- endfor -%}
        ) THEN 1 END) * 1.0) / 
        COUNT({{ total_count_column }}),
    4) AS {{ alias }}
{% endmacro %}