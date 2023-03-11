--total number of invoices
SELECT
COUNT(*) AS total_invoices
FROM yellevate_invoices;

--total and percentage of disputes
SELECT
disputed,
COUNT(*) AS total,
ROUND(100.0 * 
	  COUNT(*)/
	  (SELECT 
	   COUNT(*) 
	   FROM yellevate_invoices), 2) AS percentage
FROM yellevate_invoices
GROUP BY disputed;

--total and percentage of lost and won disputes
SELECT
dispute_case,
COUNT(*) AS total,
ROUND(100.0 * 
	  COUNT(*)/
	  (SELECT 
	   COUNT(*) 
	   FROM yellevate_disputes), 2) AS percentage
FROM yellevate_disputes
GROUP BY dispute_case;