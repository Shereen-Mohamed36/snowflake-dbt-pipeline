select
    category,
    count(distinct case when order_status = 'completed' then order_id end) as completed_orders_count,
    coalesce(sum(case when order_status = 'completed' then order_revenue else 0 end), 0) as total_category_revenue
from {{ ref('fct_orders') }}
group by 1