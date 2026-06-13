{{ config(schema='ANALYTICS') }}
WITH matches AS (
    SELECT * FROM {{ ref('stg_matches')}}
),
    host_cities AS ( 
       SELECT * FROM {{ ref('stg_host_cities')}} 
    ),

joined AS (
        SELECT 
                m.match_id,
                m.stage,
                m.group_name,
                m.city,
                m.stadium,
                h.host_country,
                h.stadium_name,
                h.stadium_capacity,
                h.stadium_latitude,
                h.stadium_longitude,
                h.loaded_at,
                COUNT(*) OVER (PARTITION BY m.city) AS matches_in_city
        FROM matches m
        LEFT JOIN host_cities h
                ON m.city = h.host_city
)
SELECT * FROM joined   