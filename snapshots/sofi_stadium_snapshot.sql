{% snapshot sofi_stadium_snapshot %}

{{

  config(
        target_schema = 'SNAPSHOTS',
        unique_key = 'stadium_name',
        strategy = 'check',
        check_cols = ['stadium_capacity']
  )
}}
  SELECT
        stadium_name,
        host_country,
        stadium_capacity
  FROM {{ ref('stg_host_cities') }}
  
 {% endsnapshot %}

