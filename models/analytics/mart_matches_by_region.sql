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
                CASE 
                     WHEN stadium_longitude < -105 THEN 'West'
            WHEN stadium_longitude BETWEEN -105 AND -90 THEN 'Central'
            ELSE 'East'
        END AS region
    FROM joined
)

SELECT
    region,
    COUNT(*) AS matches_count
FROM with_region
GROUP BY region
ORDER BY matches_count DESC

