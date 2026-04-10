select
    customer_id,
    customer_name,
    country,
    status,
    case
        when country = 'IN' then 'APAC'
        when country in ('US', 'UK') then 'WEST'
        else 'OTHER'
    end as region
from {{ ref('stg_customers') }}
where status = 'active'