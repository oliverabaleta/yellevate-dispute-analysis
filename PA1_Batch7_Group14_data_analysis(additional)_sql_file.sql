--total and percentage of disputes per country
SELECT
country,
COUNT(*) AS total_disputes,
ROUND(100.0 * 
	  COUNT(*)/
	  (SELECT 
	   COUNT(*) 
	   FROM yellevate_disputes), 2) AS percentage
FROM yellevate_disputes
GROUP BY country;

--total and percentage of disputes that were lost and won per country
SELECT
country,
SUM(CASE
	WHEN dispute_case = 'Lost' THEN 1
END) AS total_lost_cases,
ROUND(100.0 * SUM(
	CASE
		WHEN dispute_case = 'Lost' THEN 1
		ELSE 0
	END)/
	COUNT(*), 2) AS lost_percentage,
SUM(CASE
	WHEN dispute_case = 'Won' THEN 1
END) AS total_won_cases,
ROUND(100.0 * SUM(
	CASE
		WHEN dispute_case = 'Won' THEN 1
		ELSE 0
	END)/
	COUNT(*), 2) AS won_percentage
FROM yellevate_disputes
GROUP BY country;

--total and percenetage of revenue lost and won
SELECT
dispute_case,
SUM(invoice_amount) AS total_revenue,
ROUND(100.0 *
	 SUM(invoice_amount)/
	 (SELECT
	 SUM(invoice_amount)
	 FROM yellevate_invoices), 2) AS percentage
FROM yellevate_invoices
GROUP BY dispute_case;

--total and percentage of settlement settled on time and late
SELECT
settlement,
COUNT(*) AS total,
ROUND(100.0 * 
	  COUNT(*)/
	  (SELECT 
	   COUNT(*) 
	   FROM yellevate_invoices), 2) AS percentage
FROM yellevate_invoices
GROUP BY settlement;

--total and percentage of on time and late settlements per country
SELECT
country,
SUM(CASE
		WHEN settlement = 'On Time' THEN 1
	END) AS on_time,
ROUND(100.0 *
	  SUM(CASE
		  	WHEN settlement = 'On Time' THEN 1
		  END)/
	  SUM(CASE
		  	WHEN settlement = 'On Time' THEN 1
		  	WHEN settlement = 'Past Due' THEN 1
		  END), 2) AS on_time_percentage,
SUM(CASE 
		WHEN settlement = 'Past Due' THEN 1
	END) AS past_due,
ROUND(100.0 *
	 SUM(CASE 
		 	WHEN settlement = 'Past Due' THEN 1
		 END)/
	  SUM(CASE
		  	WHEN settlement = 'On Time' THEN 1
		  	WHEN settlement = 'Past Due' THEN 1
		  END), 2) AS past_due_percentage
FROM yellevate_invoices
GROUP BY country;

--total number of customers
SELECT
COUNT(DISTINCT customer_id) AS customers
FROM yellevate_invoices;

--total and percentage of customers with disputed cases
SELECT
COUNT(DISTINCT customer_id) AS customers,
ROUND(100.0 *
	  COUNT(DISTINCT customer_id)/
	  (SELECT
	  COUNT(DISTINCT customer_id)
	  FROM yellevate_invoices), 2) AS percentage
FROM yellevate_disputes;

--total and percentage number of customers who have won cases
SELECT
COUNT(DISTINCT customer_id) AS customers,
ROUND(100.0 *
	  COUNT(DISTINCT customer_id)/
	  (SELECT
	  COUNT(DISTINCT customer_id)
	  FROM yellevate_disputes), 2) AS percentage
FROM yellevate_disputes
WHERE dispute_case = 'Lost';

--lost cases in each country per customer_id
SELECT 
customer_id,
SUM(CASE
		WHEN country = 'China' AND dispute_case = 'Lost' THEN 1
		ELSE 0
	END) AS china,
SUM(CASE
		WHEN country = 'France' AND dispute_case = 'Lost' THEN 1
		ELSE 0
	END) AS france,
SUM(CASE
		WHEN country = 'Russia' AND dispute_case = 'Lost' THEN 1
		ELSE 0
	END) AS russia,
SUM(CASE
		WHEN country = 'Spain' AND dispute_case = 'Lost' THEN 1
		ELSE 0
	END) AS spain,
SUM(CASE
		WHEN country = 'United States' AND dispute_case = 'Lost' THEN 1
		ELSE 0
	END) AS united_states
FROM yellevate_disputes
WHERE dispute_case = 'Lost'
GROUP BY customer_id
ORDER BY customer_id ASC;