{% macro income_buckets(collumn) %}
    {% set map = {
        "ranges": [
            {
                "range": "0 AND 24999",
                "label": "Under $25,000",
            },
            {
                "range": "25000 AND 49999",
                "label": "$25,000 – $49,999",
            },
            {
                "range": "50000 AND 74999",
                "label": "$50,000 – $74,999",
            },
            {
                "range": "75000 AND 99999",
                "label": "$75,000 – $99,999",
            },
            {
                "range": "100000 AND 149999",
                "label": "$100,000 – $149,999",
            },

        ],
        "else": "$150,000+"
     } %}
    {{ make_buckets(collumn, map, 'income_buckets') }}
{% endmacro %}
