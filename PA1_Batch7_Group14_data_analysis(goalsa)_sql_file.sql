--average days for invoices to be settled
SELECT 
ROUND(AVG(days_settled), 0) AS avg_day_invoices
FROM yellevate_invoices;

--average days for invoices to be settled per country
SELECT 
country, 
ROUND(AVG(days_settled), 0) AS avg_day_invoices
FROM yellevate_invoices
GROUP BY country;

--average days for disputes to be settled
SELECT 
ROUND(AVG(days_settled), 0) AS avg_day_disputes
FROM yellevate_disputes;

--average days for disputes to be settled per country
SELECT 
country,
ROUND(AVG(days_settled), 0) AS avg_day_disputes
FROM yellevate_disputes
GROUP BY country;

--percentage of disputes that were lost and won
SELECT
ROUND(100.0 * SUM(
	CASE 
		WHEN dispute_case = 'Lost' THEN 1 
		ELSE 0
END)/COUNT(*), 2) AS lost_percentage,
ROUND(100.0 * SUM(
	CASE 
		WHEN dispute_case = 'Won' THEN 1 
		ELSE 0
END)/COUNT(*), 2) AS won_percentage
FROM yellevate_disputes;

--percentage of disputes that were lost and won per country
SELECT
country,
ROUND(100.0 * SUM(
	CASE 
		WHEN dispute_case = 'Lost' THEN 1 
		ELSE 0
END)/COUNT(*), 2) AS lost_percentage,
ROUND(100.0 * SUM(
	CASE 
		WHEN dispute_case = 'Won' THEN 1 
		ELSE 0
END)/COUNT(*), 2) AS won_percentage
FROM yellevate_disputes
GROUP BY country;

--percentage of revenue lost from disputes
SELECT
ROUND(100.0 * SUM(
	CASE 
		WHEN dispute_case = 'Lost' THEN invoice_amount 
		ELSE 0 
END)/SUM(invoice_amount), 2) AS revenue_lost_percentage,
ROUND(100.0 * SUM(
	CASE 
		WHEN dispute_case = 'Won' THEN invoice_amount 
		ELSE 0 
END)/SUM(invoice_amount), 2) AS revenue_won_percentage
FROM yellevate_invoices;

--percentage of revenue lost from disputes per country
SELECT 
country,
ROUND(100.0 * SUM(
	CASE 
		WHEN dispute_case = 'Lost' THEN invoice_amount 
		ELSE 0 
END)/SUM(invoice_amount), 2) AS revenue_lost_percentage
FROM yellevate_invoices
GROUP BY country;

--highest losses from lost disputes per country
SELECT 
country,
ROUND(SUM(
	CASE 
		WHEN dispute_case = 'Lost' THEN invoice_amount 
		ELSE 0
END), 2) AS lost_disputes
FROM yellevate_invoices
GROUP BY country;

--highest losses and percentage of lost per country
SELECT 
country,
SUM(CASE 
		WHEN dispute_case = 'Lost' THEN invoice_amount 
		ELSE 0 
END) AS lost_revenue,
ROUND(100.0 * SUM(
	CASE 
		WHEN dispute_case = 'Lost' THEN invoice_amount 
		ELSE 0 
END)/SUM(invoice_amount), 2) AS revenue_lost_percentage
FROM yellevate_invoices
GROUP BY country;