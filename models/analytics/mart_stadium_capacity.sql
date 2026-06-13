{{ config(schema='ANALYTICS') }}
WITH 
    host_cities AS ( 
       SELECT * FROM {{ ref('stg_host_cities')}} 
    )
        SELECT
                host_country,
                stadium_name,
                stadium_capacity,
                stadium_latitude,
                stadium_longitude,
                loaded_at           
FROM host_cities 
ORDER BY stadium_capacity DESC