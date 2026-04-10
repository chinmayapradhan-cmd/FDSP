select
    customer_id,
    trim(customer_name) as customer_name,
    upper(country) as country,
    lower(status) as status
from {{ ref('raw_customers') }}