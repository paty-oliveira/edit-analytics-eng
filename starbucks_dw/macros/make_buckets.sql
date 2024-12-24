{% macro make_buckets(collumn, bucket_map, bucket_name) %}
    case
        {% for item in bucket_map.ranges %}
        WHEN {{ collumn }} BETWEEN  {{ item.range }}
        THEN '{{ item.label }}'
        {% endfor %}
        {% if bucket_map.else %}
        ELSE '{{ bucket_map.else }}'
        {% endif %}
    end as {{ bucket_name }}
{% endmacro %}
