select
    product_id,
    trim(product_name) as product_name,
    category,
    price::decimal(10,2) as price
from {{ source('raw', 'products') }}