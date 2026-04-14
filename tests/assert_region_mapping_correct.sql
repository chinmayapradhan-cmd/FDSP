-- Test to ensure region mapping is correct
select *
from {{ ref('dim_customers') }}
where (country = 'IN' and region != 'APAC')
   or (country = 'US' and region != 'WEST')
   or (country = 'UK' and region != 'WEST')
