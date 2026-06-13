WITH source AS ( 
    SELECT * FROM {{ ref('fifa_2026_matches')}}
),
    staged AS ( 
        SELECT 
                CAST (MatchID AS INT)                          AS match_id,
                TRIM (Stage)                                   AS stage,
                TRIM (group_name)                              AS group_name,
                TRIM (City)                                    AS city,
                TRIM (Stadium)                                 AS stadium,
                CURRENT_TIMESTAMP()::TIMESTAMP_NTZ             AS loaded_at
        FROM source
    )
    SELECT * FROM staged