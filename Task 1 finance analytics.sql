-- find out customer_code of Croma = "90002002"
SELECT * FROM dim_customer WHERE customer like "%croma%";

-- fact sales monthly for Croma only: 
-- they have date, product code, customer code, sold quantity
-- FY2021
SELECT *, 
get_fiscal_year(date) as fiscal_year,
get_fiscal_month(date) as fiscal_month
FROM fact_sales_monthly 
WHERE customer_code = "90002002" 
and get_fiscal_year(date) = 2021;
-- Join dim_product to find out product name
-- product code, product
SELECT product_code, product,variant FROM dim_product; 
-- Find out gross price in this FY: 
-- product code, fical year, gross price
SELECT product_code, fiscal_year, gross_price 
FROM fact_gross_price 
WHERE fiscal_year = 2021 ;

with sale as (
SELECT *, 
get_fiscal_year(date) as fiscal_year,
get_fiscal_month(date) as fiscal_month
FROM fact_sales_monthly 
WHERE customer_code = "90002002" 
and get_fiscal_year(date) = 2021
),
product_info as (
SELECT product_code, product,variant FROM dim_product
),
gross_prod_info as (
SELECT product_code, fiscal_year, gross_price 
FROM fact_gross_price 
WHERE fiscal_year = 2021
)
select 
sale.fiscal_month, sale.product_code,
product_info.product as product_name, product_info.variant,
gross_prod_info.gross_price as gross_price_per_item,
round(gross_prod_info.gross_price*sale.sold_quantity,2) as total_gross_price
from sale
join product_info 
on sale.product_code = product_info.product_code
join gross_prod_info 
on sale.product_code = gross_prod_info.product_code and get_fiscal_year(sale.date) = gross_prod_info.fiscal_year

