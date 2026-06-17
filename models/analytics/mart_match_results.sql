{{ config( 
    schema='ANALYTICS',
    materialized='incremental',
    unique_key='match_id'
)}}

WITH matches AS ( 
    SELECT * FROM {{ref('stg_matches')}}
)

SELECT 
      match_id,
      stage,
      group_name,
      city,
      stadium,
      loaded_at
FROM matches

{% if is_incremental() %} 
WHERE loaded_at > (SELECT MAX(loaded_at) FROM {{ this }})
{% endif %}