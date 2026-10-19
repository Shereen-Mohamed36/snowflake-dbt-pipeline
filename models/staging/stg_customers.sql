select
    customer_id,
    trim(customer_name) as customer_name,
    lower(trim(email)) as email,
    city,
    signup_date::date as signup_date
from {{ source('raw', 'customers') }}