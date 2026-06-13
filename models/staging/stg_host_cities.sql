WITH source AS (
    SELECT * FROM {{ ref('fifa_2026_host_cities')}}
),
    staged AS (
        SELECT
              TRIM (City)                                  AS host_city,
              TRIM (Country)                               AS host_country,      
              TRIM (Stadium)                               AS stadium_name,
              CAST (Capacity AS INT)                       AS stadium_capacity,
              CAST (Latitude AS FLOAT)                     AS stadium_latitude,
              CAST (Longitude AS FLOAT)                    AS stadium_longitude,
              CURRENT_TIMESTAMP()::TIMESTAMP_NTZ           AS loaded_at
    FROM source
    )
    SELECT * FROM staged