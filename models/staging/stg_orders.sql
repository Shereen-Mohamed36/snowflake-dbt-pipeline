with source as (
    select * from {{ source('raw', 'orders') }}
),

cleaned_and_deduplicated as (
    select
        order_id,
        customer_id,
        product_id,
        quantity::int as quantity,
        order_date::date as order_date,
        case 
            when lower(trim(status)) in ('completed', 'success', 'delivered') then 'completed'
            when lower(trim(status)) in ('pending', 'processing') then 'pending'
            when lower(trim(status)) in ('cancelled', 'canceled') then 'cancelled'
            else lower(trim(status))
        end as order_status,
        -- ترتيب الصفوف لحذف التكرار والإبقاء على أحدث أحدث سجل للطلب
        row_number() over (
            partition by order_id 
            order by order_date desc
        ) as row_num
    from source
)

select
    order_id,
    customer_id,
    product_id,
    quantity,
    order_date,
    order_status
from cleaned_and_deduplicated
where row_num = 1
  -- تصفية المفاتيح غير المرجعية (Invalid Foreign Keys) والحالات غير المعيارية
  and customer_id in (select customer_id from {{ ref('stg_customers') }})
  and product_id in (select product_id from {{ ref('stg_products') }})
  and order_status in ('completed', 'pending', 'cancelled')