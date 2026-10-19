select
    customer_id,
    customer_name,
    count(distinct case when order_status = 'completed' then order_id end) as total_completed_orders,
    coalesce(sum(case when order_status = 'completed' then order_revenue else 0 end), 0) as total_spent
from {{ ref('fct_orders') }}
group by 1, 2