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
                m.city,
                h.stadium_latitude,
                h.stadium_longitude,
                h.loaded_at
        FROM matches m
        LEFT JOIN host_cities h
                ON m.city = h.host_city
),

with_region AS (
         SELECT *,
                {{ get_region('stadium_longitude') }} AS region
    FROM joined
)

SELECT
    region,
    COUNT(*) AS matches_count
FROM with_region
GROUP BY region
ORDER BY matches_count DESC

