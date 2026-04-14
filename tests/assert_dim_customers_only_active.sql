-- Test to ensure dim_customers only contains active customers
select *
from {{ ref('dim_customers') }}
where status != 'active'
