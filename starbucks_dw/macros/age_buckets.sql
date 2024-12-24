{% macro age_buckets(collumn) %}
    {% set map = {
        "ranges": [
            {
                "range": "0 AND 18",
                "label": "<18",
            },
            {
                "range": "19 AND 35",
                "label": "19-35",
            },
            {
                "range": "36 AND 50",
                "label": "36-50",
            },
            {
                "range": "51 AND 75",
                "label": "51-75",
            }
        ],
        "else": "75+"
     } %}
    {{ make_buckets(collumn, map, 'age_buckets') }}
{% endmacro %}
