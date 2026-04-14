-- Test to ensure dim_customers has at least one record
select count(*) as record_count
from {{ ref('dim_customers') }}
having count(*) = 0
