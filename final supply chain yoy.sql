with forecast_err_table_2020 as (
	select
	s.customer_code as customer_code,
	c.customer as customer_name,
	c.market as market,
	sum(s.sold_quantity) as total_sold_qty,
	sum(s.forecast_quantity) as total_forecast_qty,
	sum(s.forecast_quantity-s.sold_quantity) as net_error,
	round(sum(s.forecast_quantity-s.sold_quantity)*100/sum(s.forecast_quantity),1) as net_error_pct,
	sum(abs(s.forecast_quantity-s.sold_quantity)) as abs_error,
	round(sum(abs(s.forecast_quantity-sold_quantity))*100/sum(s.forecast_quantity),2) as abs_error_pct
	from fact_act_est s
	join dim_customer c
	on s.customer_code = c.customer_code
	where s.fiscal_year=2020
	group by customer_code),
forecast_2020 as (
select *,
if(abs_error_pct>100,0,100-abs_error_pct) as forecast_accuracy
from forecast_err_table_2020
order by forecast_accuracy desc),
forecast_err_table_2021 as (
	select
	s.customer_code as customer_code,
	c.customer as customer_name,
	c.market as market,
	sum(s.sold_quantity) as total_sold_qty,
	sum(s.forecast_quantity) as total_forecast_qty,
	sum(s.forecast_quantity-s.sold_quantity) as net_error,
	round(sum(s.forecast_quantity-s.sold_quantity)*100/sum(s.forecast_quantity),1) as net_error_pct,
	sum(abs(s.forecast_quantity-s.sold_quantity)) as abs_error,
	round(sum(abs(s.forecast_quantity-sold_quantity))*100/sum(s.forecast_quantity),2) as abs_error_pct
	from fact_act_est s
	join dim_customer c
	on s.customer_code = c.customer_code
	where s.fiscal_year=2021
	group by customer_code),
forecast_2021 as (
select *,
if(abs_error_pct>100,0,100-abs_error_pct) as forecast_accuracy
from forecast_err_table_2021
order by forecast_accuracy desc)
select
forecast_2020.customer_code,
forecast_2020.customer_name,
forecast_2020.market,
forecast_2020.forecast_accuracy as forecast_accuracy_2020,
forecast_2021.forecast_accuracy as forecast_accuracy_2021
from forecast_2020
join forecast_2021
using (customer_code)
where forecast_2021.forecast_accuracy < forecast_2020.forecast_accuracy
order by forecast_2020.forecast_accuracy desc