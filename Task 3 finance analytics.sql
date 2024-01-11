-- Croma customer id: 90002002
SELECT
get_fiscal_year(s.date) as fiscal_year,
round(sum(s.sold_quantity * g.gross_price),2) as gross_sales_total
FROM fact_sales_monthly s
JOIN fact_gross_price g
ON s.product_code = g.product_code and get_fiscal_year(s.date) = g.fiscal_year
WHERE customer_code = 90002002
GROUP BY get_fiscal_year(s.date)