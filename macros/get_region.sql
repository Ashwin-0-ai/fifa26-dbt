{% macro get_region(longitude_column)%}
    CASE 
        WHEN {{ longitude_column }} < -105 THEN 'West'
        WHEN {{ longitude_column }} BETWEEN -105 AND -90 THEN 'Central'
        ELSE 'East'
    END
{% endmacro %}

